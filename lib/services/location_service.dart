import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cleanup_models.dart';
import 'dart:developer' as developer;

class LocationService {
  static const double _hotspotProximityThreshold = 100.0; // meters

  /// Check if location permissions are granted
  Future<bool> hasLocationPermission() async {
    try {
      final status = await Permission.location.status;
      return status.isGranted;
    } catch (e) {
      developer.log('Error checking location permission: $e');
      return false;
    }
  }

  /// Request location permissions
  Future<bool> requestLocationPermission() async {
    try {
      final status = await Permission.location.request();
      return status.isGranted;
    } catch (e) {
      developer.log('Error requesting location permission: $e');
      return false;
    }
  }

  /// Get the user's current location
  Future<CleanupLocation?> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        developer.log('Location services are disabled');
        return null;
      }

      // Check permissions
      final hasPermission = await hasLocationPermission();
      if (!hasPermission) {
        final granted = await requestLocationPermission();
        if (!granted) {
          developer.log('Location permission denied');
          return null;
        }
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      return CleanupLocation(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (e) {
      developer.log('Error getting current location: $e');
      return null;
    }
  }

  /// Verify if user is within proximity of a hotspot
  Future<LocationVerificationResult> verifyUserAtHotspot({
    required CleanupLocation hotspotLocation,
    CleanupLocation? userLocation,
  }) async {
    try {
      final currentLocation = userLocation ?? await getCurrentLocation();
      
      if (currentLocation == null) {
        return const LocationVerificationResult(
          isValid: false,
          distanceInMeters: double.infinity,
          errorMessage: 'Could not determine your location',
        );
      }

      // Calculate distance between user and hotspot
      final distanceInMeters = Geolocator.distanceBetween(
        currentLocation.latitude,
        currentLocation.longitude,
        hotspotLocation.latitude,
        hotspotLocation.longitude,
      );

      final isValid = distanceInMeters <= _hotspotProximityThreshold;

      return LocationVerificationResult(
        isValid: isValid,
        distanceInMeters: distanceInMeters,
        errorMessage: isValid 
          ? null 
          : 'You must be within ${_hotspotProximityThreshold.toInt()}m of the hotspot. You are ${distanceInMeters.toInt()}m away.',
      );
    } catch (e) {
      developer.log('Error verifying location: $e');
      return LocationVerificationResult(
        isValid: false,
        distanceInMeters: double.infinity,
        errorMessage: 'Error verifying location: $e',
      );
    }
  }

  /// Calculate distance between two locations
  double calculateDistance(CleanupLocation from, CleanupLocation to) {
    return Geolocator.distanceBetween(
      from.latitude,
      from.longitude,
      to.latitude,
      to.longitude,
    );
  }

  /// Format distance for display
  String formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.round()}m';
    } else {
      return '${(meters / 1000).toStringAsFixed(1)}km';
    }
  }
}

// Provider for LocationService
final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});