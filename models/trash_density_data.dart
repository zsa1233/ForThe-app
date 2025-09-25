import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

/// Model for trash density heat map data points
class TrashDensityPoint {
  final LatLng location;
  final double intensity; // 0.0 to 1.0
  final DateTime lastReported;
  final int reportCount;
  final TrashType dominantTrashType;
  
  const TrashDensityPoint({
    required this.location,
    required this.intensity,
    required this.lastReported,
    required this.reportCount,
    required this.dominantTrashType,
  });
}

/// Types of trash for categorization
enum TrashType {
  plastic,
  paper,
  glass,
  metal,
  organic,
  electronic,
  clothing,
  mixed,
}

/// Heat map configuration for unique styling
class TrashHeatMapConfig {
  /// Get color for specific intensity
  static Color getColorForIntensity(double intensity) {
    if (intensity >= 0.8) return Colors.red;
    if (intensity >= 0.6) return Colors.orange;
    if (intensity >= 0.4) return Colors.yellow[700]!;
    if (intensity >= 0.2) return Colors.lightGreen;
    return Colors.green;
  }
}
