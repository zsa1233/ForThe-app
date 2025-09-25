/// Abstract data service interface for Terra app
abstract class DataService {
  /// Get user profile by ID
  Future<Map<String, dynamic>> getUserProfile(String userId);

  /// Get all active hotspots
  Future<List<Map<String, dynamic>>> getHotspots();

  /// Get leaderboard data
  Future<List<Map<String, dynamic>>> getLeaderboard();

  /// Submit cleanup data
  Future<String> submitCleanup(Map<String, dynamic> submission);

  /// Get user's cleanup history
  Future<List<Map<String, dynamic>>> getUserCleanups(String userId) async {
    // Default implementation - can be overridden
    return [];
  }

  /// Update user profile
  Future<void> updateUserProfile(String userId, Map<String, dynamic> updates) async {
    // Default implementation - can be overridden
    throw UnimplementedError('updateUserProfile not implemented');
  }

  /// Delete user account and data
  Future<void> deleteUser(String userId) async {
    // Default implementation - can be overridden
    throw UnimplementedError('deleteUser not implemented');
  }

  /// Search functionality
  Future<List<Map<String, dynamic>>> search(String query) async {
    // Default implementation - can be overridden
    return [];
  }

  /// Get app configuration
  Future<Map<String, dynamic>> getAppConfig() async {
    // Default implementation - can be overridden
    return {};
  }
}