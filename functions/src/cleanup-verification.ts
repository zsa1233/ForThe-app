/**
 * Cleanup Verification Cloud Function
 * 
 * This function is triggered when a new cleanup submission is created in Firestore.
 * It verifies the cleanup by:
 * 1. Validating location against hotspot data
 * 2. Analyzing before/after images using Google Cloud Vision API
 * 3. Updating user stats and badges if verified
 * 4. Updating submission status with verification results
 */

import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { logger } from 'firebase-functions';
import { verifyLocation, isValidCoordinates, Coordinates } from './utils/location';
import { 
  analyzeCleanupImage, 
  calculateCleanupEffectiveness, 
  isValidImageUrl 
} from './utils/vision';
import { 
  calculateNewBadges, 
  calculatePoints, 
  validateUserStats, 
  UserStats,
  formatBadgeAchievements
} from './utils/badges';

// Initialize Firebase Admin
admin.initializeApp();
const db = admin.firestore();

// Configuration constants
const LOCATION_VERIFICATION_RADIUS_METERS = 100;
const MIN_CLEANUP_EFFECTIVENESS_THRESHOLD = 70; // 70% trash reduction required

// Collection names
const COLLECTIONS = {
  CLEANUP_SUBMISSIONS: 'cleanup_submissions',
  PREDICTED_HOTSPOTS: 'predicted_hotspots',
  USERS: 'users',
  VERIFICATION_LOGS: 'verification_logs'
} as const;

/**
 * Cleanup submission interface
 */
interface CleanupSubmission {
  userId: string;
  hotspotId?: string;
  userLocation: {
    latitude: number;
    longitude: number;
  };
  beforePhotoURL: string;
  afterPhotoURL: string;
  reportedPounds: number;
  type?: string;
  comments?: string;
  status: 'pending' | 'approved' | 'rejected' | 'error';
  createdAt: admin.firestore.Timestamp;
  submissionId?: string;
}

/**
 * Verification result interface
 */
interface VerificationResult {
  status: 'approved' | 'rejected' | 'error';
  message: string;
  details: {
    locationVerified: boolean;
    imageAnalysis: {
      beforeAnalysis: any;
      afterAnalysis: any;
      effectiveness: any;
    };
    pointsAwarded?: number;
    badgesEarned?: string[];
    error?: string;
  };
  verifiedAt: admin.firestore.Timestamp;
  executionTimeMs: number;
}

/**
 * Main cleanup verification function
 */
export const verifyCleanup = functions.firestore
  .document(`${COLLECTIONS.CLEANUP_SUBMISSIONS}/{submissionId}`)
  .onCreate(async (snapshot: functions.firestore.DocumentSnapshot, context: functions.EventContext) => {
    const startTime = Date.now();
    const submissionId = context.params.submissionId;

    if (!snapshot || !submissionId) {
      logger.error('Invalid event data or missing submission ID');
      return;
    }

    const submission = snapshot.data() as CleanupSubmission;
    submission.submissionId = submissionId;

    logger.info(`Starting cleanup verification for submission ${submissionId}`, {
      userId: submission.userId,
      submissionId
    });

    try {
      // Step 1: Validate submission data
      const validationResult = await validateSubmissionData(submission);
      if (!validationResult.isValid) {
        await updateSubmissionStatus(submissionId, {
          status: 'rejected',
          message: validationResult.message,
          details: {
            ...validationResult.details,
            locationVerified: false,
            imageAnalysis: {
              beforeAnalysis: {},
              afterAnalysis: {},
              effectiveness: {}
            }
          },
          verifiedAt: admin.firestore.Timestamp.now(),
          executionTimeMs: Date.now() - startTime
        });
        return;
      }

      // Step 2: Verify location (if hotspot provided)
      let locationVerified = true;
      if (submission.hotspotId) {
        locationVerified = await verifySubmissionLocation(submission);
        if (!locationVerified) {
          await updateSubmissionStatus(submissionId, {
            status: 'rejected',
            message: 'Location verification failed - cleanup not within hotspot radius',
            details: {
              locationVerified: false,
              imageAnalysis: {
                beforeAnalysis: {},
                afterAnalysis: {},
                effectiveness: {}
              },
            },
            verifiedAt: admin.firestore.Timestamp.now(),
            executionTimeMs: Date.now() - startTime
          });
          return;
        }
      }

      // Step 3: Analyze images with Vision API
      const imageAnalysis = await analyzeCleanupImages(
        submission.beforePhotoURL,
        submission.afterPhotoURL
      );

      // Step 4: Calculate cleanup effectiveness
      const effectiveness = calculateCleanupEffectiveness(
        imageAnalysis.beforeAnalysis,
        imageAnalysis.afterAnalysis
      );

      // Step 5: Determine if cleanup is approved
      const isApproved = effectiveness.isEffective && 
                        effectiveness.reductionPercentage >= MIN_CLEANUP_EFFECTIVENESS_THRESHOLD;

      if (isApproved) {
        // Step 6: Update user stats and badges
        const userUpdate = await updateUserStatsAndBadges(
          submission.userId,
          submission.reportedPounds,
          submission.type
        );

        await updateSubmissionStatus(submissionId, {
          status: 'approved',
          message: `Cleanup verified successfully! ${effectiveness.reductionPercentage.toFixed(1)}% trash reduction detected.`,
          details: {
            locationVerified,
            imageAnalysis: {
              beforeAnalysis: imageAnalysis.beforeAnalysis,
              afterAnalysis: imageAnalysis.afterAnalysis,
              effectiveness
            },
            pointsAwarded: userUpdate.pointsAwarded,
            badgesEarned: userUpdate.newBadges
          },
          verifiedAt: admin.firestore.Timestamp.now(),
          executionTimeMs: Date.now() - startTime
        });

        logger.info(`Cleanup approved for submission ${submissionId}`, {
          userId: submission.userId,
          pointsAwarded: userUpdate.pointsAwarded,
          newBadges: userUpdate.newBadges,
          effectiveness: effectiveness.reductionPercentage
        });

      } else {
        await updateSubmissionStatus(submissionId, {
          status: 'rejected',
          message: `Insufficient cleanup detected. ${effectiveness.reductionPercentage.toFixed(1)}% reduction (minimum ${MIN_CLEANUP_EFFECTIVENESS_THRESHOLD}% required).`,
          details: {
            locationVerified,
            imageAnalysis: {
              beforeAnalysis: imageAnalysis.beforeAnalysis,
              afterAnalysis: imageAnalysis.afterAnalysis,
              effectiveness
            }
          },
          verifiedAt: admin.firestore.Timestamp.now(),
          executionTimeMs: Date.now() - startTime
        });

        logger.info(`Cleanup rejected for submission ${submissionId}`, {
          userId: submission.userId,
          effectiveness: effectiveness.reductionPercentage,
          threshold: MIN_CLEANUP_EFFECTIVENESS_THRESHOLD
        });
      }

      // Log verification details
      await logVerificationDetails(submissionId, submission, effectiveness, locationVerified);

    } catch (error) {
      logger.error(`Error verifying cleanup ${submissionId}:`, error);
      
      await updateSubmissionStatus(submissionId, {
        status: 'error',
        message: `Verification error: ${error instanceof Error ? error.message : 'Unknown error'}`,
        details: {
          locationVerified: false,
          imageAnalysis: {
            beforeAnalysis: {},
            afterAnalysis: {},
            effectiveness: {}
          },
          error: error instanceof Error ? error.message : 'Unknown error'
        },
        verifiedAt: admin.firestore.Timestamp.now(),
        executionTimeMs: Date.now() - startTime
      });
    }
  }
);

/**
 * Validates submission data structure and content
 */
async function validateSubmissionData(submission: CleanupSubmission): Promise<{
  isValid: boolean;
  message: string;
  details: any;
}> {
  const errors = [];

  // Check required fields
  if (!submission.userId) {
    errors.push('Missing userId');
  }
  
  if (!submission.beforePhotoURL || !isValidImageUrl(submission.beforePhotoURL)) {
    errors.push('Invalid before photo URL');
  }
  
  if (!submission.afterPhotoURL || !isValidImageUrl(submission.afterPhotoURL)) {
    errors.push('Invalid after photo URL');
  }

  if (!submission.userLocation || !isValidCoordinates(submission.userLocation)) {
    errors.push('Invalid user location coordinates');
  }

  if (typeof submission.reportedPounds !== 'number' || submission.reportedPounds <= 0) {
    errors.push('Invalid reported pounds amount');
  }

  if (submission.reportedPounds > 1000) {
    errors.push('Reported pounds amount seems unrealistic (>1000 lbs)');
  }

  // Check that before and after images are different
  if (submission.beforePhotoURL === submission.afterPhotoURL) {
    errors.push('Before and after photos cannot be the same');
  }

  return {
    isValid: errors.length === 0,
    message: errors.length > 0 ? errors.join('; ') : 'Validation successful',
    details: { validationErrors: errors }
  };
}

/**
 * Verifies cleanup location against hotspot
 */
async function verifySubmissionLocation(submission: CleanupSubmission): Promise<boolean> {
  try {
    if (!submission.hotspotId) {
      return true; // Skip location verification if no hotspot specified
    }

    const hotspotDoc = await db
      .collection(COLLECTIONS.PREDICTED_HOTSPOTS)
      .doc(submission.hotspotId)
      .get();

    if (!hotspotDoc.exists) {
      logger.warn(`Hotspot not found: ${submission.hotspotId}`);
      return false;
    }

    const hotspot = hotspotDoc.data();
    if (!hotspot?.location) {
      logger.warn(`Hotspot missing location data: ${submission.hotspotId}`);
      return false;
    }

    const hotspotLocation: Coordinates = {
      latitude: hotspot.location.latitude,
      longitude: hotspot.location.longitude
    };

    return verifyLocation(
      submission.userLocation,
      hotspotLocation,
      LOCATION_VERIFICATION_RADIUS_METERS
    );

  } catch (error) {
    logger.error('Error verifying location:', error);
    return false;
  }
}

/**
 * Analyzes before and after images using Vision API
 */
async function analyzeCleanupImages(beforeUrl: string, afterUrl: string) {
  try {
    logger.info('Starting image analysis', { beforeUrl, afterUrl });

    // Analyze both images in parallel
    const [beforeAnalysis, afterAnalysis] = await Promise.all([
      analyzeCleanupImage(beforeUrl),
      analyzeCleanupImage(afterUrl)
    ]);

    logger.info('Image analysis completed', {
      beforeTrashCount: beforeAnalysis.trashCount,
      afterTrashCount: afterAnalysis.trashCount,
      beforeConfidence: beforeAnalysis.confidence,
      afterConfidence: afterAnalysis.confidence
    });

    return {
      beforeAnalysis,
      afterAnalysis
    };

  } catch (error) {
    logger.error('Error analyzing images:', error);
    throw new Error(`Image analysis failed: ${error instanceof Error ? error.message : 'Unknown error'}`);
  }
}

/**
 * Updates user stats and calculates new badges
 */
async function updateUserStatsAndBadges(
  userId: string,
  poundsCollected: number,
  cleanupType?: string
): Promise<{
  pointsAwarded: number;
  newBadges: string[];
}> {
  const userRef = db.collection(COLLECTIONS.USERS).doc(userId);

  return await db.runTransaction(async (transaction: admin.firestore.Transaction) => {
    const userDoc = await transaction.get(userRef);
    
    if (!userDoc.exists) {
      throw new Error('User document not found');
    }

    const currentStats = userDoc.data() as UserStats;
    
    if (!validateUserStats(currentStats)) {
      throw new Error('Invalid user stats format');
    }

    // Calculate points earned
    const pointsAwarded = calculatePoints(poundsCollected, cleanupType);

    // Calculate new stats
    const newStats: UserStats = {
      points: currentStats.points + pointsAwarded,
      poundsCollected: currentStats.poundsCollected + poundsCollected,
      totalCleanups: currentStats.totalCleanups + 1,
      currentStreak: currentStats.currentStreak || 0, // TODO: Implement streak logic
      badges: [...(currentStats.badges || [])]
    };

    // Calculate newly earned badges
    const newBadges = calculateNewBadges(currentStats, newStats);
    newStats.badges.push(...newBadges);

    // Update user document
    transaction.update(userRef, {
      points: newStats.points,
      poundsCollected: newStats.poundsCollected,
      totalCleanups: newStats.totalCleanups,
      badges: newStats.badges,
      lastCleanupAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp()
    });

    // Log badge achievements
    if (newBadges.length > 0) {
      const achievements = formatBadgeAchievements(newBadges);
      logger.info(`New badges earned for user ${userId}:`, achievements);
    }

    return {
      pointsAwarded,
      newBadges
    };
  });
}

/**
 * Updates submission status in Firestore
 */
async function updateSubmissionStatus(
  submissionId: string,
  result: VerificationResult
): Promise<void> {
  try {
    await db.collection(COLLECTIONS.CLEANUP_SUBMISSIONS).doc(submissionId).update({
      status: result.status,
      verificationMessage: result.message,
      verificationDetails: result.details,
      verifiedAt: result.verifiedAt,
      processingTimeMs: result.executionTimeMs,
      updatedAt: admin.firestore.FieldValue.serverTimestamp()
    });

    logger.info(`Updated submission ${submissionId} status to ${result.status}`);

  } catch (error) {
    logger.error(`Error updating submission status for ${submissionId}:`, error);
    throw error;
  }
}

/**
 * Logs detailed verification information for monitoring and debugging
 */
async function logVerificationDetails(
  submissionId: string,
  submission: CleanupSubmission,
  effectiveness: any,
  locationVerified: boolean
): Promise<void> {
  try {
    await db.collection(COLLECTIONS.VERIFICATION_LOGS).add({
      submissionId,
      userId: submission.userId,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
      locationVerified,
      hotspotId: submission.hotspotId || null,
      effectiveness: {
        reductionPercentage: effectiveness.reductionPercentage,
        overallConfidence: effectiveness.overallConfidence,
        isEffective: effectiveness.isEffective,
        beforeCount: effectiveness.beforeCount,
        afterCount: effectiveness.afterCount
      },
      reportedPounds: submission.reportedPounds,
      cleanupType: submission.type || 'unknown'
    });

  } catch (error) {
    // Don't throw here as logging failures shouldn't break verification
    logger.warn('Failed to log verification details:', error);
  }
}