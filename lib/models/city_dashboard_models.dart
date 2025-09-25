import 'package:freezed_annotation/freezed_annotation.dart';

part 'city_dashboard_models.freezed.dart';
part 'city_dashboard_models.g.dart';

@freezed
class CityStats with _$CityStats {
  const factory CityStats({
    required String cityName,
    required String state,
    required double totalPoundsCollected,
    required int totalCleanups,
    required int activeUsers,
    required int totalHotspots,
    required int completedHotspots,
    required List<String> topContributors,
    required DateTime lastUpdated,
    @Default(0.0) double userRank,
    @Default(0.0) double userContribution,
  }) = _CityStats;

  factory CityStats.fromJson(Map<String, dynamic> json) => _$CityStatsFromJson(json);
}

@freezed
class CityLeaderboard with _$CityLeaderboard {
  const factory CityLeaderboard({
    required String cityName,
    required List<CityUser> users,
    required DateTime lastUpdated,
    @Default('weekly') String period, // weekly, monthly, all-time
  }) = _CityLeaderboard;

  factory CityLeaderboard.fromJson(Map<String, dynamic> json) => _$CityLeaderboardFromJson(json);
}

@freezed
class CityUser with _$CityUser {
  const factory CityUser({
    required String id,
    required String name,
    required String initials,
    required int rank,
    required double poundsCollected,
    required int cleanupsCompleted,
    required int points,
    @Default(0) int rankChange, // positive = up, negative = down
    String? avatarUrl,
    @Default([]) List<String> badges,
  }) = _CityUser;

  factory CityUser.fromJson(Map<String, dynamic> json) => _$CityUserFromJson(json);
}

@freezed
class CityAchievement with _$CityAchievement {
  const factory CityAchievement({
    required String id,
    required String name,
    required String description,
    required String icon,
    required String category,
    required double targetValue,
    required double currentValue,
    required bool isCompleted,
    DateTime? completedAt,
    @Default(false) bool isHidden,
  }) = _CityAchievement;

  factory CityAchievement.fromJson(Map<String, dynamic> json) => _$CityAchievementFromJson(json);
}

@freezed
class CityActivity with _$CityActivity {
  const factory CityActivity({
    required String id,
    required String userId,
    required String userName,
    required String type, // cleanup, achievement, milestone
    required String description,
    required DateTime timestamp,
    String? icon,
    Map<String, dynamic>? metadata,
  }) = _CityActivity;

  factory CityActivity.fromJson(Map<String, dynamic> json) => _$CityActivityFromJson(json);
}

@freezed
class CityDashboardData with _$CityDashboardData {
  const factory CityDashboardData({
    required CityStats stats,
    required CityLeaderboard leaderboard,
    required List<CityAchievement> achievements,
    required List<CityActivity> recentActivity,
    @Default([]) List<String> availableCities,
  }) = _CityDashboardData;

  factory CityDashboardData.fromJson(Map<String, dynamic> json) => _$CityDashboardDataFromJson(json);
}

enum TimePeriod {
  @JsonValue('weekly')
  weekly,
  @JsonValue('monthly')
  monthly,
  @JsonValue('all-time')
  allTime,
}

extension TimePeriodExtension on TimePeriod {
  String get displayName {
    switch (this) {
      case TimePeriod.weekly:
        return 'This Week';
      case TimePeriod.monthly:
        return 'This Month';
      case TimePeriod.allTime:
        return 'All Time';
    }
  }
}