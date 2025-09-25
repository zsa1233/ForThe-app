import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data_service.dart';
import 'mock_data_service.dart';
import '../../services/firestore_data_service.dart';
import '../../services/firebase_storage_service.dart';
import '../../services/offline_service.dart';
import '../../services/realtime_service.dart';
import 'dart:developer' as developer;

/// Environment configuration
enum Environment {
  development,
  staging,
  production,
}

/// Service factory configuration
class ServiceFactoryConfig {
  final Environment environment;
  final bool useFirebase;
  final bool enableOfflineSupport;
  final bool enableRealtime;
  final bool useEmulators;

  const ServiceFactoryConfig({
    this.environment = Environment.development,
    this.useFirebase = true,
    this.enableOfflineSupport = true,
    this.enableRealtime = true,
    this.useEmulators = false,
  });

  static const development = ServiceFactoryConfig(
    environment: Environment.development,
    useFirebase: false, // Use mock data for development
    enableOfflineSupport: false,
    enableRealtime: false,
    useEmulators: false,
  );

  static const staging = ServiceFactoryConfig(
    environment: Environment.staging,
    useFirebase: true,
    enableOfflineSupport: true,
    enableRealtime: true,
    useEmulators: true, // Use Firebase emulators for staging
  );

  static const production = ServiceFactoryConfig(
    environment: Environment.production,
    useFirebase: true,
    enableOfflineSupport: true,
    enableRealtime: true,
    useEmulators: false,
  );
}

/// Service factory for creating appropriate service implementations
class ServiceFactory {
  static ServiceFactoryConfig _config = ServiceFactoryConfig.development;

  /// Initialize the service factory with configuration
  static void initialize(ServiceFactoryConfig config) {
    _config = config;
    developer.log('ServiceFactory initialized with environment: ${config.environment.name}');
  }

  /// Get current configuration
  static ServiceFactoryConfig get config => _config;

  /// Create the appropriate data service implementation
  static DataService createDataService() {
    if (_config.useFirebase) {
      developer.log('Creating FirestoreDataService');
      return FirestoreDataService();
    } else {
      developer.log('Creating MockDataService');
      return MockDataServiceAdapter();
    }
  }

  /// Create Firebase Storage service (only if Firebase is enabled)
  static FirebaseStorageService? createStorageService() {
    if (_config.useFirebase) {
      developer.log('Creating FirebaseStorageService');
      return FirebaseStorageService();
    } else {
      developer.log('Storage service not available in mock mode');
      return null;
    }
  }

  /// Create offline service (only if enabled)
  static OfflineService? createOfflineService(SharedPreferences prefs) {
    if (_config.enableOfflineSupport) {
      developer.log('Creating OfflineService');
      return OfflineService(prefs);
    } else {
      developer.log('Offline service disabled');
      return null;
    }
  }

  /// Create realtime service (only if enabled)
  static RealtimeService? createRealtimeService() {
    if (_config.enableRealtime && _config.useFirebase) {
      developer.log('Creating RealtimeService');
      return RealtimeService();
    } else {
      developer.log('Realtime service not available');
      return null;
    }
  }

  /// Check if feature is enabled
  static bool isFeatureEnabled(String feature) {
    switch (feature.toLowerCase()) {
      case 'firebase':
        return _config.useFirebase;
      case 'offline':
        return _config.enableOfflineSupport;
      case 'realtime':
        return _config.enableRealtime;
      case 'emulators':
        return _config.useEmulators;
      default:
        return false;
    }
  }

  /// Get service configuration info
  static Map<String, dynamic> getServiceInfo() {
    return {
      'environment': _config.environment.name,
      'useFirebase': _config.useFirebase,
      'enableOfflineSupport': _config.enableOfflineSupport,
      'enableRealtime': _config.enableRealtime,
      'useEmulators': _config.useEmulators,
      'dataService': _config.useFirebase ? 'FirestoreDataService' : 'MockDataService',
      'features': {
        'storage': _config.useFirebase,
        'offline': _config.enableOfflineSupport,
        'realtime': _config.enableRealtime,
      },
    };
  }
}

/// Adapter to make MockDataService compatible with DataService interface
class MockDataServiceAdapter implements DataService {
  final MockDataService _mockService = MockDataService();

  @override
  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    final profile = await _mockService.getUserProfile();
    profile['id'] = userId; // Ensure the ID matches the requested user
    return profile;
  }

  @override
  Future<List<Map<String, dynamic>>> getHotspots() async {
    return await _mockService.getHotspots();
  }

  @override
  Future<List<Map<String, dynamic>>> getLeaderboard() async {
    return await _mockService.getLeaderboard();
  }

  @override
  Future<String> submitCleanup(Map<String, dynamic> submission) async {
    // Mock submission - generate a fake ID
    await Future.delayed(const Duration(milliseconds: 500));
    final submissionId = 'mock_${DateTime.now().millisecondsSinceEpoch}';
    developer.log('Mock cleanup submission: $submissionId');
    return submissionId;
  }

  @override
  Future<List<Map<String, dynamic>>> getUserCleanups(String userId) async {
    // Return mock cleanup history
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      {
        'id': 'cleanup_1',
        'userId': userId,
        'location': {'latitude': 38.6270, 'longitude': -90.1994},
        'type': 'park',
        'poundsCollected': 5.5,
        'createdAt': DateTime.now().subtract(const Duration(days: 7)).toIso8601String(),
      },
      {
        'id': 'cleanup_2',
        'userId': userId,
        'location': {'latitude': 38.6488, 'longitude': -90.3050},
        'type': 'street',
        'poundsCollected': 3.2,
        'createdAt': DateTime.now().subtract(const Duration(days: 14)).toIso8601String(),
      },
    ];
  }

  @override
  Future<void> updateUserProfile(String userId, Map<String, dynamic> updates) async {
    await Future.delayed(const Duration(milliseconds: 200));
    developer.log('Mock user profile update for $userId: $updates');
  }

  @override
  Future<void> deleteUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    developer.log('Mock user deletion: $userId');
  }

  @override
  Future<List<Map<String, dynamic>>> search(String query) async {
    await Future.delayed(const Duration(milliseconds: 400));
    // Return mock search results
    return [
      {
        'type': 'user',
        'id': 'user_1',
        'name': 'John Doe',
        'relevance': 0.9,
      },
      {
        'type': 'location',
        'id': 'location_1',
        'name': 'Central Park',
        'relevance': 0.8,
      },
    ];
  }

  @override
  Future<Map<String, dynamic>> getAppConfig() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return {
      'version': '1.0.0',
      'features': {
        'cityDashboard': true,
        'realTimeLeaderboard': ServiceFactory.isFeatureEnabled('realtime'),
        'offlineSupport': ServiceFactory.isFeatureEnabled('offline'),
      },
      'limits': {
        'maxFileSize': 10 * 1024 * 1024, // 10MB
        'maxCleanupWeight': 1000.0, // pounds
      },
    };
  }
}

/// Riverpod providers for services
final serviceFactoryProvider = Provider<ServiceFactory>((ref) {
  return ServiceFactory();
});

final dataServiceProvider = Provider<DataService>((ref) {
  return ServiceFactory.createDataService();
});

final storageServiceProvider = Provider<FirebaseStorageService?>((ref) {
  return ServiceFactory.createStorageService();
});

final offlineServiceProvider = Provider<OfflineService?>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ServiceFactory.createOfflineService(prefs);
});

final realtimeServiceProvider = Provider<RealtimeService?>((ref) {
  return ServiceFactory.createRealtimeService();
});

/// Provider for service configuration info
final serviceInfoProvider = Provider<Map<String, dynamic>>((ref) {
  return ServiceFactory.getServiceInfo();
});