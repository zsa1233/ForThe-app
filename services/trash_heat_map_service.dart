import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/trash_density_data.dart';

/// Service for generating and managing trash density heat map data
class TrashHeatMapService {
  /// Generate mock heat map data points across NYC
  static List<TrashDensityPoint> generateNYCTrashHeatMap() {
    final List<TrashDensityPoint> heatMapPoints = [];
    
    // High-density areas (realistic NYC locations)
    final highDensityAreas = [
      {'lat': 40.7580, 'lng': -73.9855, 'intensity': 0.9}, // Times Square
      {'lat': 40.7587, 'lng': -73.9787, 'intensity': 0.7}, // Central Park South
      {'lat': 40.7061, 'lng': -73.9969, 'intensity': 0.8}, // Brooklyn Bridge
      {'lat': 40.7308, 'lng': -73.9973, 'intensity': 0.6}, // Washington Square
      {'lat': 40.5755, 'lng': -73.9707, 'intensity': 0.8}, // Coney Island
    ];
    
    // Generate points for high-density areas
    for (final area in highDensityAreas) {
      heatMapPoints.addAll(_generatePointsAroundLocation(
        LatLng(area['lat']! as double, area['lng']! as double),
        area['intensity']! as double,
      ));
    }
    
    return heatMapPoints;
  }
  
  /// Generate points around a specific location
  static List<TrashDensityPoint> _generatePointsAroundLocation(
    LatLng center,
    double baseIntensity,
  ) {
    final points = <TrashDensityPoint>[];
    
    for (int i = 0; i < 10; i++) {
      final lat = center.latitude + (i * 0.001 - 0.005);
      final lng = center.longitude + (i * 0.001 - 0.005);
      
      points.add(TrashDensityPoint(
        location: LatLng(lat, lng),
        intensity: baseIntensity,
        lastReported: DateTime.now().subtract(Duration(days: i)),
        reportCount: 5 + i,
        dominantTrashType: TrashType.mixed,
      ));
    }
    
    return points;
  }
}
