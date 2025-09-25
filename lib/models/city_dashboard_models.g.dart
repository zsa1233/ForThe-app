// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city_dashboard_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CityStatsImpl _$$CityStatsImplFromJson(Map<String, dynamic> json) =>
    _$CityStatsImpl(
      cityName: json['cityName'] as String,
      state: json['state'] as String,
      totalPoundsCollected: (json['totalPoundsCollected'] as num).toDouble(),
      totalCleanups: (json['totalCleanups'] as num).toInt(),
      activeUsers: (json['activeUsers'] as num).toInt(),
      totalHotspots: (json['totalHotspots'] as num).toInt(),
      completedHotspots: (json['completedHotspots'] as num).toInt(),
      topContributors: (json['topContributors'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      userRank: (json['userRank'] as num?)?.toDouble() ?? 0.0,
      userContribution: (json['userContribution'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$CityStatsImplToJson(_$CityStatsImpl instance) =>
    <String, dynamic>{
      'cityName': instance.cityName,
      'state': instance.state,
      'totalPoundsCollected': instance.totalPoundsCollected,
      'totalCleanups': instance.totalCleanups,
      'activeUsers': instance.activeUsers,
      'totalHotspots': instance.totalHotspots,
      'completedHotspots': instance.completedHotspots,
      'topContributors': instance.topContributors,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
      'userRank': instance.userRank,
      'userContribution': instance.userContribution,
    };

_$CityLeaderboardImpl _$$CityLeaderboardImplFromJson(
  Map<String, dynamic> json,
) => _$CityLeaderboardImpl(
  cityName: json['cityName'] as String,
  users: (json['users'] as List<dynamic>)
      .map((e) => CityUser.fromJson(e as Map<String, dynamic>))
      .toList(),
  lastUpdated: DateTime.parse(json['lastUpdated'] as String),
  period: json['period'] as String? ?? 'weekly',
);

Map<String, dynamic> _$$CityLeaderboardImplToJson(
  _$CityLeaderboardImpl instance,
) => <String, dynamic>{
  'cityName': instance.cityName,
  'users': instance.users,
  'lastUpdated': instance.lastUpdated.toIso8601String(),
  'period': instance.period,
};

_$CityUserImpl _$$CityUserImplFromJson(Map<String, dynamic> json) =>
    _$CityUserImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      initials: json['initials'] as String,
      rank: (json['rank'] as num).toInt(),
      poundsCollected: (json['poundsCollected'] as num).toDouble(),
      cleanupsCompleted: (json['cleanupsCompleted'] as num).toInt(),
      points: (json['points'] as num).toInt(),
      rankChange: (json['rankChange'] as num?)?.toInt() ?? 0,
      avatarUrl: json['avatarUrl'] as String?,
      badges:
          (json['badges'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$CityUserImplToJson(_$CityUserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'initials': instance.initials,
      'rank': instance.rank,
      'poundsCollected': instance.poundsCollected,
      'cleanupsCompleted': instance.cleanupsCompleted,
      'points': instance.points,
      'rankChange': instance.rankChange,
      'avatarUrl': instance.avatarUrl,
      'badges': instance.badges,
    };

_$CityAchievementImpl _$$CityAchievementImplFromJson(
  Map<String, dynamic> json,
) => _$CityAchievementImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  icon: json['icon'] as String,
  category: json['category'] as String,
  targetValue: (json['targetValue'] as num).toDouble(),
  currentValue: (json['currentValue'] as num).toDouble(),
  isCompleted: json['isCompleted'] as bool,
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
  isHidden: json['isHidden'] as bool? ?? false,
);

Map<String, dynamic> _$$CityAchievementImplToJson(
  _$CityAchievementImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'icon': instance.icon,
  'category': instance.category,
  'targetValue': instance.targetValue,
  'currentValue': instance.currentValue,
  'isCompleted': instance.isCompleted,
  'completedAt': instance.completedAt?.toIso8601String(),
  'isHidden': instance.isHidden,
};

_$CityActivityImpl _$$CityActivityImplFromJson(Map<String, dynamic> json) =>
    _$CityActivityImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      type: json['type'] as String,
      description: json['description'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      icon: json['icon'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$CityActivityImplToJson(_$CityActivityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'userName': instance.userName,
      'type': instance.type,
      'description': instance.description,
      'timestamp': instance.timestamp.toIso8601String(),
      'icon': instance.icon,
      'metadata': instance.metadata,
    };

_$CityDashboardDataImpl _$$CityDashboardDataImplFromJson(
  Map<String, dynamic> json,
) => _$CityDashboardDataImpl(
  stats: CityStats.fromJson(json['stats'] as Map<String, dynamic>),
  leaderboard: CityLeaderboard.fromJson(
    json['leaderboard'] as Map<String, dynamic>,
  ),
  achievements: (json['achievements'] as List<dynamic>)
      .map((e) => CityAchievement.fromJson(e as Map<String, dynamic>))
      .toList(),
  recentActivity: (json['recentActivity'] as List<dynamic>)
      .map((e) => CityActivity.fromJson(e as Map<String, dynamic>))
      .toList(),
  availableCities:
      (json['availableCities'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$$CityDashboardDataImplToJson(
  _$CityDashboardDataImpl instance,
) => <String, dynamic>{
  'stats': instance.stats,
  'leaderboard': instance.leaderboard,
  'achievements': instance.achievements,
  'recentActivity': instance.recentActivity,
  'availableCities': instance.availableCities,
};
