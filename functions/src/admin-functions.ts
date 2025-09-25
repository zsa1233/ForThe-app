/**
 * Administrative and utility functions for Terra cleanup system
 */

import { onCall, HttpsError } from 'firebase-functions/v2/https';
import { getFirestore, Timestamp } from 'firebase-admin/firestore';
import { logger } from 'firebase-functions';

const db = getFirestore();

/**
 * Gets user statistics and verification history
 */
export const getUserStats = onCall(
  {
    region: 'us-central1',
    enforceAppCheck: true
  },
  async (request) => {
    const { userId } = request.data;
    
    if (!userId) {
      throw new HttpsError('invalid-argument', 'userId is required');
    }

    // Verify user has permission to access this data
    if (request.auth?.uid !== userId) {
      throw new HttpsError('permission-denied', 'Cannot access other user data');
    }

    try {
      const userDoc = await db.collection('users').doc(userId).get();
      if (!userDoc.exists) {
        throw new HttpsError('not-found', 'User not found');
      }

      // Get recent submissions
      const submissionsSnapshot = await db
        .collection('cleanup_submissions')
        .where('userId', '==', userId)
        .orderBy('createdAt', 'desc')
        .limit(10)
        .get();

      const submissions = submissionsSnapshot.docs.map(doc => ({
        id: doc.id,
        ...doc.data()
      }));

      return {
        user: userDoc.data(),
        recentSubmissions: submissions,
        timestamp: Timestamp.now()
      };

    } catch (error) {
      logger.error('Error getting user stats:', error);
      throw new HttpsError('internal', 'Failed to retrieve user stats');
    }
  }
);

/**
 * Gets system-wide verification statistics (admin only)
 */
export const getVerificationStats = onCall(
  {
    region: 'us-central1',
    enforceAppCheck: true
  },
  async (request) => {
    // Check if user is admin
    const userDoc = await db.collection('users').doc(request.auth?.uid || '').get();
    if (!userDoc.exists || !userDoc.data()?.isAdmin) {
      throw new HttpsError('permission-denied', 'Admin access required');
    }

    try {
      const now = new Date();
      const yesterday = new Date(now.getTime() - 24 * 60 * 60 * 1000);
      const weekAgo = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000);

      // Get submission counts by status
      const [
        totalSubmissions,
        approvedSubmissions,
        rejectedSubmissions,
        errorSubmissions,
        recentSubmissions,
        weeklySubmissions
      ] = await Promise.all([
        db.collection('cleanup_submissions').count().get(),
        db.collection('cleanup_submissions').where('status', '==', 'approved').count().get(),
        db.collection('cleanup_submissions').where('status', '==', 'rejected').count().get(),
        db.collection('cleanup_submissions').where('status', '==', 'error').count().get(),
        db.collection('cleanup_submissions')
          .where('createdAt', '>=', Timestamp.fromDate(yesterday))
          .count().get(),
        db.collection('cleanup_submissions')
          .where('createdAt', '>=', Timestamp.fromDate(weekAgo))
          .count().get()
      ]);

      // Get verification logs for analysis
      const verificationLogsSnapshot = await db
        .collection('verification_logs')
        .where('timestamp', '>=', Timestamp.fromDate(weekAgo))
        .get();

      const verificationLogs = verificationLogsSnapshot.docs.map(doc => doc.data());
      
      // Calculate average effectiveness
      const effectivenessScores = verificationLogs
        .map(log => log.effectiveness?.reductionPercentage)
        .filter(score => typeof score === 'number');
      
      const avgEffectiveness = effectivenessScores.length > 0
        ? effectivenessScores.reduce((a, b) => a + b, 0) / effectivenessScores.length
        : 0;

      return {
        summary: {
          total: totalSubmissions.data().count,
          approved: approvedSubmissions.data().count,
          rejected: rejectedSubmissions.data().count,
          error: errorSubmissions.data().count,
          last24Hours: recentSubmissions.data().count,
          lastWeek: weeklySubmissions.data().count
        },
        analytics: {
          approvalRate: totalSubmissions.data().count > 0 
            ? (approvedSubmissions.data().count / totalSubmissions.data().count) * 100 
            : 0,
          averageEffectiveness: avgEffectiveness,
          totalVerificationLogs: verificationLogs.length
        },
        timestamp: Timestamp.now()
      };

    } catch (error) {
      logger.error('Error getting verification stats:', error);
      throw new HttpsError('internal', 'Failed to retrieve verification stats');
    }
  }
);

/**
 * Reprocesses a failed submission (admin only)
 */
export const reprocessSubmission = onCall(
  {
    region: 'us-central1',
    enforceAppCheck: true
  },
  async (request) => {
    const { submissionId } = request.data;
    
    if (!submissionId) {
      throw new HttpsError('invalid-argument', 'submissionId is required');
    }

    // Check if user is admin
    const userDoc = await db.collection('users').doc(request.auth?.uid || '').get();
    if (!userDoc.exists || !userDoc.data()?.isAdmin) {
      throw new HttpsError('permission-denied', 'Admin access required');
    }

    try {
      const submissionRef = db.collection('cleanup_submissions').doc(submissionId);
      const submissionDoc = await submissionRef.get();

      if (!submissionDoc.exists) {
        throw new HttpsError('not-found', 'Submission not found');
      }

      const submission = submissionDoc.data();
      
      // Only allow reprocessing of error status submissions
      if (submission?.status !== 'error') {
        throw new HttpsError('failed-precondition', 'Can only reprocess error status submissions');
      }

      // Reset submission to pending status to trigger reprocessing
      await submissionRef.update({
        status: 'pending',
        reprocessedAt: Timestamp.now(),
        reprocessedBy: request.auth?.uid,
        updatedAt: Timestamp.now()
      });

      logger.info(`Submission ${submissionId} queued for reprocessing by ${request.auth?.uid}`);

      return {
        success: true,
        message: 'Submission queued for reprocessing',
        submissionId,
        timestamp: Timestamp.now()
      };

    } catch (error) {
      logger.error('Error reprocessing submission:', error);
      throw new HttpsError('internal', 'Failed to reprocess submission');
    }
  }
);

/**
 * Health check endpoint for monitoring
 */
export const healthCheck = onCall(
  {
    region: 'us-central1'
  },
  async () => {
    try {
      // Test Firestore connection
      const testDoc = await db.collection('_health_check').doc('test').get();
      
      // Test basic functionality
      const now = Timestamp.now();
      
      return {
        status: 'healthy',
        timestamp: now,
        services: {
          firestore: 'connected',
          functions: 'operational'
        },
        version: '1.0.0'
      };

    } catch (error) {
      logger.error('Health check failed:', error);
      return {
        status: 'unhealthy',
        timestamp: Timestamp.now(),
        error: error instanceof Error ? error.message : 'Unknown error'
      };
    }
  }
);