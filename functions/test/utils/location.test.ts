/**
 * Tests for location utilities
 */

import {
  calculateDistance,
  verifyLocation,
  isValidCoordinates,
  createBoundingBox,
  Coordinates
} from '../../src/utils/location';

describe('Location Utils', () => {
  describe('calculateDistance', () => {
    it('should calculate distance between two points correctly', () => {
      const point1: Coordinates = { latitude: 40.7128, longitude: -74.0060 }; // NYC
      const point2: Coordinates = { latitude: 40.7589, longitude: -73.9851 }; // Times Square
      
      const distance = calculateDistance(point1, point2);
      
      // Distance should be approximately 5.5 km
      expect(distance).toBeGreaterThan(5000);
      expect(distance).toBeLessThan(6000);
    });

    it('should return 0 for identical coordinates', () => {
      const point: Coordinates = { latitude: 40.7128, longitude: -74.0060 };
      
      const distance = calculateDistance(point, point);
      
      expect(distance).toBeCloseTo(0, 2);
    });

    it('should calculate long distances correctly', () => {
      const nyc: Coordinates = { latitude: 40.7128, longitude: -74.0060 };
      const london: Coordinates = { latitude: 51.5074, longitude: -0.1278 };
      
      const distance = calculateDistance(nyc, london);
      
      // Distance should be approximately 5585 km
      expect(distance).toBeGreaterThan(5500000);
      expect(distance).toBeLessThan(5600000);
    });
  });

  describe('verifyLocation', () => {
    it('should return true for locations within radius', () => {
      const userLocation: Coordinates = { latitude: 40.7128, longitude: -74.0060 };
      const hotspotLocation: Coordinates = { latitude: 40.7130, longitude: -74.0058 };
      const maxDistance = 100; // 100 meters
      
      const result = verifyLocation(userLocation, hotspotLocation, maxDistance);
      
      expect(result).toBe(true);
    });

    it('should return false for locations outside radius', () => {
      const userLocation: Coordinates = { latitude: 40.7128, longitude: -74.0060 };
      const hotspotLocation: Coordinates = { latitude: 40.7200, longitude: -74.0000 };
      const maxDistance = 100; // 100 meters
      
      const result = verifyLocation(userLocation, hotspotLocation, maxDistance);
      
      expect(result).toBe(false);
    });

    it('should handle edge case at exact radius boundary', () => {
      const userLocation: Coordinates = { latitude: 40.7128, longitude: -74.0060 };
      const hotspotLocation: Coordinates = { latitude: 40.7137, longitude: -74.0060 };
      const distance = calculateDistance(userLocation, hotspotLocation);
      
      // Test with exact distance
      expect(verifyLocation(userLocation, hotspotLocation, distance)).toBe(true);
      
      // Test with slightly less distance
      expect(verifyLocation(userLocation, hotspotLocation, distance - 1)).toBe(false);
    });
  });

  describe('isValidCoordinates', () => {
    it('should validate correct coordinates', () => {
      const validCoords: Coordinates = { latitude: 40.7128, longitude: -74.0060 };
      
      expect(isValidCoordinates(validCoords)).toBe(true);
    });

    it('should reject coordinates with invalid latitude', () => {
      const invalidCoords = [
        { latitude: 91, longitude: -74.0060 },
        { latitude: -91, longitude: -74.0060 },
        { latitude: NaN, longitude: -74.0060 },
        { latitude: 'invalid', longitude: -74.0060 }
      ];

      invalidCoords.forEach(coords => {
        expect(isValidCoordinates(coords as any)).toBe(false);
      });
    });

    it('should reject coordinates with invalid longitude', () => {
      const invalidCoords = [
        { latitude: 40.7128, longitude: 181 },
        { latitude: 40.7128, longitude: -181 },
        { latitude: 40.7128, longitude: NaN },
        { latitude: 40.7128, longitude: 'invalid' }
      ];

      invalidCoords.forEach(coords => {
        expect(isValidCoordinates(coords as any)).toBe(false);
      });
    });

    it('should handle edge cases for lat/lon boundaries', () => {
      const edgeCases = [
        { latitude: 90, longitude: 180 },
        { latitude: -90, longitude: -180 },
        { latitude: 0, longitude: 0 }
      ];

      edgeCases.forEach(coords => {
        expect(isValidCoordinates(coords)).toBe(true);
      });
    });
  });

  describe('createBoundingBox', () => {
    it('should create correct bounding box', () => {
      const center: Coordinates = { latitude: 40.7128, longitude: -74.0060 };
      const radiusMeters = 1000; // 1km
      
      const bbox = createBoundingBox(center, radiusMeters);
      
      expect(bbox.north).toBeGreaterThan(center.latitude);
      expect(bbox.south).toBeLessThan(center.latitude);
      expect(bbox.east).toBeGreaterThan(center.longitude);
      expect(bbox.west).toBeLessThan(center.longitude);
      
      // Check that the box is roughly the right size
      const northDistance = calculateDistance(center, { latitude: bbox.north, longitude: center.longitude });
      const eastDistance = calculateDistance(center, { latitude: center.latitude, longitude: bbox.east });
      
      expect(northDistance).toBeCloseTo(radiusMeters, -2);
      expect(eastDistance).toBeCloseTo(radiusMeters, -2);
    });

    it('should handle different radius sizes', () => {
      const center: Coordinates = { latitude: 40.7128, longitude: -74.0060 };
      
      const bbox100m = createBoundingBox(center, 100);
      const bbox1km = createBoundingBox(center, 1000);
      
      // Larger radius should create larger bounding box
      expect(bbox1km.north - bbox1km.south).toBeGreaterThan(bbox100m.north - bbox100m.south);
      expect(bbox1km.east - bbox1km.west).toBeGreaterThan(bbox100m.east - bbox100m.west);
    });
  });
});