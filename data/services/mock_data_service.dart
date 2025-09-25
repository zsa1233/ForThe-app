import 'dart:math';

/// Mock data service to provide realistic data for the Terra app
class MockDataService {
  static final MockDataService _instance = MockDataService._internal();
  final Random _random = Random();
  
  factory MockDataService() {
    return _instance;
  }
  
  MockDataService._internal();
  
  /// Get user profile data with statistics
  Future<Map<String, dynamic>> getUserProfile() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));
    
    return {
      'id': 'user123',
      'name': 'Alex Johnson',
      'username': '@alexj',
      'email': 'alex@example.com',
      'profileImage': 'assets/images/profile.jpg',
      'joinDate': '2023-09-15',
      'stats': {
        'cleanups': 23,
        'poundsCollected': 136.5,
        'areasImproved': 12,
        'streakDays': 7,
        'rank': 14,
        'points': 2450,
      },
      'badges': [
        {
          'id': 'badge_001',
          'name': 'First Cleanup',
          'description': 'Completed your first cleanup',
          'icon': 'assets/badges/first_cleanup.png',
          'earnedOn': '2023-09-16',
        },
        {
          'id': 'badge_003',
          'name': '5 Cleanups',
          'description': 'Completed 5 cleanups',
          'icon': 'assets/badges/five_cleanups.png',
          'earnedOn': '2023-10-05',
        },
        {
          'id': 'badge_007',
          'name': '50 lbs Club',
          'description': 'Collected 50 pounds of trash',
          'icon': 'assets/badges/fifty_pounds.png',
          'earnedOn': '2023-11-12',
        },
        {
          'id': 'badge_009',
          'name': 'Streak Master',
          'description': 'Maintained a 7-day streak',
          'icon': 'assets/badges/streak_master.png',
          'earnedOn': '2024-01-03',
        },
        {
          'id': 'badge_012',
          'name': 'Community Leader',
          'description': 'Inspired 3 friends to join',
          'icon': 'assets/badges/community_leader.png',
          'earnedOn': '2024-02-18',
        },
      ],
      'nextBadge': {
        'id': 'badge_008',
        'name': '100 lbs Club',
        'description': 'Collect 200 pounds of trash',
        'icon': 'assets/badges/hundred_pounds.png',
        'progress': 0.68, // 136.5/200
        'current': 136.5,
        'target': 200,
      },
    };
  }

  /// Get hotspots data focused on New York City
  Future<List<Map<String, dynamic>>> getHotspots() async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    return [
      {
        'id': 'nyc_hotspot1',
        'location': {'latitude': 40.7128, 'longitude': -74.0060},
        'priority': 'High',
        'isActive': true,
        'title': 'Lower Manhattan',
        'details': 'Heavy foot traffic area with significant litter',
        'estimated_pounds': 35.2,
      },
      {
        'id': 'nyc_hotspot2',
        'location': {'latitude': 40.7484, 'longitude': -73.9857},
        'priority': 'Critical',
        'isActive': true,
        'title': 'Midtown',
        'details': 'Tourist area requiring immediate attention',
        'estimated_pounds': 48.7,
      },
      {
        'id': 'nyc_hotspot3',
        'location': {'latitude': 40.7829, 'longitude': -73.9654},
        'priority': 'Medium',
        'isActive': true,
        'title': 'Upper East Side',
        'details': 'Residential area with moderate litter',
        'estimated_pounds': 22.3,
      },
      {
        'id': 'nyc_hotspot4',
        'location': {'latitude': 40.7580, 'longitude': -73.9855},
        'priority': 'High',
        'isActive': true,
        'title': 'Times Square',
        'details': 'High-density tourist location with significant waste',
        'estimated_pounds': 42.8,
      },
      {
        'id': 'nyc_hotspot5',
        'location': {'latitude': 40.7527, 'longitude': -73.9772},
        'priority': 'Medium',
        'isActive': true,
        'title': 'Grand Central',
        'details': 'Transit hub with moderate litter',
        'estimated_pounds': 28.5,
      },
      {
        'id': 'nyc_hotspot6',
        'location': {'latitude': 40.7736, 'longitude': -73.9566},
        'priority': 'Low',
        'isActive': true,
        'title': 'Roosevelt Island',
        'details': 'Small island with light litter',
        'estimated_pounds': 12.6,
      },
      {
        'id': 'nyc_hotspot7',
        'location': {'latitude': 40.7614, 'longitude': -73.9776},
        'priority': 'High',
        'isActive': true,
        'title': 'Central Park South',
        'details': 'Popular park entrance with significant waste',
        'estimated_pounds': 37.9,
      },
      {
        'id': 'nyc_hotspot8',
        'location': {'latitude': 40.6782, 'longitude': -73.9442},
        'priority': 'Critical',
        'isActive': true,
        'title': 'Prospect Park',
        'details': 'Large park with critical waste situation',
        'estimated_pounds': 53.1,
      },
      {
        'id': 'nyc_hotspot9',
        'location': {'latitude': 40.7061, 'longitude': -74.0090},
        'priority': 'High',
        'isActive': true,
        'title': 'Battery Park',
        'details': 'Waterfront area with tourist traffic',
        'estimated_pounds': 32.4,
      },
    ];
  }
  
  /// Get leaderboard data
  Future<List<Map<String, dynamic>>> getLeaderboard() async {
    await Future.delayed(const Duration(milliseconds: 700));
    
    return [
      {
        'id': 'user456',
        'name': 'Sarah Williams',
        'username': '@sarahw',
        'profileImage': 'assets/images/avatar1.jpg',
        'rank': 1,
        'points': 4876,
        'poundsCollected': 312.5,
        'badges': 14,
      },
      {
        'id': 'user789',
        'name': 'Marcus Chen',
        'username': '@marcusc',
        'profileImage': 'assets/images/avatar2.jpg',
        'rank': 2,
        'points': 4315,
        'poundsCollected': 274.2,
        'badges': 12,
      },
      {
        'id': 'user321',
        'name': 'Priya Patel',
        'username': '@priyap',
        'profileImage': 'assets/images/avatar3.jpg',
        'rank': 3,
        'points': 3982,
        'poundsCollected': 251.8,
        'badges': 11,
      },
      {
        'id': 'user123',
        'name': 'Alex Johnson',
        'username': '@alexj',
        'profileImage': 'assets/images/profile.jpg',
        'rank': 14,
        'points': 2450,
        'poundsCollected': 136.5,
        'badges': 5,
      },
      {
        'id': 'user654',
        'name': 'Jordan Smith',
        'username': '@jordans',
        'profileImage': 'assets/images/avatar4.jpg',
        'rank': 4,
        'points': 3754,
        'poundsCollected': 231.0,
        'badges': 10,
      },
      {
        'id': 'user987',
        'name': 'Riley Johnson',
        'username': '@rileyj',
        'profileImage': 'assets/images/avatar5.jpg',
        'rank': 5,
        'points': 3642,
        'poundsCollected': 219.7,
        'badges': 9,
      },
      {
        'id': 'user246',
        'name': 'Casey Taylor',
        'username': '@caseyt',
        'profileImage': 'assets/images/avatar6.jpg',
        'rank': 6,
        'points': 3510,
        'poundsCollected': 203.4,
        'badges': 8,
      },
      {
        'id': 'user135',
        'name': 'Morgan Lee',
        'username': '@morganl',
        'profileImage': 'assets/images/avatar7.jpg',
        'rank': 7,
        'points': 3289,
        'poundsCollected': 187.2,
        'badges': 7,
      },
    ];
  }
  
  /// Submit a cleanup
  Future<Map<String, dynamic>> submitCleanup({
    required String location,
    required double pounds,
    required String notes,
    required String beforeImagePath,
    required String afterImagePath,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    final String cleanupId = 'cleanup_${DateTime.now().millisecondsSinceEpoch}';
    
    return {
      'id': cleanupId,
      'status': 'submitted',
      'timestamp': DateTime.now().toIso8601String(),
      'location': location,
      'pounds': pounds,
      'notes': notes,
      'beforeImage': beforeImagePath,
      'afterImage': afterImagePath,
    };
  }
  
  /// Verify a cleanup using enhanced AI service with security validation
  Future<Map<String, dynamic>> verifyCleanup(
    String cleanupId, {
    Map<String, dynamic>? cleanupData,
    bool forceFailure = false,
  }) async {
    // Validate input parameters
    if (cleanupId.isEmpty) {
      return {
        'success': false,
        'error': 'Invalid cleanup ID provided',
        'errorCode': 'INVALID_CLEANUP_ID',
      };
    }
    
    // Rate limiting simulation (max 5 verifications per minute per user)
    // In real implementation, this would check against a rate limiting service
    
    // Validate cleanup data if provided
    if (cleanupData != null) {
      final validationResult = _validateCleanupData(cleanupData);
      if (!validationResult['isValid']) {
        return {
          'success': false,
          'error': validationResult['error'],
          'errorCode': 'VALIDATION_FAILED',
        };
      }
    }
    
    // Simulate network delay and AI processing time (2-5 seconds)
    final processingTime = 2 + (DateTime.now().millisecond % 3);
    await Future.delayed(Duration(seconds: processingTime));
    
    if (forceFailure) {
      return {
        'success': false,
        'error': 'AI verification failed - insufficient cleanup evidence',
        'errorCode': 'VERIFICATION_FAILED',
        'confidence': 0.15,
        'details': 'The before and after images do not show sufficient cleanup progress.',
      };
    }
    
    // Simulate successful verification with details
    return {
      'success': true,
      'confidence': 0.87 + (DateTime.now().millisecond % 13) / 100, // 0.87-0.99
      'pointsAwarded': _calculatePoints(cleanupData),
      'verificationDetails': {
        'beforeImageAnalysis': 'Significant litter detected in multiple areas',
        'afterImageAnalysis': 'Substantial improvement visible, area appears clean',
        'locationVerified': true,
        'timeStampValid': true,
      },
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
  
  /// Validate cleanup data structure and content for NYC bounds
  Map<String, dynamic> _validateCleanupData(Map<String, dynamic> data) {
    // Check required fields
    final requiredFields = ['id', 'userId', 'location', 'timestamp'];
    for (final field in requiredFields) {
      if (!data.containsKey(field) || data[field] == null) {
        return {
          'isValid': false,
          'error': 'Missing required field: $field',
        };
      }
    }
    
    // Validate location is within NYC bounds
    final location = data['location'] as Map<String, dynamic>?;
    if (location != null) {
      final lat = location['latitude'] as double?;
      final lng = location['longitude'] as double?;
      
      if (lat == null || lng == null) {
        return {
          'isValid': false,
          'error': 'Invalid location coordinates',
        };
      }
      
      // NYC bounds validation
      if (lat < 40.4774 || lat > 40.9176 || lng < -74.2591 || lng > -73.7004) {
        return {
          'isValid': false,
          'error': 'Cleanup location must be within New York City bounds',
        };
      }
    }
    
    // Validate timestamp is recent (within last 24 hours)
    if (data['timestamp'] is String) {
      try {
        final timestamp = DateTime.parse(data['timestamp'] as String);
        final now = DateTime.now();
        final difference = now.difference(timestamp);
        
        if (difference.inHours > 24) {
          return {
            'isValid': false,
            'error': 'Cleanup timestamp is too old (must be within 24 hours)',
          };
        }
      } catch (e) {
        return {
          'isValid': false,
          'error': 'Invalid timestamp format',
        };
      }
    }
    
    return {'isValid': true};
  }
  
  /// Calculate points based on cleanup data
  int _calculatePoints(Map<String, dynamic>? data) {
    if (data == null) return 50; // Base points
    
    int points = 50; // Base points
    
    // Bonus for estimated pounds
    if (data.containsKey('estimated_pounds')) {
      final pounds = data['estimated_pounds'] as double? ?? 0;
      points += (pounds * 2).round(); // 2 points per pound
    }
    
    // Bonus for priority areas
    if (data.containsKey('priority')) {
      final priority = data['priority'] as String?;
      switch (priority) {
        case 'Critical':
          points += 50;
          break;
        case 'High':
          points += 30;
          break;
        case 'Medium':
          points += 15;
          break;
        default:
          points += 5;
      }
    }
    
    return points;
  }
}