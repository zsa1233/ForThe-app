/**
 * Tests for vision utilities
 */

import {
  countPotentialTrash,
  countTrashInLabels,
  categorizeTrashByType,
  isValidImageUrl,
  calculateCleanupEffectiveness
} from '../../src/utils/vision';

// Mock the Google Cloud Vision client
jest.mock('@google-cloud/vision', () => ({
  ImageAnnotatorClient: jest.fn().mockImplementation(() => ({
    objectLocalization: jest.fn(),
    labelDetection: jest.fn()
  }))
}));

describe('Vision Utils', () => {
  describe('countPotentialTrash', () => {
    it('should count trash objects correctly', () => {
      const mockObjects = [
        { name: 'Bottle', score: 0.9 },
        { name: 'Can', score: 0.8 },
        { name: 'Tree', score: 0.7 },
        { name: 'Plastic bag', score: 0.6 },
        { name: 'Person', score: 0.9 }
      ];

      const trashCount = countPotentialTrash(mockObjects);
      
      expect(trashCount).toBe(3); // Bottle, Can, Plastic bag
    });

    it('should handle empty or null input', () => {
      expect(countPotentialTrash([])).toBe(0);
      expect(countPotentialTrash(null as any)).toBe(0);
      expect(countPotentialTrash(undefined as any)).toBe(0);
    });

    it('should be case insensitive', () => {
      const mockObjects = [
        { name: 'BOTTLE', score: 0.9 },
        { name: 'can', score: 0.8 },
        { name: 'Plastic Bag', score: 0.6 }
      ];

      const trashCount = countPotentialTrash(mockObjects);
      
      expect(trashCount).toBe(3);
    });

    it('should handle objects without name property', () => {
      const mockObjects = [
        { name: 'Bottle', score: 0.9 },
        { score: 0.8 }, // Missing name
        { name: '', score: 0.7 }, // Empty name
        { name: 'Can', score: 0.6 }
      ];

      const trashCount = countPotentialTrash(mockObjects);
      
      expect(trashCount).toBe(2); // Only Bottle and Can
    });

    it('should match partial names', () => {
      const mockObjects = [
        { name: 'Glass bottle', score: 0.9 },
        { name: 'Aluminum can', score: 0.8 },
        { name: 'Food container', score: 0.7 }
      ];

      const trashCount = countPotentialTrash(mockObjects);
      
      expect(trashCount).toBe(3);
    });
  });

  describe('countTrashInLabels', () => {
    it('should count trash-related labels', () => {
      const mockLabels = [
        { description: 'Waste', score: 0.9 },
        { description: 'Litter', score: 0.8 },
        { description: 'Bottle', score: 0.7 },
        { description: 'Tree', score: 0.6 },
        { description: 'Debris', score: 0.5 }
      ];

      const trashCount = countTrashInLabels(mockLabels);
      
      expect(trashCount).toBe(4); // All except Tree
    });

    it('should handle empty input', () => {
      expect(countTrashInLabels([])).toBe(0);
      expect(countTrashInLabels(null as any)).toBe(0);
    });

    it('should be case insensitive', () => {
      const mockLabels = [
        { description: 'WASTE', score: 0.9 },
        { description: 'garbage', score: 0.8 }
      ];

      const trashCount = countTrashInLabels(mockLabels);
      
      expect(trashCount).toBe(2);
    });
  });

  describe('categorizeTrashByType', () => {
    it('should categorize trash by Terra app types', () => {
      const mockObjects = [
        { name: 'Plastic bottle', score: 0.9 },
        { name: 'Cardboard box', score: 0.8 },
        { name: 'Glass jar', score: 0.7 },
        { name: 'Aluminum can', score: 0.8 },
        { name: 'Apple', score: 0.6 },
        { name: 'Smartphone', score: 0.9 },
        { name: 'Cigarette butt', score: 0.5 }
      ];

      const result = categorizeTrashByType(mockObjects);

      expect(result.plastic).toBe(1);
      expect(result.paper).toBe(1);
      expect(result.glass).toBe(1);
      expect(result.metal).toBe(1);
      expect(result.organic).toBe(1);
      expect(result.electronic).toBe(1);
      expect(result.other).toBe(1);
      expect(result.total).toBe(7);
      
      expect(result.details.plastic).toContain('Plastic bottle');
      expect(result.details.paper).toContain('Cardboard box');
      expect(result.details.glass).toContain('Glass jar');
      expect(result.details.metal).toContain('Aluminum can');
      expect(result.details.organic).toContain('Apple');
      expect(result.details.electronic).toContain('Smartphone');
      expect(result.details.other).toContain('Cigarette butt');
    });

    it('should handle empty or null input', () => {
      const emptyResult = categorizeTrashByType([]);
      expect(emptyResult.total).toBe(0);
      expect(emptyResult.plastic).toBe(0);
      
      const nullResult = categorizeTrashByType(null as any);
      expect(nullResult.total).toBe(0);
    });

    it('should handle objects without name property', () => {
      const mockObjects = [
        { name: 'Bottle', score: 0.9 },
        { score: 0.8 }, // Missing name
        { name: '', score: 0.7 }, // Empty name
      ];

      const result = categorizeTrashByType(mockObjects);
      
      expect(result.total).toBe(1); // Only the bottle should be counted
      expect(result.plastic).toBe(1);
    });

    it('should prioritize categories correctly', () => {
      // Some items might match multiple categories - should pick the first match
      const mockObjects = [
        { name: 'Plastic container', score: 0.9 }, // Could be plastic or container
      ];

      const result = categorizeTrashByType(mockObjects);
      
      expect(result.plastic).toBe(1); // Should match plastic first
      expect(result.other).toBe(0);
    });

    it('should be case insensitive', () => {
      const mockObjects = [
        { name: 'PLASTIC BOTTLE', score: 0.9 },
        { name: 'aluminum can', score: 0.8 },
        { name: 'Glass Jar', score: 0.7 }
      ];

      const result = categorizeTrashByType(mockObjects);

      expect(result.plastic).toBe(1);
      expect(result.metal).toBe(1);
      expect(result.glass).toBe(1);
      expect(result.total).toBe(3);
    });
  });

  describe('isValidImageUrl', () => {
    it('should validate HTTP URLs', () => {
      const validUrls = [
        'https://example.com/image.jpg',
        'http://example.com/image.png',
        'https://storage.googleapis.com/bucket/image.jpg'
      ];

      validUrls.forEach(url => {
        expect(isValidImageUrl(url)).toBe(true);
      });
    });

    it('should validate Google Cloud Storage URLs', () => {
      const gcsUrl = 'gs://bucket-name/path/to/image.jpg';
      
      expect(isValidImageUrl(gcsUrl)).toBe(true);
    });

    it('should reject invalid URLs', () => {
      const invalidUrls = [
        '',
        null,
        undefined,
        'not-a-url',
        'ftp://example.com/image.jpg',
        'data:image/jpeg;base64,/9j/4AAQSkZ...'
      ];

      invalidUrls.forEach(url => {
        expect(isValidImageUrl(url as any)).toBe(false);
      });
    });

    it('should handle malformed URLs', () => {
      const malformedUrls = [
        'http://',
        'https://',
        'gs://',
        'https://[invalid-host]'
      ];

      malformedUrls.forEach(url => {
        expect(isValidImageUrl(url)).toBe(false);
      });
    });
  });

  describe('calculateCleanupEffectiveness', () => {
    it('should calculate reduction percentage correctly', () => {
      const beforeAnalysis = { trashCount: 10, confidence: 0.8 };
      const afterAnalysis = { trashCount: 2, confidence: 0.8 };

      const result = calculateCleanupEffectiveness(beforeAnalysis, afterAnalysis);

      expect(result.reductionPercentage).toBe(80);
      expect(result.beforeCount).toBe(10);
      expect(result.afterCount).toBe(2);
      expect(result.trashRemoved).toBe(8);
      expect(result.isEffective).toBe(true); // 80% > 70% threshold
      expect(result.overallConfidence).toBe(0.8);
    });

    it('should handle zero before count', () => {
      const beforeAnalysis = { trashCount: 0, confidence: 0.6 };
      const afterAnalysis = { trashCount: 0, confidence: 0.6 };

      const result = calculateCleanupEffectiveness(beforeAnalysis, afterAnalysis);

      expect(result.reductionPercentage).toBe(0);
      expect(result.trashRemoved).toBe(0);
      expect(result.isEffective).toBe(false);
    });

    it('should handle increased trash count', () => {
      const beforeAnalysis = { trashCount: 5, confidence: 0.7 };
      const afterAnalysis = { trashCount: 8, confidence: 0.7 };

      const result = calculateCleanupEffectiveness(beforeAnalysis, afterAnalysis);

      expect(result.reductionPercentage).toBe(0); // Should not go negative
      expect(result.trashRemoved).toBe(0); // Should not go negative
      expect(result.isEffective).toBe(false);
    });

    it('should calculate overall confidence correctly', () => {
      const beforeAnalysis = { trashCount: 10, confidence: 0.9 };
      const afterAnalysis = { trashCount: 2, confidence: 0.7 };

      const result = calculateCleanupEffectiveness(beforeAnalysis, afterAnalysis);

      expect(result.overallConfidence).toBe(0.8); // Average of 0.9 and 0.7
    });

    it('should determine effectiveness correctly', () => {
      // Test effective cleanup (>70% reduction, high confidence)
      const effective = calculateCleanupEffectiveness(
        { trashCount: 10, confidence: 0.8 },
        { trashCount: 2, confidence: 0.8 }
      );
      expect(effective.isEffective).toBe(true);

      // Test ineffective cleanup (low reduction)
      const lowReduction = calculateCleanupEffectiveness(
        { trashCount: 10, confidence: 0.8 },
        { trashCount: 5, confidence: 0.8 }
      );
      expect(lowReduction.isEffective).toBe(false);

      // Test low confidence
      const lowConfidence = calculateCleanupEffectiveness(
        { trashCount: 10, confidence: 0.3 },
        { trashCount: 1, confidence: 0.3 }
      );
      expect(lowConfidence.isEffective).toBe(false);
    });

    it('should constrain reduction percentage between 0 and 100', () => {
      // Test with very large before count
      const result = calculateCleanupEffectiveness(
        { trashCount: 1000, confidence: 0.8 },
        { trashCount: 0, confidence: 0.8 }
      );

      expect(result.reductionPercentage).toBeLessThanOrEqual(100);
      expect(result.reductionPercentage).toBeGreaterThanOrEqual(0);
    });
  });
});