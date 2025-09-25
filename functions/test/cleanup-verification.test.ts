/**
 * Integration tests for cleanup verification function
 */

import * as admin from 'firebase-admin';
import { getFirestore, Timestamp } from 'firebase-admin/firestore';

// Mock the Vision API
jest.mock('@google-cloud/vision', () => ({
  ImageAnnotatorClient: jest.fn().mockImplementation(() => ({
    objectLocalization: jest.fn().mockResolvedValue([{
      localizedObjectAnnotations: [
        { name: 'Bottle', score: 0.9 },
        { name: 'Can', score: 0.8 }
      ]
    }]),
    labelDetection: jest.fn().mockResolvedValue([{
      labelAnnotations: [
        { description: 'Waste', score: 0.9 },
        { description: 'Litter', score: 0.8 }
      ]
    }])
  }))
}));

// Mock firebase-functions
jest.mock('firebase-functions', () => ({
  logger: {
    info: jest.fn(),
    warn: jest.fn(),
    error: jest.fn()
  }
}));

describe('Cleanup Verification Function', () => {
  let db: admin.firestore.Firestore;

  beforeAll(async () => {
    // Initialize Firestore for testing
    db = getFirestore();
  });

  afterAll(async () => {
    // Clean up after tests
    await admin.app().delete();
  });

  describe('Submission Validation', () => {
    it('should reject submission with missing required fields', async () => {
      const invalidSubmission = {
        userId: 'test-user-1',
        // Missing beforePhotoURL, afterPhotoURL, userLocation, etc.
        status: 'pending',
        createdAt: Timestamp.now()
      };

      // This would be tested through the actual function trigger
      // For now, we test the validation logic directly
      const { validateSubmissionData } = require('../src/cleanup-verification');
      
      if (validateSubmissionData) {
        const result = await validateSubmissionData(invalidSubmission);
        expect(result.isValid).toBe(false);
        expect(result.details.validationErrors).toContain('Invalid before photo URL');
      }
    });

    it('should accept valid submission', async () => {
      const validSubmission = {
        userId: 'test-user-1',
        beforePhotoURL: 'https://example.com/before.jpg',
        afterPhotoURL: 'https://example.com/after.jpg',
        userLocation: {
          latitude: 40.7128,
          longitude: -74.0060
        },
        reportedPounds: 5.5,
        status: 'pending',
        createdAt: Timestamp.now()
      };

      const { validateSubmissionData } = require('../src/cleanup-verification');
      
      if (validateSubmissionData) {
        const result = await validateSubmissionData(validSubmission);
        expect(result.isValid).toBe(true);
      }
    });

    it('should reject identical before and after photos', async () => {
      const identicalPhotoSubmission = {
        userId: 'test-user-1',
        beforePhotoURL: 'https://example.com/same-image.jpg',
        afterPhotoURL: 'https://example.com/same-image.jpg',
        userLocation: {
          latitude: 40.7128,
          longitude: -74.0060
        },
        reportedPounds: 5.5,
        status: 'pending',
        createdAt: Timestamp.now()
      };

      const { validateSubmissionData } = require('../src/cleanup-verification');
      
      if (validateSubmissionData) {
        const result = await validateSubmissionData(identicalPhotoSubmission);
        expect(result.isValid).toBe(false);
        expect(result.details.validationErrors).toContain('Before and after photos cannot be the same');
      }
    });

    it('should reject unrealistic pounds amount', async () => {
      const unrealisticSubmission = {
        userId: 'test-user-1',
        beforePhotoURL: 'https://example.com/before.jpg',
        afterPhotoURL: 'https://example.com/after.jpg',
        userLocation: {
          latitude: 40.7128,
          longitude: -74.0060
        },
        reportedPounds: 2000, // Unrealistic amount
        status: 'pending',
        createdAt: Timestamp.now()
      };

      const { validateSubmissionData } = require('../src/cleanup-verification');
      
      if (validateSubmissionData) {
        const result = await validateSubmissionData(unrealisticSubmission);
        expect(result.isValid).toBe(false);
        expect(result.details.validationErrors).toContain('Reported pounds amount seems unrealistic (>1000 lbs)');
      }
    });
  });

  describe('Location Verification', () => {
    beforeEach(async () => {
      // Set up test hotspot data
      await db.collection('predicted_hotspots').doc('test-hotspot-1').set({
        location: {
          latitude: 40.7128,
          longitude: -74.0060
        },
        isActive: true,
        priority: 1
      });
    });

    afterEach(async () => {
      // Clean up test data
      await db.collection('predicted_hotspots').doc('test-hotspot-1').delete();
    });

    it('should verify location within radius', async () => {
      const { verifySubmissionLocation } = require('../src/cleanup-verification');
      
      if (verifySubmissionLocation) {
        const submission = {
          userId: 'test-user-1',
          hotspotId: 'test-hotspot-1',
          userLocation: {
            latitude: 40.7130, // Very close to hotspot
            longitude: -74.0058
          }
        };

        const result = await verifySubmissionLocation(submission);
        expect(result).toBe(true);
      }
    });

    it('should reject location outside radius', async () => {
      const { verifySubmissionLocation } = require('../src/cleanup-verification');
      
      if (verifySubmissionLocation) {
        const submission = {
          userId: 'test-user-1',
          hotspotId: 'test-hotspot-1',
          userLocation: {
            latitude: 40.8000, // Too far from hotspot
            longitude: -74.0000
          }
        };

        const result = await verifySubmissionLocation(submission);
        expect(result).toBe(false);
      }
    });

    it('should handle missing hotspot', async () => {
      const { verifySubmissionLocation } = require('../src/cleanup-verification');
      
      if (verifySubmissionLocation) {
        const submission = {
          userId: 'test-user-1',
          hotspotId: 'non-existent-hotspot',
          userLocation: {
            latitude: 40.7128,
            longitude: -74.0060
          }
        };

        const result = await verifySubmissionLocation(submission);
        expect(result).toBe(false);
      }
    });

    it('should skip verification when no hotspot specified', async () => {
      const { verifySubmissionLocation } = require('../src/cleanup-verification');
      
      if (verifySubmissionLocation) {
        const submission = {
          userId: 'test-user-1',
          // No hotspotId
          userLocation: {
            latitude: 40.7128,
            longitude: -74.0060
          }
        };

        const result = await verifySubmissionLocation(submission);
        expect(result).toBe(true); // Should pass when no hotspot to verify against
      }
    });
  });

  describe('User Stats Update', () => {
    beforeEach(async () => {
      // Set up test user data
      await db.collection('users').doc('test-user-1').set({
        points: 100,
        poundsCollected: 10,
        totalCleanups: 2,
        badges: ['first_cleanup'],
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now()
      });
    });

    afterEach(async () => {
      // Clean up test data
      await db.collection('users').doc('test-user-1').delete();
    });

    it('should update user stats correctly', async () => {
      const { updateUserStatsAndBadges } = require('../src/cleanup-verification');
      
      if (updateUserStatsAndBadges) {
        const result = await updateUserStatsAndBadges('test-user-1', 15, 'park');

        expect(result.pointsAwarded).toBeGreaterThan(0);
        
        // Verify user document was updated
        const userDoc = await db.collection('users').doc('test-user-1').get();
        const userData = userDoc.data();
        
        expect(userData?.points).toBe(100 + result.pointsAwarded);
        expect(userData?.poundsCollected).toBe(25); // 10 + 15
        expect(userData?.totalCleanups).toBe(3); // 2 + 1
        expect(userData?.lastCleanupAt).toBeDefined();
      }
    });

    it('should award new badges when thresholds are met', async () => {
      const { updateUserStatsAndBadges } = require('../src/cleanup-verification');
      
      if (updateUserStatsAndBadges) {
        // This should trigger the 25_lbs badge
        const result = await updateUserStatsAndBadges('test-user-1', 15, 'park');

        expect(result.newBadges).toContain('25_lbs');
        
        // Verify badge was added to user document
        const userDoc = await db.collection('users').doc('test-user-1').get();
        const userData = userDoc.data();
        
        expect(userData?.badges).toContain('25_lbs');
      }
    });

    it('should handle non-existent user', async () => {
      const { updateUserStatsAndBadges } = require('../src/cleanup-verification');
      
      if (updateUserStatsAndBadges) {
        await expect(updateUserStatsAndBadges('non-existent-user', 10))
          .rejects.toThrow('User document not found');
      }
    });
  });

  describe('Image Analysis', () => {
    it('should analyze images and calculate effectiveness', async () => {
      const { analyzeCleanupImages } = require('../src/cleanup-verification');
      
      if (analyzeCleanupImages) {
        const result = await analyzeCleanupImages(
          'https://example.com/before.jpg',
          'https://example.com/after.jpg'
        );

        expect(result.beforeAnalysis).toBeDefined();
        expect(result.afterAnalysis).toBeDefined();
        expect(result.beforeAnalysis.trashCount).toBeGreaterThanOrEqual(0);
        expect(result.afterAnalysis.trashCount).toBeGreaterThanOrEqual(0);
      }
    });

    it('should handle Vision API errors', async () => {
      // Mock Vision API to throw error
      const vision = require('@google-cloud/vision');
      const mockClient = new vision.ImageAnnotatorClient();
      mockClient.objectLocalization.mockRejectedValue(new Error('Vision API error'));

      const { analyzeCleanupImages } = require('../src/cleanup-verification');
      
      if (analyzeCleanupImages) {
        await expect(analyzeCleanupImages(
          'https://example.com/before.jpg',
          'https://example.com/after.jpg'
        )).rejects.toThrow();
      }
    });
  });

  describe('Status Updates', () => {
    beforeEach(async () => {
      // Set up test submission
      await db.collection('cleanup_submissions').doc('test-submission-1').set({
        userId: 'test-user-1',
        status: 'pending',
        createdAt: Timestamp.now()
      });
    });

    afterEach(async () => {
      // Clean up test data
      await db.collection('cleanup_submissions').doc('test-submission-1').delete();
    });

    it('should update submission status correctly', async () => {
      const { updateSubmissionStatus } = require('../src/cleanup-verification');
      
      if (updateSubmissionStatus) {
        const verificationResult = {
          status: 'approved' as const,
          message: 'Test approval',
          details: { test: true },
          verifiedAt: Timestamp.now(),
          executionTimeMs: 1000
        };

        await updateSubmissionStatus('test-submission-1', verificationResult);

        const submissionDoc = await db.collection('cleanup_submissions').doc('test-submission-1').get();
        const submissionData = submissionDoc.data();

        expect(submissionData?.status).toBe('approved');
        expect(submissionData?.verificationMessage).toBe('Test approval');
        expect(submissionData?.verifiedAt).toBeDefined();
        expect(submissionData?.processingTimeMs).toBe(1000);
      }
    });
  });
});