/**
 * Location utilities for cleanup verification
 */

export interface Coordinates {
  latitude: number;
  longitude: number;
}

/**
 * Calculates the distance between two geographical points using the Haversine formula
 * @param point1 First coordinate point
 * @param point2 Second coordinate point
 * @returns Distance in meters
 */
export function calculateDistance(point1: Coordinates, point2: Coordinates): number {
  const R = 6371e3; // Earth's radius in meters
  const φ1 = point1.latitude * Math.PI / 180; // φ, λ in radians
  const φ2 = point2.latitude * Math.PI / 180;
  const Δφ = (point2.latitude - point1.latitude) * Math.PI / 180;
  const Δλ = (point2.longitude - point1.longitude) * Math.PI / 180;

  const a = Math.sin(Δφ / 2) * Math.sin(Δφ / 2) +
    Math.cos(φ1) * Math.cos(φ2) *
    Math.sin(Δλ / 2) * Math.sin(Δλ / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

  return R * c; // Distance in meters
}

/**
 * Verifies if a user's location is within the allowed radius of a hotspot
 * @param userLocation User's reported location
 * @param hotspotLocation Hotspot's location
 * @param maxDistanceMeters Maximum allowed distance in meters
 * @returns True if location is valid
 */
export function verifyLocation(
  userLocation: Coordinates,
  hotspotLocation: Coordinates,
  maxDistanceMeters: number
): boolean {
  const distance = calculateDistance(userLocation, hotspotLocation);
  return distance <= maxDistanceMeters;
}

/**
 * Validates coordinate values
 * @param coordinates Coordinates to validate
 * @returns True if coordinates are valid
 */
export function isValidCoordinates(coordinates: Coordinates): boolean {
  const { latitude, longitude } = coordinates;
  
  return (
    typeof latitude === 'number' &&
    typeof longitude === 'number' &&
    latitude >= -90 &&
    latitude <= 90 &&
    longitude >= -180 &&
    longitude <= 180 &&
    !isNaN(latitude) &&
    !isNaN(longitude)
  );
}

/**
 * Creates a bounding box around a point for geo queries
 * @param center Center coordinates
 * @param radiusMeters Radius in meters
 * @returns Bounding box coordinates
 */
export function createBoundingBox(center: Coordinates, radiusMeters: number) {
  const earthRadius = 6371e3; // Earth radius in meters
  
  // Calculate deltas in degrees
  const deltaLat = (radiusMeters / earthRadius) * (180 / Math.PI);
  const deltaLng = (radiusMeters / earthRadius) * (180 / Math.PI) / Math.cos(center.latitude * Math.PI / 180);
  
  return {
    north: center.latitude + deltaLat,
    south: center.latitude - deltaLat,
    east: center.longitude + deltaLng,
    west: center.longitude - deltaLng,
  };
}