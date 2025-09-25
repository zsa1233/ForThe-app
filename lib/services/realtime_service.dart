import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cleanup_models.dart';
import '../models/city_dashboard_models.dart';
import 'firebase_error_handler.dart';
import 'dart:developer' as developer;

/// Real-time data service for Firebase Firestore listeners
class RealtimeService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Map<String, StreamSubscription> _subscriptions = {};

  /// Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  /// Watch user profile changes in real-time
  Stream<Map<String, dynamic>> watchUserProfile(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .snapshots()
        .handleError((error) {
          developer.log('Error watching user profile: $error');
          throw FirebaseErrorHandler.handleFirestoreError(error);
        })
        .map((doc) {
          if (!doc.exists) {
            throw DataException('User profile not found');
          }
          
          final data = doc.data()!;
          data['id'] = doc.id;
          data['lastUpdated'] = DateTime.now().toIso8601String();
          
          return data;
        });
  }

  /// Watch city leaderboard in real-time
  Stream<CityLeaderboard> watchCityLeaderboard(
    String cityName, {
    String period = 'weekly',
    int limit = 50,
  }) {
    final cityKey = cityName.toLowerCase().replaceAll(' ', '_');
    
    return _db
        .collection('leaderboards')
        .doc(cityKey)
        .collection(period)
        .orderBy('points', descending: true)
        .limit(limit)
        .snapshots()
        .handleError((error) {
          developer.log('Error watching city leaderboard: $error');
          throw FirebaseErrorHandler.handleFirestoreError(error);
        })
        .map((snapshot) {
          final users = <CityUser>[];
          
          for (int i = 0; i < snapshot.docs.length; i++) {
            final doc = snapshot.docs[i];
            final data = doc.data();
            
            try {
              final user = CityUser.fromJson({
                'id': doc.id,
                'rank': i + 1, // Real-time rank calculation
                ...data,
              });
              users.add(user);
            } catch (e) {
              developer.log('Error parsing user data: $e');
              // Skip invalid user data
            }
          }

          return CityLeaderboard(
            cityName: cityName,
            users: users,
            lastUpdated: DateTime.now(),
            period: period,
          );
        });
  }

  /// Watch global leaderboard in real-time
  Stream<List<Map<String, dynamic>>> watchGlobalLeaderboard({int limit = 100}) {
    return _db
        .collection('users')
        .orderBy('points', descending: true)
        .limit(limit)
        .snapshots()
        .handleError((error) {
          developer.log('Error watching global leaderboard: $error');
          throw FirebaseErrorHandler.handleFirestoreError(error);
        })
        .map((snapshot) {
          int rank = 1;
          return snapshot.docs.map((doc) {
            final data = doc.data();
            return {
              'userId': doc.id,
              'rank': rank++,
              'lastUpdated': DateTime.now().toIso8601String(),
              ...data,
            };
          }).toList();
        });
  }

  /// Watch city statistics in real-time
  Stream<CityStats> watchCityStats(String cityName) {
    final cityKey = cityName.toLowerCase().replaceAll(' ', '_');
    
    return _db
        .collection('city_stats')
        .doc(cityKey)
        .snapshots()
        .handleError((error) {
          developer.log('Error watching city stats: $error');
          throw FirebaseErrorHandler.handleFirestoreError(error);
        })
        .map((doc) {
          if (!doc.exists) {
            throw DataException('City stats not found for $cityName');
          }
          
          try {
            return CityStats.fromJson(doc.data()!);
          } catch (e) {
            developer.log('Error parsing city stats: $e');
            throw DataException('Invalid city stats data');
          }
        });
  }

  /// Watch user's city achievements in real-time
  Stream<List<CityAchievement>> watchUserCityAchievements(
    String userId, 
    String cityName,
  ) {
    final cityKey = cityName.toLowerCase().replaceAll(' ', '_');
    
    return _db
        .collection('users')
        .doc(userId)
        .collection('city_achievements')
        .doc(cityKey)
        .collection('achievements')
        .snapshots()
        .handleError((error) {
          developer.log('Error watching user achievements: $error');
          throw FirebaseErrorHandler.handleFirestoreError(error);
        })
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            try {
              return CityAchievement.fromJson({
                'id': doc.id,
                ...doc.data(),
              });
            } catch (e) {
              developer.log('Error parsing achievement: $e');
              // Return a default achievement for invalid data
              return CityAchievement(
                id: doc.id,
                name: 'Unknown Achievement',
                description: 'Data parsing error',
                icon: '❓',
                category: 'error',
                targetValue: 0,
                currentValue: 0,
                isCompleted: false,
              );
            }
          }).toList();
        });
  }

  /// Watch city recent activity in real-time
  Stream<List<CityActivity>> watchCityActivity(
    String cityName, {
    int limit = 20,
  }) {
    final cityKey = cityName.toLowerCase().replaceAll(' ', '_');
    
    return _db
        .collection('city_activity')
        .doc(cityKey)
        .collection('activities')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots()
        .handleError((error) {
          developer.log('Error watching city activity: $error');
          throw FirebaseErrorHandler.handleFirestoreError(error);
        })
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            try {
              return CityActivity.fromJson({
                'id': doc.id,
                ...doc.data(),
              });
            } catch (e) {
              developer.log('Error parsing activity: $e');
              // Return a default activity for invalid data
              return CityActivity(
                id: doc.id,
                userId: 'unknown',
                userName: 'Unknown User',
                type: 'error',
                description: 'data parsing error',
                timestamp: DateTime.now(),
              );
            }
          }).toList();
        });
  }

  /// Watch user's cleanup submissions in real-time
  Stream<List<Map<String, dynamic>>> watchUserCleanups(String userId) {
    return _db
        .collection('cleanup_submissions')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .handleError((error) {
          developer.log('Error watching user cleanups: $error');
          throw FirebaseErrorHandler.handleFirestoreError(error);
        })
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            return {
              'id': doc.id,
              'lastUpdated': DateTime.now().toIso8601String(),
              ...data,
            };
          }).toList();
        });
  }

  /// Watch hotspots in real-time
  Stream<List<Map<String, dynamic>>> watchHotspots() {
    return _db
        .collection('predicted_hotspots')
        .where('isActive', isEqualTo: true)
        .orderBy('priority', descending: true)
        .snapshots()
        .handleError((error) {
          developer.log('Error watching hotspots: $error');
          throw FirebaseErrorHandler.handleFirestoreError(error);
        })
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            return {
              'id': doc.id,
              'lastUpdated': DateTime.now().toIso8601String(),
              ...data,
            };
          }).toList();
        });
  }

  /// Watch cleanup session status updates
  Stream<CleanupSession?> watchCleanupSession(String sessionId) {
    return _db
        .collection('cleanup_sessions')
        .doc(sessionId)
        .snapshots()
        .handleError((error) {
          developer.log('Error watching cleanup session: $error');
          throw FirebaseErrorHandler.handleFirestoreError(error);
        })
        .map((doc) {
          if (!doc.exists) return null;
          
          try {
            return CleanupSession.fromJson({
              'id': doc.id,
              ...doc.data()!,
            });
          } catch (e) {
            developer.log('Error parsing cleanup session: $e');
            return null;
          }
        });
  }

  /// Subscribe to multiple real-time updates with a key
  void subscribeToUpdates(String key, Stream stream, Function(dynamic) onData) {
    // Cancel existing subscription if any
    cancelSubscription(key);
    
    final subscription = stream.listen(
      onData,
      onError: (error) {
        developer.log('Real-time subscription error ($key): $error');
        // Optionally retry subscription after error
        Future.delayed(const Duration(seconds: 5), () {
          if (_subscriptions.containsKey(key)) {
            subscribeToUpdates(key, stream, onData);
          }
        });
      },
    );
    
    _subscriptions[key] = subscription;
    developer.log('Subscribed to real-time updates: $key');
  }

  /// Cancel a specific subscription
  void cancelSubscription(String key) {
    final subscription = _subscriptions[key];
    if (subscription != null) {
      subscription.cancel();
      _subscriptions.remove(key);
      developer.log('Cancelled subscription: $key');
    }
  }

  /// Cancel all subscriptions
  void cancelAllSubscriptions() {
    for (final subscription in _subscriptions.values) {
      subscription.cancel();
    }
    _subscriptions.clear();
    developer.log('Cancelled all real-time subscriptions (${_subscriptions.length})');
  }

  /// Get active subscription count
  int get activeSubscriptionCount => _subscriptions.length;

  /// Get active subscription keys
  List<String> get activeSubscriptionKeys => _subscriptions.keys.toList();

  /// Watch user's position in city leaderboard
  Stream<int?> watchUserRankInCity(String userId, String cityName, {String period = 'weekly'}) {
    return watchCityLeaderboard(cityName, period: period).map((leaderboard) {
      final userIndex = leaderboard.users.indexWhere((user) => user.id == userId);
      return userIndex >= 0 ? userIndex + 1 : null;
    });
  }

  /// Watch user's points changes
  Stream<int> watchUserPoints(String userId) {
    return watchUserProfile(userId).map((profile) {
      return profile['points'] as int? ?? 0;
    });
  }

  /// Watch cleanup submission status updates
  Stream<String> watchCleanupSubmissionStatus(String submissionId) {
    return _db
        .collection('cleanup_submissions')
        .doc(submissionId)
        .snapshots()
        .handleError((error) {
          developer.log('Error watching submission status: $error');
          throw FirebaseErrorHandler.handleFirestoreError(error);
        })
        .map((doc) {
          if (!doc.exists) return 'not_found';
          
          final data = doc.data()!;
          return data['status'] as String? ?? 'unknown';
        });
  }

  /// Dispose of all resources
  void dispose() {
    cancelAllSubscriptions();
    developer.log('RealtimeService disposed');
  }
}

/// Enhanced real-time providers using Riverpod

/// Provider for realtime service
final realtimeServiceProvider = Provider<RealtimeService>((ref) {
  final service = RealtimeService();
  
  // Dispose when provider is disposed
  ref.onDispose(() {
    service.dispose();
  });
  
  return service;
});

/// Stream provider for current user profile
final currentUserProfileProvider = StreamProvider.autoDispose<Map<String, dynamic>>((ref) {
  final realtimeService = ref.read(realtimeServiceProvider);
  final userId = realtimeService.currentUserId;
  
  if (userId == null) {
    throw AuthException('User not authenticated');
  }
  
  return realtimeService.watchUserProfile(userId);
});

/// Stream provider for city leaderboard
final cityLeaderboardStreamProvider = StreamProvider.autoDispose
    .family<CityLeaderboard, ({String city, String period})>((ref, params) {
  final realtimeService = ref.read(realtimeServiceProvider);
  return realtimeService.watchCityLeaderboard(
    params.city,
    period: params.period,
  );
});

/// Stream provider for city stats
final cityStatsStreamProvider = StreamProvider.autoDispose.family<CityStats, String>((ref, cityName) {
  final realtimeService = ref.read(realtimeServiceProvider);
  return realtimeService.watchCityStats(cityName);
});

/// Stream provider for user's city achievements
final userCityAchievementsStreamProvider = StreamProvider.autoDispose
    .family<List<CityAchievement>, ({String userId, String city})>((ref, params) {
  final realtimeService = ref.read(realtimeServiceProvider);
  return realtimeService.watchUserCityAchievements(params.userId, params.city);
});

/// Stream provider for city activity
final cityActivityStreamProvider = StreamProvider.autoDispose.family<List<CityActivity>, String>((ref, cityName) {
  final realtimeService = ref.read(realtimeServiceProvider);
  return realtimeService.watchCityActivity(cityName);
});

/// Stream provider for user cleanups
final userCleanupsStreamProvider = StreamProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
  final realtimeService = ref.read(realtimeServiceProvider);
  final userId = realtimeService.currentUserId;
  
  if (userId == null) {
    throw AuthException('User not authenticated');
  }
  
  return realtimeService.watchUserCleanups(userId);
});

/// Stream provider for hotspots
final hotspotsStreamProvider = StreamProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
  final realtimeService = ref.read(realtimeServiceProvider);
  return realtimeService.watchHotspots();
});

/// Stream provider for user's rank in city
final userCityRankStreamProvider = StreamProvider.autoDispose
    .family<int?, ({String userId, String city, String period})>((ref, params) {
  final realtimeService = ref.read(realtimeServiceProvider);
  return realtimeService.watchUserRankInCity(
    params.userId,
    params.city,
    period: params.period,
  );
});

/// Stream provider for user points
final userPointsStreamProvider = StreamProvider.autoDispose<int>((ref) {
  final realtimeService = ref.read(realtimeServiceProvider);
  final userId = realtimeService.currentUserId;
  
  if (userId == null) {
    throw AuthException('User not authenticated');
  }
  
  return realtimeService.watchUserPoints(userId);
});