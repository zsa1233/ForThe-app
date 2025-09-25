import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cleanup_models.dart';
import '../models/city_dashboard_models.dart';
import 'firebase_error_handler.dart';
import 'dart:developer' as developer;

/// Offline data management service
class OfflineService {
  static const String _offlineDataPrefix = 'offline_data_';
  static const String _pendingSyncPrefix = 'pending_sync_';
  static const String _lastSyncPrefix = 'last_sync_';
  
  final SharedPreferences _prefs;
  final Connectivity _connectivity = Connectivity();
  
  OfflineService(this._prefs);

  /// Check if device is online
  Future<bool> isOnline() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      
      if (connectivityResult == ConnectivityResult.none) {
        return false;
      }
      
      // Additional check with actual network request
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 3));
      
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      developer.log('Network check failed: $e');
      return false;
    }
  }

  /// Stream of connectivity status
  Stream<bool> get connectivityStream {
    return _connectivity.onConnectivityChanged.asyncMap((_) => isOnline());
  }

  /// Cache data locally
  Future<void> cacheData(String key, Map<String, dynamic> data) async {
    try {
      final dataKey = '$_offlineDataPrefix$key';
      final jsonData = jsonEncode(data);
      await _prefs.setString(dataKey, jsonData);
      
      // Update last cache time
      await _prefs.setInt('${dataKey}_timestamp', DateTime.now().millisecondsSinceEpoch);
      
      developer.log('Data cached: $key');
    } catch (e) {
      developer.log('Error caching data: $e');
    }
  }

  /// Cache list data locally
  Future<void> cacheListData(String key, List<Map<String, dynamic>> data) async {
    try {
      await cacheData(key, {'items': data});
    } catch (e) {
      developer.log('Error caching list data: $e');
    }
  }

  /// Retrieve cached data
  Map<String, dynamic>? getCachedData(String key) {
    try {
      final dataKey = '$_offlineDataPrefix$key';
      final jsonData = _prefs.getString(dataKey);
      
      if (jsonData == null) return null;
      
      return Map<String, dynamic>.from(jsonDecode(jsonData));
    } catch (e) {
      developer.log('Error retrieving cached data: $e');
      return null;
    }
  }

  /// Retrieve cached list data
  List<Map<String, dynamic>>? getCachedListData(String key) {
    try {
      final data = getCachedData(key);
      if (data == null) return null;
      
      final items = data['items'] as List?;
      if (items == null) return null;
      
      return items.map((item) => Map<String, dynamic>.from(item)).toList();
    } catch (e) {
      developer.log('Error retrieving cached list data: $e');
      return null;
    }
  }

  /// Check if cached data is expired
  bool isCacheExpired(String key, {Duration maxAge = const Duration(hours: 1)}) {
    try {
      final dataKey = '$_offlineDataPrefix$key';
      final timestamp = _prefs.getInt('${dataKey}_timestamp');
      
      if (timestamp == null) return true;
      
      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();
      
      return now.difference(cacheTime) > maxAge;
    } catch (e) {
      developer.log('Error checking cache expiration: $e');
      return true;
    }
  }

  /// Add data to pending sync queue
  Future<void> addToPendingSync(String operation, Map<String, dynamic> data) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final syncKey = '$_pendingSyncPrefix${timestamp}_$operation';
      
      final syncData = {
        'operation': operation,
        'data': data,
        'timestamp': timestamp,
        'retryCount': 0,
      };
      
      await _prefs.setString(syncKey, jsonEncode(syncData));
      developer.log('Added to pending sync: $operation');
    } catch (e) {
      developer.log('Error adding to pending sync: $e');
    }
  }

  /// Get all pending sync operations
  List<Map<String, dynamic>> getPendingSyncOperations() {
    try {
      final keys = _prefs.getKeys()
          .where((key) => key.startsWith(_pendingSyncPrefix))
          .toList();
      
      final operations = <Map<String, dynamic>>[];
      
      for (final key in keys) {
        final jsonData = _prefs.getString(key);
        if (jsonData != null) {
          final data = Map<String, dynamic>.from(jsonDecode(jsonData));
          data['syncKey'] = key;
          operations.add(data);
        }
      }
      
      // Sort by timestamp
      operations.sort((a, b) => (a['timestamp'] as int).compareTo(b['timestamp'] as int));
      
      return operations;
    } catch (e) {
      developer.log('Error getting pending sync operations: $e');
      return [];
    }
  }

  /// Remove operation from pending sync
  Future<void> removePendingSync(String syncKey) async {
    try {
      await _prefs.remove(syncKey);
      developer.log('Removed from pending sync: $syncKey');
    } catch (e) {
      developer.log('Error removing pending sync: $e');
    }
  }

  /// Update retry count for pending operation
  Future<void> updatePendingSyncRetryCount(String syncKey, int retryCount) async {
    try {
      final jsonData = _prefs.getString(syncKey);
      if (jsonData != null) {
        final data = Map<String, dynamic>.from(jsonDecode(jsonData));
        data['retryCount'] = retryCount;
        data['lastRetryAt'] = DateTime.now().millisecondsSinceEpoch;
        await _prefs.setString(syncKey, jsonEncode(data));
      }
    } catch (e) {
      developer.log('Error updating retry count: $e');
    }
  }

  /// Process pending sync operations
  Future<void> processPendingSync() async {
    try {
      if (!await isOnline()) {
        developer.log('Offline: Skipping pending sync processing');
        return;
      }

      final operations = getPendingSyncOperations();
      developer.log('Processing ${operations.length} pending sync operations');

      for (final operation in operations) {
        await _processSingleSyncOperation(operation);
      }
    } catch (e) {
      developer.log('Error processing pending sync: $e');
    }
  }

  /// Process a single sync operation
  Future<void> _processSingleSyncOperation(Map<String, dynamic> operation) async {
    try {
      final syncKey = operation['syncKey'] as String;
      final operationType = operation['operation'] as String;
      final data = operation['data'] as Map<String, dynamic>;
      final retryCount = operation['retryCount'] as int? ?? 0;

      // Skip if too many retries
      if (retryCount > 3) {
        developer.log('Max retries exceeded for $operationType, removing from queue');
        await removePendingSync(syncKey);
        return;
      }

      switch (operationType) {
        case 'submit_cleanup':
          await _syncCleanupSubmission(data);
          break;
        case 'update_user_profile':
          await _syncUserProfileUpdate(data);
          break;
        case 'update_user_stats':
          await _syncUserStatsUpdate(data);
          break;
        default:
          developer.log('Unknown sync operation: $operationType');
      }

      // If successful, remove from queue
      await removePendingSync(syncKey);
      developer.log('Successfully synced: $operationType');

    } catch (e) {
      final syncKey = operation['syncKey'] as String;
      final retryCount = operation['retryCount'] as int? ?? 0;
      
      developer.log('Sync failed for ${operation['operation']}: $e');
      await updatePendingSyncRetryCount(syncKey, retryCount + 1);
    }
  }

  /// Sync cleanup submission
  Future<void> _syncCleanupSubmission(Map<String, dynamic> data) async {
    final firestore = FirebaseFirestore.instance;
    await firestore.collection('cleanup_submissions').add({
      ...data,
      'syncedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Sync user profile update
  Future<void> _syncUserProfileUpdate(Map<String, dynamic> data) async {
    final firestore = FirebaseFirestore.instance;
    final userId = data['userId'] as String;
    final updates = Map<String, dynamic>.from(data);
    updates.remove('userId');
    
    await firestore.collection('users').doc(userId).update({
      ...updates,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Sync user stats update
  Future<void> _syncUserStatsUpdate(Map<String, dynamic> data) async {
    final firestore = FirebaseFirestore.instance;
    final userId = data['userId'] as String;
    final updates = Map<String, dynamic>.from(data);
    updates.remove('userId');
    
    await firestore.collection('users').doc(userId).update({
      ...updates,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Cache user profile
  Future<void> cacheUserProfile(String userId, Map<String, dynamic> profile) async {
    await cacheData('user_profile_$userId', profile);
  }

  /// Get cached user profile
  Map<String, dynamic>? getCachedUserProfile(String userId) {
    return getCachedData('user_profile_$userId');
  }

  /// Cache city dashboard data
  Future<void> cacheCityDashboard(String cityName, CityDashboardData data) async {
    await cacheData('city_dashboard_$cityName', data.toJson());
  }

  /// Get cached city dashboard data
  CityDashboardData? getCachedCityDashboard(String cityName) {
    final data = getCachedData('city_dashboard_$cityName');
    if (data == null) return null;
    
    try {
      return CityDashboardData.fromJson(data);
    } catch (e) {
      developer.log('Error parsing cached city dashboard: $e');
      return null;
    }
  }

  /// Cache leaderboard data
  Future<void> cacheLeaderboard(String key, List<Map<String, dynamic>> leaderboard) async {
    await cacheListData('leaderboard_$key', leaderboard);
  }

  /// Get cached leaderboard
  List<Map<String, dynamic>>? getCachedLeaderboard(String key) {
    return getCachedListData('leaderboard_$key');
  }

  /// Cache cleanup sessions
  Future<void> cacheCleanupSessions(List<CleanupSession> sessions) async {
    final data = sessions.map((s) => s.toJson()).toList();
    await cacheListData('cleanup_sessions', data);
  }

  /// Get cached cleanup sessions
  List<CleanupSession>? getCachedCleanupSessions() {
    final data = getCachedListData('cleanup_sessions');
    if (data == null) return null;
    
    try {
      return data.map((json) => CleanupSession.fromJson(json)).toList();
    } catch (e) {
      developer.log('Error parsing cached cleanup sessions: $e');
      return null;
    }
  }

  /// Clear expired cache data
  Future<void> clearExpiredCache() async {
    try {
      final keys = _prefs.getKeys()
          .where((key) => key.startsWith(_offlineDataPrefix))
          .toList();

      int removedCount = 0;
      
      for (final key in keys) {
        final dataKey = key.replaceFirst(_offlineDataPrefix, '');
        if (isCacheExpired(dataKey, maxAge: const Duration(days: 1))) {
          await _prefs.remove(key);
          await _prefs.remove('${key}_timestamp');
          removedCount++;
        }
      }
      
      developer.log('Cleared $removedCount expired cache entries');
    } catch (e) {
      developer.log('Error clearing expired cache: $e');
    }
  }

  /// Get cache statistics
  Map<String, dynamic> getCacheStats() {
    try {
      final allKeys = _prefs.getKeys();
      final cacheKeys = allKeys.where((key) => key.startsWith(_offlineDataPrefix));
      final pendingKeys = allKeys.where((key) => key.startsWith(_pendingSyncPrefix));
      
      int totalCacheSize = 0;
      int expiredCount = 0;
      
      for (final key in cacheKeys) {
        final data = _prefs.getString(key);
        if (data != null) {
          totalCacheSize += data.length;
          
          final dataKey = key.replaceFirst(_offlineDataPrefix, '');
          if (isCacheExpired(dataKey)) {
            expiredCount++;
          }
        }
      }
      
      return {
        'cachedItems': cacheKeys.length,
        'pendingSyncItems': pendingKeys.length,
        'expiredItems': expiredCount,
        'totalCacheSizeBytes': totalCacheSize,
        'totalCacheSizeKB': (totalCacheSize / 1024).toStringAsFixed(2),
      };
    } catch (e) {
      developer.log('Error getting cache stats: $e');
      return {};
    }
  }

  /// Clear all offline data
  Future<void> clearAllOfflineData() async {
    try {
      final keys = _prefs.getKeys().where((key) => 
          key.startsWith(_offlineDataPrefix) || 
          key.startsWith(_pendingSyncPrefix) ||
          key.startsWith(_lastSyncPrefix)
      ).toList();

      for (final key in keys) {
        await _prefs.remove(key);
      }
      
      developer.log('Cleared all offline data (${keys.length} entries)');
    } catch (e) {
      developer.log('Error clearing offline data: $e');
    }
  }

  /// Update last sync time
  Future<void> updateLastSyncTime(String operation) async {
    try {
      final key = '$_lastSyncPrefix$operation';
      await _prefs.setInt(key, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      developer.log('Error updating last sync time: $e');
    }
  }

  /// Get last sync time
  DateTime? getLastSyncTime(String operation) {
    try {
      final key = '$_lastSyncPrefix$operation';
      final timestamp = _prefs.getInt(key);
      
      if (timestamp == null) return null;
      
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    } catch (e) {
      developer.log('Error getting last sync time: $e');
      return null;
    }
  }
}

/// Provider for offline service
final offlineServiceProvider = Provider<OfflineService>((ref) {
  throw UnimplementedError('OfflineService requires SharedPreferences initialization');
});

/// Provider for SharedPreferences
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be initialized in main()');
});

/// Provider for initialized offline service
final initializedOfflineServiceProvider = Provider<OfflineService>((ref) {
  final prefs = ref.read(sharedPreferencesProvider);
  return OfflineService(prefs);
});

/// Connectivity provider
final connectivityProvider = StreamProvider<bool>((ref) {
  final offlineService = ref.read(initializedOfflineServiceProvider);
  return offlineService.connectivityStream;
});