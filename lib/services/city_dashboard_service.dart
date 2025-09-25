import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/city_dashboard_models.dart';
import 'dart:developer' as developer;

class CityDashboardService {
  /// Get dashboard data for a specific city
  Future<CityDashboardData> getCityDashboard(String cityName) async {
    try {
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Mock data - in production this would come from Firebase/API
      final stats = CityStats(
        cityName: cityName,
        state: _getCityState(cityName),
        totalPoundsCollected: _getMockTotalPounds(cityName),
        totalCleanups: _getMockTotalCleanups(cityName),
        activeUsers: _getMockActiveUsers(cityName),
        totalHotspots: _getMockTotalHotspots(cityName),
        completedHotspots: _getMockCompletedHotspots(cityName),
        topContributors: _getMockTopContributors(cityName),
        lastUpdated: DateTime.now(),
        userRank: _getMockUserRank(cityName),
        userContribution: _getMockUserContribution(cityName),
      );

      final leaderboard = CityLeaderboard(
        cityName: cityName,
        users: _getMockLeaderboard(cityName),
        lastUpdated: DateTime.now(),
        period: 'weekly',
      );

      final achievements = _getMockAchievements(cityName);
      final recentActivity = _getMockRecentActivity(cityName);
      final availableCities = _getAvailableCities();

      return CityDashboardData(
        stats: stats,
        leaderboard: leaderboard,
        achievements: achievements,
        recentActivity: recentActivity,
        availableCities: availableCities,
      );
    } catch (e) {
      developer.log('Error getting city dashboard: $e');
      rethrow;
    }
  }

  /// Get leaderboard for specific time period
  Future<CityLeaderboard> getCityLeaderboard(String cityName, TimePeriod period) async {
    // TODO: SCALABILITY - Add pagination support
    // Future implementation should accept:
    // - int limit (default: 20)
    // - DocumentSnapshot? startAfter (for cursor pagination)
    // - bool includeUserRank (to fetch user's position if not in top list)
    // Example: getCityLeaderboard(cityName, period, limit: 20, startAfter: lastDoc)
    
    await Future.delayed(const Duration(milliseconds: 500));
    
    return CityLeaderboard(
      cityName: cityName,
      users: _getMockLeaderboard(cityName, period: period),
      lastUpdated: DateTime.now(),
      period: period.name,
    );
  }

  /// Get available cities
  Future<List<String>> getAvailableCities() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _getAvailableCities();
  }
  
  /// Get coming soon cities
  Future<List<String>> getComingSoonCities() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _getComingSoonCities();
  }

  // Mock data generators
  String _getCityState(String cityName) {
    final stateMap = {
      'St. Louis': 'MO',
      'New York': 'NY',
      'Los Angeles': 'CA',
      'Chicago': 'IL',
      'Houston': 'TX',
      'Phoenix': 'AZ',
      'Philadelphia': 'PA',
      'San Antonio': 'TX',
      'San Diego': 'CA',
      'Dallas': 'TX',
      'San Jose': 'CA',
    };
    return stateMap[cityName] ?? 'MO';
  }

  double _getMockTotalPounds(String cityName) {
    final baseAmounts = {
      'St. Louis': 15420.5,
      'New York': 15420.5,
      'Los Angeles': 12850.3,
      'Chicago': 8760.7,
      'Houston': 7200.1,
      'Phoenix': 5500.9,
    };
    return baseAmounts[cityName] ?? 3200.0;
  }

  int _getMockTotalCleanups(String cityName) {
    final baseCleanups = {
      'St. Louis': 1247,
      'New York': 1247,
      'Los Angeles': 986,
      'Chicago': 723,
      'Houston': 567,
      'Phoenix': 445,
    };
    return baseCleanups[cityName] ?? 200;
  }

  int _getMockActiveUsers(String cityName) {
    final baseUsers = {
      'St. Louis': 2840,
      'New York': 2840,
      'Los Angeles': 2156,
      'Chicago': 1678,
      'Houston': 1234,
      'Phoenix': 987,
    };
    return baseUsers[cityName] ?? 500;
  }

  int _getMockTotalHotspots(String cityName) {
    final baseHotspots = {
      'St. Louis': 156,
      'New York': 156,
      'Los Angeles': 134,
      'Chicago': 89,
      'Houston': 67,
      'Phoenix': 45,
    };
    return baseHotspots[cityName] ?? 25;
  }

  int _getMockCompletedHotspots(String cityName) {
    final total = _getMockTotalHotspots(cityName);
    return (total * 0.67).round(); // ~67% completion rate
  }

  List<String> _getMockTopContributors(String cityName) {
    return ['Sarah J.', 'Mike C.', 'Emma W.', 'James B.', 'Olivia D.'];
  }

  double _getMockUserRank(String cityName) {
    return 45.0; // User is ranked 45th in the city
  }

  double _getMockUserContribution(String cityName) {
    return 125.5; // User contributed 125.5 lbs
  }

  List<CityUser> _getMockLeaderboard(String cityName, {TimePeriod? period}) {
    // TODO: SCALABILITY - Replace with paginated Firebase query
    // See LEADERBOARD_SCALABILITY_TODO.md for implementation plan
    // Current implementation returns 5 users, need to support 100s-1000s
    // Implementation checklist:
    // 1. Add pagination parameters (limit, startAfter)
    // 2. Query Firestore: collection('leaderboards').doc(cityId).collection(period)
    // 3. Implement cursor-based pagination with DocumentSnapshot
    // 4. Cache results locally with expiration (5-10 min TTL)
    // 5. Return only visible viewport users (20-50 initially)
    
    final multiplier = switch (period) {
      TimePeriod.weekly => 0.2,
      TimePeriod.monthly => 0.8,
      TimePeriod.allTime => 1.0,
      null => 0.2,
    };

    return [
      CityUser(
        id: '1',
        name: 'Sarah Johnson',
        initials: 'SJ',
        rank: 1,
        poundsCollected: (1200 * multiplier).round().toDouble(),
        cleanupsCompleted: (45 * multiplier).round(),
        points: (6000 * multiplier).round(),
        rankChange: 2,
        badges: ['eco_warrior', 'park_protector'],
      ),
      CityUser(
        id: '2',
        name: 'Michael Chen',
        initials: 'MC',
        rank: 2,
        poundsCollected: (1185 * multiplier).round().toDouble(),
        cleanupsCompleted: (42 * multiplier).round(),
        points: (5925 * multiplier).round(),
        rankChange: -1,
        badges: ['beach_cleaner', 'consistent'],
      ),
      CityUser(
        id: '3',
        name: 'Emma Wilson',
        initials: 'EW',
        rank: 3,
        poundsCollected: (1165 * multiplier).round().toDouble(),
        cleanupsCompleted: (40 * multiplier).round(),
        points: (5825 * multiplier).round(),
        rankChange: 4,
        badges: ['trail_maintainer'],
      ),
      CityUser(
        id: '4',
        name: 'James Brown',
        initials: 'JB',
        rank: 4,
        poundsCollected: (950 * multiplier).round().toDouble(),
        cleanupsCompleted: (35 * multiplier).round(),
        points: (4750 * multiplier).round(),
        rankChange: -2,
        badges: ['volunteer'],
      ),
      CityUser(
        id: '5',
        name: 'Olivia Davis',
        initials: 'OD',
        rank: 5,
        poundsCollected: (890 * multiplier).round().toDouble(),
        cleanupsCompleted: (32 * multiplier).round(),
        points: (4450 * multiplier).round(),
        rankChange: 1,
        badges: ['newcomer'],
      ),
    ];
  }

  List<CityAchievement> _getMockAchievements(String cityName) {
    return [
      CityAchievement(
        id: '1',
        name: '200 lbs Club',
        description: 'Collect 200 pounds of trash in $cityName',
        icon: '🏋️',
        category: 'collection',
        targetValue: 200.0,
        currentValue: 125.5,
        isCompleted: false,
      ),
      CityAchievement(
        id: '2',
        name: 'City Champion',
        description: 'Reach top 10 in $cityName leaderboard',
        icon: '🏆',
        category: 'ranking',
        targetValue: 10.0,
        currentValue: 45.0,
        isCompleted: false,
      ),
      CityAchievement(
        id: '3',
        name: 'Local Hero',
        description: 'Complete 50 cleanups in $cityName',
        icon: '🦸',
        category: 'cleanups',
        targetValue: 50.0,
        currentValue: 12.0,
        isCompleted: false,
      ),
      CityAchievement(
        id: '4',
        name: 'First Cleanup',
        description: 'Complete your first cleanup in $cityName',
        icon: '🌟',
        category: 'milestone',
        targetValue: 1.0,
        currentValue: 1.0,
        isCompleted: true,
        completedAt: DateTime(2024, 1, 15),
      ),
    ];
  }

  List<CityActivity> _getMockRecentActivity(String cityName) {
    final now = DateTime.now();
    return [
      CityActivity(
        id: '1',
        userId: '1',
        userName: 'Sarah J.',
        type: 'cleanup',
        description: 'completed a cleanup at Central Park',
        timestamp: now.subtract(const Duration(minutes: 30)),
        icon: '🧹',
      ),
      CityActivity(
        id: '2',
        userId: '2',
        userName: 'Mike C.',
        type: 'achievement',
        description: 'earned the "Beach Protector" badge',
        timestamp: now.subtract(const Duration(hours: 2)),
        icon: '🏅',
      ),
      CityActivity(
        id: '3',
        userId: '3',
        userName: 'Emma W.',
        type: 'cleanup',
        description: 'collected 15 lbs of trash at Riverside Park',
        timestamp: now.subtract(const Duration(hours: 4)),
        icon: '🗑️',
      ),
      CityActivity(
        id: '4',
        userId: '4',
        userName: 'James B.',
        type: 'milestone',
        description: 'reached 100 total cleanups',
        timestamp: now.subtract(const Duration(hours: 6)),
        icon: '🎯',
      ),
    ];
  }

  List<String> _getAvailableCities() {
    return [
      'St. Louis', // Only selectable city
    ];
  }
  
  List<String> _getComingSoonCities() {
    return [
      'New York',
      'Boston',
    ];
  }
}

final cityDashboardServiceProvider = Provider<CityDashboardService>((ref) {
  return CityDashboardService();
});