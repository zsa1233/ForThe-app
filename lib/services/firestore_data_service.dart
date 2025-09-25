import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cleanup_models.dart';
import '../models/city_dashboard_models.dart';
import '../data/services/data_service.dart';
import 'dart:developer' as developer;

class FirestoreDataService implements DataService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collection names
  static const String usersCollection = 'users';
  static const String hotspotsCollection = 'predicted_hotspots';
  static const String cleanupSubmissionsCollection = 'cleanup_submissions';
  static const String cityStatsCollection = 'city_stats';
  static const String leaderboardCollection = 'leaderboards';

  @override
  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    try {
      final doc = await _db.collection(usersCollection).doc(userId).get();
      
      if (!doc.exists) {
        throw Exception('User profile not found');
      }
      
      final data = doc.data() ?? {};
      data['id'] = doc.id;
      
      developer.log('Retrieved user profile for $userId');
      return data;
    } catch (e) {
      developer.log('Error getting user profile: $e');
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getHotspots() async {
    try {
      final snapshot = await _db
          .collection(hotspotsCollection)
          .where('isActive', isEqualTo: true)
          .orderBy('priority', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          ...data,
        };
      }).toList();
    } catch (e) {
      developer.log('Error getting hotspots: $e');
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getLeaderboard() async {
    try {
      final snapshot = await _db
          .collection(usersCollection)
          .orderBy('points', descending: true)
          .limit(100)
          .get();

      int rank = 1;
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'userId': doc.id,
          'rank': rank++,
          ...data,
        };
      }).toList();
    } catch (e) {
      developer.log('Error getting leaderboard: $e');
      rethrow;
    }
  }

  @override
  Future<String> submitCleanup(Map<String, dynamic> submission) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Add metadata
      submission['userId'] = userId;
      submission['status'] = 'pending';
      submission['createdAt'] = FieldValue.serverTimestamp();
      submission['updatedAt'] = FieldValue.serverTimestamp();

      final docRef = await _db
          .collection(cleanupSubmissionsCollection)
          .add(submission);

      developer.log('Cleanup submitted with ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      developer.log('Error submitting cleanup: $e');
      rethrow;
    }
  }

  // City-specific data methods
  Future<CityStats> getCityStats(String cityName) async {
    try {
      final doc = await _db
          .collection(cityStatsCollection)
          .doc(cityName.toLowerCase().replaceAll(' ', '_'))
          .get();

      if (!doc.exists) {
        throw Exception('City stats not found for $cityName');
      }

      final data = doc.data()!;
      return CityStats.fromJson(data);
    } catch (e) {
      developer.log('Error getting city stats: $e');
      rethrow;
    }
  }

  Future<CityLeaderboard> getCityLeaderboard(String cityName, {String period = 'weekly'}) async {
    try {
      final snapshot = await _db
          .collection(leaderboardCollection)
          .doc(cityName.toLowerCase().replaceAll(' ', '_'))
          .collection(period)
          .orderBy('points', descending: true)
          .limit(50)
          .get();

      final users = snapshot.docs.map((doc) {
        final data = doc.data();
        return CityUser.fromJson({
          'id': doc.id,
          ...data,
        });
      }).toList();

      // Add ranks
      for (int i = 0; i < users.length; i++) {
        users[i] = users[i].copyWith(rank: i + 1);
      }

      return CityLeaderboard(
        cityName: cityName,
        users: users,
        lastUpdated: DateTime.now(),
        period: period,
      );
    } catch (e) {
      developer.log('Error getting city leaderboard: $e');
      rethrow;
    }
  }

  Future<List<CityAchievement>> getUserCityAchievements(String userId, String cityName) async {
    try {
      final snapshot = await _db
          .collection(usersCollection)
          .doc(userId)
          .collection('city_achievements')
          .doc(cityName.toLowerCase().replaceAll(' ', '_'))
          .collection('achievements')
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return CityAchievement.fromJson({
          'id': doc.id,
          ...data,
        });
      }).toList();
    } catch (e) {
      developer.log('Error getting user city achievements: $e');
      rethrow;
    }
  }

  Future<List<CityActivity>> getCityRecentActivity(String cityName, {int limit = 20}) async {
    try {
      final snapshot = await _db
          .collection('city_activity')
          .doc(cityName.toLowerCase().replaceAll(' ', '_'))
          .collection('activities')
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return CityActivity.fromJson({
          'id': doc.id,
          ...data,
        });
      }).toList();
    } catch (e) {
      developer.log('Error getting city recent activity: $e');
      rethrow;
    }
  }

  // Real-time listeners
  Stream<Map<String, dynamic>> watchUserProfile(String userId) {
    return _db
        .collection(usersCollection)
        .doc(userId)
        .snapshots()
        .map((doc) {
      if (!doc.exists) {
        throw Exception('User profile not found');
      }
      final data = doc.data() ?? {};
      data['id'] = doc.id;
      return data;
    });
  }

  Stream<List<Map<String, dynamic>>> watchLeaderboard() {
    return _db
        .collection(usersCollection)
        .orderBy('points', descending: true)
        .limit(100)
        .snapshots()
        .map((snapshot) {
      int rank = 1;
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'userId': doc.id,
          'rank': rank++,
          ...data,
        };
      }).toList();
    });
  }

  Stream<CityStats> watchCityStats(String cityName) {
    return _db
        .collection(cityStatsCollection)
        .doc(cityName.toLowerCase().replaceAll(' ', '_'))
        .snapshots()
        .map((doc) {
      if (!doc.exists) {
        throw Exception('City stats not found for $cityName');
      }
      return CityStats.fromJson(doc.data()!);
    });
  }

  Stream<CityLeaderboard> watchCityLeaderboard(String cityName, {String period = 'weekly'}) {
    return _db
        .collection(leaderboardCollection)
        .doc(cityName.toLowerCase().replaceAll(' ', '_'))
        .collection(period)
        .orderBy('points', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) {
      final users = snapshot.docs.map((doc) {
        final data = doc.data();
        return CityUser.fromJson({
          'id': doc.id,
          ...data,
        });
      }).toList();

      // Add ranks
      for (int i = 0; i < users.length; i++) {
        users[i] = users[i].copyWith(rank: i + 1);
      }

      return CityLeaderboard(
        cityName: cityName,
        users: users,
        lastUpdated: DateTime.now(),
        period: period,
      );
    });
  }

  // Utility methods
  Future<void> createUserProfile(String userId, Map<String, dynamic> profileData) async {
    try {
      await _db.collection(usersCollection).doc(userId).set({
        ...profileData,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      developer.log('User profile created for $userId');
    } catch (e) {
      developer.log('Error creating user profile: $e');
      rethrow;
    }
  }

  Future<void> updateUserProfile(String userId, Map<String, dynamic> updates) async {
    try {
      await _db.collection(usersCollection).doc(userId).update({
        ...updates,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      developer.log('User profile updated for $userId');
    } catch (e) {
      developer.log('Error updating user profile: $e');
      rethrow;
    }
  }

  Future<void> updateUserStats(String userId, {
    int? pointsToAdd,
    double? poundsToAdd,
    int? cleanupsToAdd,
  }) async {
    try {
      final updates = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (pointsToAdd != null) {
        updates['points'] = FieldValue.increment(pointsToAdd);
      }
      if (poundsToAdd != null) {
        updates['totalPoundsCollected'] = FieldValue.increment(poundsToAdd);
      }
      if (cleanupsToAdd != null) {
        updates['totalCleanups'] = FieldValue.increment(cleanupsToAdd);
      }

      await _db.collection(usersCollection).doc(userId).update(updates);
      
      developer.log('User stats updated for $userId');
    } catch (e) {
      developer.log('Error updating user stats: $e');
      rethrow;
    }
  }

  // Batch operations
  Future<void> submitCleanupWithStats(CleanupSession session) async {
    final batch = _db.batch();
    final userId = _auth.currentUser?.uid;
    
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    try {
      // Add cleanup submission
      final cleanupRef = _db.collection(cleanupSubmissionsCollection).doc();
      batch.set(cleanupRef, {
        'userId': userId,
        'sessionId': session.id,
        'location': {
          'latitude': session.location.latitude,
          'longitude': session.location.longitude,
        },
        'type': session.type.name,
        'poundsCollected': session.poundsCollected,
        'trashTypes': session.trashTypes.map((t) => t.name).toList(),
        'duration': session.endTime?.difference(session.startTime).inMinutes ?? 0,
        'beforePhotoPath': session.beforePhotoPath,
        'afterPhotoPath': session.afterPhotoPath,
        'comments': session.comments,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Update user stats
      final userRef = _db.collection(usersCollection).doc(userId);
      batch.update(userRef, {
        'points': FieldValue.increment((session.poundsCollected * 10).round()),
        'totalPoundsCollected': FieldValue.increment(session.poundsCollected),
        'totalCleanups': FieldValue.increment(1),
        'lastCleanupAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await batch.commit();
      developer.log('Cleanup submitted with stats update');
    } catch (e) {
      developer.log('Error submitting cleanup with stats: $e');
      rethrow;
    }
  }
}

final firestoreDataServiceProvider = Provider<FirestoreDataService>((ref) {
  return FirestoreDataService();
});