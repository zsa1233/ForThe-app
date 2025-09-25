// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'city_dashboard_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CityStats _$CityStatsFromJson(Map<String, dynamic> json) {
  return _CityStats.fromJson(json);
}

/// @nodoc
mixin _$CityStats {
  String get cityName => throw _privateConstructorUsedError;
  String get state => throw _privateConstructorUsedError;
  double get totalPoundsCollected => throw _privateConstructorUsedError;
  int get totalCleanups => throw _privateConstructorUsedError;
  int get activeUsers => throw _privateConstructorUsedError;
  int get totalHotspots => throw _privateConstructorUsedError;
  int get completedHotspots => throw _privateConstructorUsedError;
  List<String> get topContributors => throw _privateConstructorUsedError;
  DateTime get lastUpdated => throw _privateConstructorUsedError;
  double get userRank => throw _privateConstructorUsedError;
  double get userContribution => throw _privateConstructorUsedError;

  /// Serializes this CityStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CityStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CityStatsCopyWith<CityStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CityStatsCopyWith<$Res> {
  factory $CityStatsCopyWith(CityStats value, $Res Function(CityStats) then) =
      _$CityStatsCopyWithImpl<$Res, CityStats>;
  @useResult
  $Res call({
    String cityName,
    String state,
    double totalPoundsCollected,
    int totalCleanups,
    int activeUsers,
    int totalHotspots,
    int completedHotspots,
    List<String> topContributors,
    DateTime lastUpdated,
    double userRank,
    double userContribution,
  });
}

/// @nodoc
class _$CityStatsCopyWithImpl<$Res, $Val extends CityStats>
    implements $CityStatsCopyWith<$Res> {
  _$CityStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CityStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cityName = null,
    Object? state = null,
    Object? totalPoundsCollected = null,
    Object? totalCleanups = null,
    Object? activeUsers = null,
    Object? totalHotspots = null,
    Object? completedHotspots = null,
    Object? topContributors = null,
    Object? lastUpdated = null,
    Object? userRank = null,
    Object? userContribution = null,
  }) {
    return _then(
      _value.copyWith(
            cityName: null == cityName
                ? _value.cityName
                : cityName // ignore: cast_nullable_to_non_nullable
                      as String,
            state: null == state
                ? _value.state
                : state // ignore: cast_nullable_to_non_nullable
                      as String,
            totalPoundsCollected: null == totalPoundsCollected
                ? _value.totalPoundsCollected
                : totalPoundsCollected // ignore: cast_nullable_to_non_nullable
                      as double,
            totalCleanups: null == totalCleanups
                ? _value.totalCleanups
                : totalCleanups // ignore: cast_nullable_to_non_nullable
                      as int,
            activeUsers: null == activeUsers
                ? _value.activeUsers
                : activeUsers // ignore: cast_nullable_to_non_nullable
                      as int,
            totalHotspots: null == totalHotspots
                ? _value.totalHotspots
                : totalHotspots // ignore: cast_nullable_to_non_nullable
                      as int,
            completedHotspots: null == completedHotspots
                ? _value.completedHotspots
                : completedHotspots // ignore: cast_nullable_to_non_nullable
                      as int,
            topContributors: null == topContributors
                ? _value.topContributors
                : topContributors // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            lastUpdated: null == lastUpdated
                ? _value.lastUpdated
                : lastUpdated // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            userRank: null == userRank
                ? _value.userRank
                : userRank // ignore: cast_nullable_to_non_nullable
                      as double,
            userContribution: null == userContribution
                ? _value.userContribution
                : userContribution // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CityStatsImplCopyWith<$Res>
    implements $CityStatsCopyWith<$Res> {
  factory _$$CityStatsImplCopyWith(
    _$CityStatsImpl value,
    $Res Function(_$CityStatsImpl) then,
  ) = __$$CityStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String cityName,
    String state,
    double totalPoundsCollected,
    int totalCleanups,
    int activeUsers,
    int totalHotspots,
    int completedHotspots,
    List<String> topContributors,
    DateTime lastUpdated,
    double userRank,
    double userContribution,
  });
}

/// @nodoc
class __$$CityStatsImplCopyWithImpl<$Res>
    extends _$CityStatsCopyWithImpl<$Res, _$CityStatsImpl>
    implements _$$CityStatsImplCopyWith<$Res> {
  __$$CityStatsImplCopyWithImpl(
    _$CityStatsImpl _value,
    $Res Function(_$CityStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CityStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cityName = null,
    Object? state = null,
    Object? totalPoundsCollected = null,
    Object? totalCleanups = null,
    Object? activeUsers = null,
    Object? totalHotspots = null,
    Object? completedHotspots = null,
    Object? topContributors = null,
    Object? lastUpdated = null,
    Object? userRank = null,
    Object? userContribution = null,
  }) {
    return _then(
      _$CityStatsImpl(
        cityName: null == cityName
            ? _value.cityName
            : cityName // ignore: cast_nullable_to_non_nullable
                  as String,
        state: null == state
            ? _value.state
            : state // ignore: cast_nullable_to_non_nullable
                  as String,
        totalPoundsCollected: null == totalPoundsCollected
            ? _value.totalPoundsCollected
            : totalPoundsCollected // ignore: cast_nullable_to_non_nullable
                  as double,
        totalCleanups: null == totalCleanups
            ? _value.totalCleanups
            : totalCleanups // ignore: cast_nullable_to_non_nullable
                  as int,
        activeUsers: null == activeUsers
            ? _value.activeUsers
            : activeUsers // ignore: cast_nullable_to_non_nullable
                  as int,
        totalHotspots: null == totalHotspots
            ? _value.totalHotspots
            : totalHotspots // ignore: cast_nullable_to_non_nullable
                  as int,
        completedHotspots: null == completedHotspots
            ? _value.completedHotspots
            : completedHotspots // ignore: cast_nullable_to_non_nullable
                  as int,
        topContributors: null == topContributors
            ? _value._topContributors
            : topContributors // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        lastUpdated: null == lastUpdated
            ? _value.lastUpdated
            : lastUpdated // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        userRank: null == userRank
            ? _value.userRank
            : userRank // ignore: cast_nullable_to_non_nullable
                  as double,
        userContribution: null == userContribution
            ? _value.userContribution
            : userContribution // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CityStatsImpl implements _CityStats {
  const _$CityStatsImpl({
    required this.cityName,
    required this.state,
    required this.totalPoundsCollected,
    required this.totalCleanups,
    required this.activeUsers,
    required this.totalHotspots,
    required this.completedHotspots,
    required final List<String> topContributors,
    required this.lastUpdated,
    this.userRank = 0.0,
    this.userContribution = 0.0,
  }) : _topContributors = topContributors;

  factory _$CityStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$CityStatsImplFromJson(json);

  @override
  final String cityName;
  @override
  final String state;
  @override
  final double totalPoundsCollected;
  @override
  final int totalCleanups;
  @override
  final int activeUsers;
  @override
  final int totalHotspots;
  @override
  final int completedHotspots;
  final List<String> _topContributors;
  @override
  List<String> get topContributors {
    if (_topContributors is EqualUnmodifiableListView) return _topContributors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topContributors);
  }

  @override
  final DateTime lastUpdated;
  @override
  @JsonKey()
  final double userRank;
  @override
  @JsonKey()
  final double userContribution;

  @override
  String toString() {
    return 'CityStats(cityName: $cityName, state: $state, totalPoundsCollected: $totalPoundsCollected, totalCleanups: $totalCleanups, activeUsers: $activeUsers, totalHotspots: $totalHotspots, completedHotspots: $completedHotspots, topContributors: $topContributors, lastUpdated: $lastUpdated, userRank: $userRank, userContribution: $userContribution)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CityStatsImpl &&
            (identical(other.cityName, cityName) ||
                other.cityName == cityName) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.totalPoundsCollected, totalPoundsCollected) ||
                other.totalPoundsCollected == totalPoundsCollected) &&
            (identical(other.totalCleanups, totalCleanups) ||
                other.totalCleanups == totalCleanups) &&
            (identical(other.activeUsers, activeUsers) ||
                other.activeUsers == activeUsers) &&
            (identical(other.totalHotspots, totalHotspots) ||
                other.totalHotspots == totalHotspots) &&
            (identical(other.completedHotspots, completedHotspots) ||
                other.completedHotspots == completedHotspots) &&
            const DeepCollectionEquality().equals(
              other._topContributors,
              _topContributors,
            ) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            (identical(other.userRank, userRank) ||
                other.userRank == userRank) &&
            (identical(other.userContribution, userContribution) ||
                other.userContribution == userContribution));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    cityName,
    state,
    totalPoundsCollected,
    totalCleanups,
    activeUsers,
    totalHotspots,
    completedHotspots,
    const DeepCollectionEquality().hash(_topContributors),
    lastUpdated,
    userRank,
    userContribution,
  );

  /// Create a copy of CityStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CityStatsImplCopyWith<_$CityStatsImpl> get copyWith =>
      __$$CityStatsImplCopyWithImpl<_$CityStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CityStatsImplToJson(this);
  }
}

abstract class _CityStats implements CityStats {
  const factory _CityStats({
    required final String cityName,
    required final String state,
    required final double totalPoundsCollected,
    required final int totalCleanups,
    required final int activeUsers,
    required final int totalHotspots,
    required final int completedHotspots,
    required final List<String> topContributors,
    required final DateTime lastUpdated,
    final double userRank,
    final double userContribution,
  }) = _$CityStatsImpl;

  factory _CityStats.fromJson(Map<String, dynamic> json) =
      _$CityStatsImpl.fromJson;

  @override
  String get cityName;
  @override
  String get state;
  @override
  double get totalPoundsCollected;
  @override
  int get totalCleanups;
  @override
  int get activeUsers;
  @override
  int get totalHotspots;
  @override
  int get completedHotspots;
  @override
  List<String> get topContributors;
  @override
  DateTime get lastUpdated;
  @override
  double get userRank;
  @override
  double get userContribution;

  /// Create a copy of CityStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CityStatsImplCopyWith<_$CityStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CityLeaderboard _$CityLeaderboardFromJson(Map<String, dynamic> json) {
  return _CityLeaderboard.fromJson(json);
}

/// @nodoc
mixin _$CityLeaderboard {
  String get cityName => throw _privateConstructorUsedError;
  List<CityUser> get users => throw _privateConstructorUsedError;
  DateTime get lastUpdated => throw _privateConstructorUsedError;
  String get period => throw _privateConstructorUsedError;

  /// Serializes this CityLeaderboard to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CityLeaderboard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CityLeaderboardCopyWith<CityLeaderboard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CityLeaderboardCopyWith<$Res> {
  factory $CityLeaderboardCopyWith(
    CityLeaderboard value,
    $Res Function(CityLeaderboard) then,
  ) = _$CityLeaderboardCopyWithImpl<$Res, CityLeaderboard>;
  @useResult
  $Res call({
    String cityName,
    List<CityUser> users,
    DateTime lastUpdated,
    String period,
  });
}

/// @nodoc
class _$CityLeaderboardCopyWithImpl<$Res, $Val extends CityLeaderboard>
    implements $CityLeaderboardCopyWith<$Res> {
  _$CityLeaderboardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CityLeaderboard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cityName = null,
    Object? users = null,
    Object? lastUpdated = null,
    Object? period = null,
  }) {
    return _then(
      _value.copyWith(
            cityName: null == cityName
                ? _value.cityName
                : cityName // ignore: cast_nullable_to_non_nullable
                      as String,
            users: null == users
                ? _value.users
                : users // ignore: cast_nullable_to_non_nullable
                      as List<CityUser>,
            lastUpdated: null == lastUpdated
                ? _value.lastUpdated
                : lastUpdated // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            period: null == period
                ? _value.period
                : period // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CityLeaderboardImplCopyWith<$Res>
    implements $CityLeaderboardCopyWith<$Res> {
  factory _$$CityLeaderboardImplCopyWith(
    _$CityLeaderboardImpl value,
    $Res Function(_$CityLeaderboardImpl) then,
  ) = __$$CityLeaderboardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String cityName,
    List<CityUser> users,
    DateTime lastUpdated,
    String period,
  });
}

/// @nodoc
class __$$CityLeaderboardImplCopyWithImpl<$Res>
    extends _$CityLeaderboardCopyWithImpl<$Res, _$CityLeaderboardImpl>
    implements _$$CityLeaderboardImplCopyWith<$Res> {
  __$$CityLeaderboardImplCopyWithImpl(
    _$CityLeaderboardImpl _value,
    $Res Function(_$CityLeaderboardImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CityLeaderboard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cityName = null,
    Object? users = null,
    Object? lastUpdated = null,
    Object? period = null,
  }) {
    return _then(
      _$CityLeaderboardImpl(
        cityName: null == cityName
            ? _value.cityName
            : cityName // ignore: cast_nullable_to_non_nullable
                  as String,
        users: null == users
            ? _value._users
            : users // ignore: cast_nullable_to_non_nullable
                  as List<CityUser>,
        lastUpdated: null == lastUpdated
            ? _value.lastUpdated
            : lastUpdated // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        period: null == period
            ? _value.period
            : period // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CityLeaderboardImpl implements _CityLeaderboard {
  const _$CityLeaderboardImpl({
    required this.cityName,
    required final List<CityUser> users,
    required this.lastUpdated,
    this.period = 'weekly',
  }) : _users = users;

  factory _$CityLeaderboardImpl.fromJson(Map<String, dynamic> json) =>
      _$$CityLeaderboardImplFromJson(json);

  @override
  final String cityName;
  final List<CityUser> _users;
  @override
  List<CityUser> get users {
    if (_users is EqualUnmodifiableListView) return _users;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_users);
  }

  @override
  final DateTime lastUpdated;
  @override
  @JsonKey()
  final String period;

  @override
  String toString() {
    return 'CityLeaderboard(cityName: $cityName, users: $users, lastUpdated: $lastUpdated, period: $period)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CityLeaderboardImpl &&
            (identical(other.cityName, cityName) ||
                other.cityName == cityName) &&
            const DeepCollectionEquality().equals(other._users, _users) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            (identical(other.period, period) || other.period == period));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    cityName,
    const DeepCollectionEquality().hash(_users),
    lastUpdated,
    period,
  );

  /// Create a copy of CityLeaderboard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CityLeaderboardImplCopyWith<_$CityLeaderboardImpl> get copyWith =>
      __$$CityLeaderboardImplCopyWithImpl<_$CityLeaderboardImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CityLeaderboardImplToJson(this);
  }
}

abstract class _CityLeaderboard implements CityLeaderboard {
  const factory _CityLeaderboard({
    required final String cityName,
    required final List<CityUser> users,
    required final DateTime lastUpdated,
    final String period,
  }) = _$CityLeaderboardImpl;

  factory _CityLeaderboard.fromJson(Map<String, dynamic> json) =
      _$CityLeaderboardImpl.fromJson;

  @override
  String get cityName;
  @override
  List<CityUser> get users;
  @override
  DateTime get lastUpdated;
  @override
  String get period;

  /// Create a copy of CityLeaderboard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CityLeaderboardImplCopyWith<_$CityLeaderboardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CityUser _$CityUserFromJson(Map<String, dynamic> json) {
  return _CityUser.fromJson(json);
}

/// @nodoc
mixin _$CityUser {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get initials => throw _privateConstructorUsedError;
  int get rank => throw _privateConstructorUsedError;
  double get poundsCollected => throw _privateConstructorUsedError;
  int get cleanupsCompleted => throw _privateConstructorUsedError;
  int get points => throw _privateConstructorUsedError;
  int get rankChange =>
      throw _privateConstructorUsedError; // positive = up, negative = down
  String? get avatarUrl => throw _privateConstructorUsedError;
  List<String> get badges => throw _privateConstructorUsedError;

  /// Serializes this CityUser to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CityUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CityUserCopyWith<CityUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CityUserCopyWith<$Res> {
  factory $CityUserCopyWith(CityUser value, $Res Function(CityUser) then) =
      _$CityUserCopyWithImpl<$Res, CityUser>;
  @useResult
  $Res call({
    String id,
    String name,
    String initials,
    int rank,
    double poundsCollected,
    int cleanupsCompleted,
    int points,
    int rankChange,
    String? avatarUrl,
    List<String> badges,
  });
}

/// @nodoc
class _$CityUserCopyWithImpl<$Res, $Val extends CityUser>
    implements $CityUserCopyWith<$Res> {
  _$CityUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CityUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? initials = null,
    Object? rank = null,
    Object? poundsCollected = null,
    Object? cleanupsCompleted = null,
    Object? points = null,
    Object? rankChange = null,
    Object? avatarUrl = freezed,
    Object? badges = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            initials: null == initials
                ? _value.initials
                : initials // ignore: cast_nullable_to_non_nullable
                      as String,
            rank: null == rank
                ? _value.rank
                : rank // ignore: cast_nullable_to_non_nullable
                      as int,
            poundsCollected: null == poundsCollected
                ? _value.poundsCollected
                : poundsCollected // ignore: cast_nullable_to_non_nullable
                      as double,
            cleanupsCompleted: null == cleanupsCompleted
                ? _value.cleanupsCompleted
                : cleanupsCompleted // ignore: cast_nullable_to_non_nullable
                      as int,
            points: null == points
                ? _value.points
                : points // ignore: cast_nullable_to_non_nullable
                      as int,
            rankChange: null == rankChange
                ? _value.rankChange
                : rankChange // ignore: cast_nullable_to_non_nullable
                      as int,
            avatarUrl: freezed == avatarUrl
                ? _value.avatarUrl
                : avatarUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            badges: null == badges
                ? _value.badges
                : badges // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CityUserImplCopyWith<$Res>
    implements $CityUserCopyWith<$Res> {
  factory _$$CityUserImplCopyWith(
    _$CityUserImpl value,
    $Res Function(_$CityUserImpl) then,
  ) = __$$CityUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String initials,
    int rank,
    double poundsCollected,
    int cleanupsCompleted,
    int points,
    int rankChange,
    String? avatarUrl,
    List<String> badges,
  });
}

/// @nodoc
class __$$CityUserImplCopyWithImpl<$Res>
    extends _$CityUserCopyWithImpl<$Res, _$CityUserImpl>
    implements _$$CityUserImplCopyWith<$Res> {
  __$$CityUserImplCopyWithImpl(
    _$CityUserImpl _value,
    $Res Function(_$CityUserImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CityUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? initials = null,
    Object? rank = null,
    Object? poundsCollected = null,
    Object? cleanupsCompleted = null,
    Object? points = null,
    Object? rankChange = null,
    Object? avatarUrl = freezed,
    Object? badges = null,
  }) {
    return _then(
      _$CityUserImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        initials: null == initials
            ? _value.initials
            : initials // ignore: cast_nullable_to_non_nullable
                  as String,
        rank: null == rank
            ? _value.rank
            : rank // ignore: cast_nullable_to_non_nullable
                  as int,
        poundsCollected: null == poundsCollected
            ? _value.poundsCollected
            : poundsCollected // ignore: cast_nullable_to_non_nullable
                  as double,
        cleanupsCompleted: null == cleanupsCompleted
            ? _value.cleanupsCompleted
            : cleanupsCompleted // ignore: cast_nullable_to_non_nullable
                  as int,
        points: null == points
            ? _value.points
            : points // ignore: cast_nullable_to_non_nullable
                  as int,
        rankChange: null == rankChange
            ? _value.rankChange
            : rankChange // ignore: cast_nullable_to_non_nullable
                  as int,
        avatarUrl: freezed == avatarUrl
            ? _value.avatarUrl
            : avatarUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        badges: null == badges
            ? _value._badges
            : badges // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CityUserImpl implements _CityUser {
  const _$CityUserImpl({
    required this.id,
    required this.name,
    required this.initials,
    required this.rank,
    required this.poundsCollected,
    required this.cleanupsCompleted,
    required this.points,
    this.rankChange = 0,
    this.avatarUrl,
    final List<String> badges = const [],
  }) : _badges = badges;

  factory _$CityUserImpl.fromJson(Map<String, dynamic> json) =>
      _$$CityUserImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String initials;
  @override
  final int rank;
  @override
  final double poundsCollected;
  @override
  final int cleanupsCompleted;
  @override
  final int points;
  @override
  @JsonKey()
  final int rankChange;
  // positive = up, negative = down
  @override
  final String? avatarUrl;
  final List<String> _badges;
  @override
  @JsonKey()
  List<String> get badges {
    if (_badges is EqualUnmodifiableListView) return _badges;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_badges);
  }

  @override
  String toString() {
    return 'CityUser(id: $id, name: $name, initials: $initials, rank: $rank, poundsCollected: $poundsCollected, cleanupsCompleted: $cleanupsCompleted, points: $points, rankChange: $rankChange, avatarUrl: $avatarUrl, badges: $badges)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CityUserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.initials, initials) ||
                other.initials == initials) &&
            (identical(other.rank, rank) || other.rank == rank) &&
            (identical(other.poundsCollected, poundsCollected) ||
                other.poundsCollected == poundsCollected) &&
            (identical(other.cleanupsCompleted, cleanupsCompleted) ||
                other.cleanupsCompleted == cleanupsCompleted) &&
            (identical(other.points, points) || other.points == points) &&
            (identical(other.rankChange, rankChange) ||
                other.rankChange == rankChange) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            const DeepCollectionEquality().equals(other._badges, _badges));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    initials,
    rank,
    poundsCollected,
    cleanupsCompleted,
    points,
    rankChange,
    avatarUrl,
    const DeepCollectionEquality().hash(_badges),
  );

  /// Create a copy of CityUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CityUserImplCopyWith<_$CityUserImpl> get copyWith =>
      __$$CityUserImplCopyWithImpl<_$CityUserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CityUserImplToJson(this);
  }
}

abstract class _CityUser implements CityUser {
  const factory _CityUser({
    required final String id,
    required final String name,
    required final String initials,
    required final int rank,
    required final double poundsCollected,
    required final int cleanupsCompleted,
    required final int points,
    final int rankChange,
    final String? avatarUrl,
    final List<String> badges,
  }) = _$CityUserImpl;

  factory _CityUser.fromJson(Map<String, dynamic> json) =
      _$CityUserImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get initials;
  @override
  int get rank;
  @override
  double get poundsCollected;
  @override
  int get cleanupsCompleted;
  @override
  int get points;
  @override
  int get rankChange; // positive = up, negative = down
  @override
  String? get avatarUrl;
  @override
  List<String> get badges;

  /// Create a copy of CityUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CityUserImplCopyWith<_$CityUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CityAchievement _$CityAchievementFromJson(Map<String, dynamic> json) {
  return _CityAchievement.fromJson(json);
}

/// @nodoc
mixin _$CityAchievement {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get icon => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  double get targetValue => throw _privateConstructorUsedError;
  double get currentValue => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  bool get isHidden => throw _privateConstructorUsedError;

  /// Serializes this CityAchievement to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CityAchievement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CityAchievementCopyWith<CityAchievement> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CityAchievementCopyWith<$Res> {
  factory $CityAchievementCopyWith(
    CityAchievement value,
    $Res Function(CityAchievement) then,
  ) = _$CityAchievementCopyWithImpl<$Res, CityAchievement>;
  @useResult
  $Res call({
    String id,
    String name,
    String description,
    String icon,
    String category,
    double targetValue,
    double currentValue,
    bool isCompleted,
    DateTime? completedAt,
    bool isHidden,
  });
}

/// @nodoc
class _$CityAchievementCopyWithImpl<$Res, $Val extends CityAchievement>
    implements $CityAchievementCopyWith<$Res> {
  _$CityAchievementCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CityAchievement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? icon = null,
    Object? category = null,
    Object? targetValue = null,
    Object? currentValue = null,
    Object? isCompleted = null,
    Object? completedAt = freezed,
    Object? isHidden = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            icon: null == icon
                ? _value.icon
                : icon // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            targetValue: null == targetValue
                ? _value.targetValue
                : targetValue // ignore: cast_nullable_to_non_nullable
                      as double,
            currentValue: null == currentValue
                ? _value.currentValue
                : currentValue // ignore: cast_nullable_to_non_nullable
                      as double,
            isCompleted: null == isCompleted
                ? _value.isCompleted
                : isCompleted // ignore: cast_nullable_to_non_nullable
                      as bool,
            completedAt: freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            isHidden: null == isHidden
                ? _value.isHidden
                : isHidden // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CityAchievementImplCopyWith<$Res>
    implements $CityAchievementCopyWith<$Res> {
  factory _$$CityAchievementImplCopyWith(
    _$CityAchievementImpl value,
    $Res Function(_$CityAchievementImpl) then,
  ) = __$$CityAchievementImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String description,
    String icon,
    String category,
    double targetValue,
    double currentValue,
    bool isCompleted,
    DateTime? completedAt,
    bool isHidden,
  });
}

/// @nodoc
class __$$CityAchievementImplCopyWithImpl<$Res>
    extends _$CityAchievementCopyWithImpl<$Res, _$CityAchievementImpl>
    implements _$$CityAchievementImplCopyWith<$Res> {
  __$$CityAchievementImplCopyWithImpl(
    _$CityAchievementImpl _value,
    $Res Function(_$CityAchievementImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CityAchievement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? icon = null,
    Object? category = null,
    Object? targetValue = null,
    Object? currentValue = null,
    Object? isCompleted = null,
    Object? completedAt = freezed,
    Object? isHidden = null,
  }) {
    return _then(
      _$CityAchievementImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        icon: null == icon
            ? _value.icon
            : icon // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        targetValue: null == targetValue
            ? _value.targetValue
            : targetValue // ignore: cast_nullable_to_non_nullable
                  as double,
        currentValue: null == currentValue
            ? _value.currentValue
            : currentValue // ignore: cast_nullable_to_non_nullable
                  as double,
        isCompleted: null == isCompleted
            ? _value.isCompleted
            : isCompleted // ignore: cast_nullable_to_non_nullable
                  as bool,
        completedAt: freezed == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        isHidden: null == isHidden
            ? _value.isHidden
            : isHidden // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CityAchievementImpl implements _CityAchievement {
  const _$CityAchievementImpl({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.category,
    required this.targetValue,
    required this.currentValue,
    required this.isCompleted,
    this.completedAt,
    this.isHidden = false,
  });

  factory _$CityAchievementImpl.fromJson(Map<String, dynamic> json) =>
      _$$CityAchievementImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  final String icon;
  @override
  final String category;
  @override
  final double targetValue;
  @override
  final double currentValue;
  @override
  final bool isCompleted;
  @override
  final DateTime? completedAt;
  @override
  @JsonKey()
  final bool isHidden;

  @override
  String toString() {
    return 'CityAchievement(id: $id, name: $name, description: $description, icon: $icon, category: $category, targetValue: $targetValue, currentValue: $currentValue, isCompleted: $isCompleted, completedAt: $completedAt, isHidden: $isHidden)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CityAchievementImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.targetValue, targetValue) ||
                other.targetValue == targetValue) &&
            (identical(other.currentValue, currentValue) ||
                other.currentValue == currentValue) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.isHidden, isHidden) ||
                other.isHidden == isHidden));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    description,
    icon,
    category,
    targetValue,
    currentValue,
    isCompleted,
    completedAt,
    isHidden,
  );

  /// Create a copy of CityAchievement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CityAchievementImplCopyWith<_$CityAchievementImpl> get copyWith =>
      __$$CityAchievementImplCopyWithImpl<_$CityAchievementImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CityAchievementImplToJson(this);
  }
}

abstract class _CityAchievement implements CityAchievement {
  const factory _CityAchievement({
    required final String id,
    required final String name,
    required final String description,
    required final String icon,
    required final String category,
    required final double targetValue,
    required final double currentValue,
    required final bool isCompleted,
    final DateTime? completedAt,
    final bool isHidden,
  }) = _$CityAchievementImpl;

  factory _CityAchievement.fromJson(Map<String, dynamic> json) =
      _$CityAchievementImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  String get icon;
  @override
  String get category;
  @override
  double get targetValue;
  @override
  double get currentValue;
  @override
  bool get isCompleted;
  @override
  DateTime? get completedAt;
  @override
  bool get isHidden;

  /// Create a copy of CityAchievement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CityAchievementImplCopyWith<_$CityAchievementImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CityActivity _$CityActivityFromJson(Map<String, dynamic> json) {
  return _CityActivity.fromJson(json);
}

/// @nodoc
mixin _$CityActivity {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  String get type =>
      throw _privateConstructorUsedError; // cleanup, achievement, milestone
  String get description => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this CityActivity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CityActivity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CityActivityCopyWith<CityActivity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CityActivityCopyWith<$Res> {
  factory $CityActivityCopyWith(
    CityActivity value,
    $Res Function(CityActivity) then,
  ) = _$CityActivityCopyWithImpl<$Res, CityActivity>;
  @useResult
  $Res call({
    String id,
    String userId,
    String userName,
    String type,
    String description,
    DateTime timestamp,
    String? icon,
    Map<String, dynamic>? metadata,
  });
}

/// @nodoc
class _$CityActivityCopyWithImpl<$Res, $Val extends CityActivity>
    implements $CityActivityCopyWith<$Res> {
  _$CityActivityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CityActivity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? userName = null,
    Object? type = null,
    Object? description = null,
    Object? timestamp = null,
    Object? icon = freezed,
    Object? metadata = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            userName: null == userName
                ? _value.userName
                : userName // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            icon: freezed == icon
                ? _value.icon
                : icon // ignore: cast_nullable_to_non_nullable
                      as String?,
            metadata: freezed == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CityActivityImplCopyWith<$Res>
    implements $CityActivityCopyWith<$Res> {
  factory _$$CityActivityImplCopyWith(
    _$CityActivityImpl value,
    $Res Function(_$CityActivityImpl) then,
  ) = __$$CityActivityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String userName,
    String type,
    String description,
    DateTime timestamp,
    String? icon,
    Map<String, dynamic>? metadata,
  });
}

/// @nodoc
class __$$CityActivityImplCopyWithImpl<$Res>
    extends _$CityActivityCopyWithImpl<$Res, _$CityActivityImpl>
    implements _$$CityActivityImplCopyWith<$Res> {
  __$$CityActivityImplCopyWithImpl(
    _$CityActivityImpl _value,
    $Res Function(_$CityActivityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CityActivity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? userName = null,
    Object? type = null,
    Object? description = null,
    Object? timestamp = null,
    Object? icon = freezed,
    Object? metadata = freezed,
  }) {
    return _then(
      _$CityActivityImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        userName: null == userName
            ? _value.userName
            : userName // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        icon: freezed == icon
            ? _value.icon
            : icon // ignore: cast_nullable_to_non_nullable
                  as String?,
        metadata: freezed == metadata
            ? _value._metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CityActivityImpl implements _CityActivity {
  const _$CityActivityImpl({
    required this.id,
    required this.userId,
    required this.userName,
    required this.type,
    required this.description,
    required this.timestamp,
    this.icon,
    final Map<String, dynamic>? metadata,
  }) : _metadata = metadata;

  factory _$CityActivityImpl.fromJson(Map<String, dynamic> json) =>
      _$$CityActivityImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String userName;
  @override
  final String type;
  // cleanup, achievement, milestone
  @override
  final String description;
  @override
  final DateTime timestamp;
  @override
  final String? icon;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'CityActivity(id: $id, userId: $userId, userName: $userName, type: $type, description: $description, timestamp: $timestamp, icon: $icon, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CityActivityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    userName,
    type,
    description,
    timestamp,
    icon,
    const DeepCollectionEquality().hash(_metadata),
  );

  /// Create a copy of CityActivity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CityActivityImplCopyWith<_$CityActivityImpl> get copyWith =>
      __$$CityActivityImplCopyWithImpl<_$CityActivityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CityActivityImplToJson(this);
  }
}

abstract class _CityActivity implements CityActivity {
  const factory _CityActivity({
    required final String id,
    required final String userId,
    required final String userName,
    required final String type,
    required final String description,
    required final DateTime timestamp,
    final String? icon,
    final Map<String, dynamic>? metadata,
  }) = _$CityActivityImpl;

  factory _CityActivity.fromJson(Map<String, dynamic> json) =
      _$CityActivityImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get userName;
  @override
  String get type; // cleanup, achievement, milestone
  @override
  String get description;
  @override
  DateTime get timestamp;
  @override
  String? get icon;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of CityActivity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CityActivityImplCopyWith<_$CityActivityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CityDashboardData _$CityDashboardDataFromJson(Map<String, dynamic> json) {
  return _CityDashboardData.fromJson(json);
}

/// @nodoc
mixin _$CityDashboardData {
  CityStats get stats => throw _privateConstructorUsedError;
  CityLeaderboard get leaderboard => throw _privateConstructorUsedError;
  List<CityAchievement> get achievements => throw _privateConstructorUsedError;
  List<CityActivity> get recentActivity => throw _privateConstructorUsedError;
  List<String> get availableCities => throw _privateConstructorUsedError;

  /// Serializes this CityDashboardData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CityDashboardData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CityDashboardDataCopyWith<CityDashboardData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CityDashboardDataCopyWith<$Res> {
  factory $CityDashboardDataCopyWith(
    CityDashboardData value,
    $Res Function(CityDashboardData) then,
  ) = _$CityDashboardDataCopyWithImpl<$Res, CityDashboardData>;
  @useResult
  $Res call({
    CityStats stats,
    CityLeaderboard leaderboard,
    List<CityAchievement> achievements,
    List<CityActivity> recentActivity,
    List<String> availableCities,
  });

  $CityStatsCopyWith<$Res> get stats;
  $CityLeaderboardCopyWith<$Res> get leaderboard;
}

/// @nodoc
class _$CityDashboardDataCopyWithImpl<$Res, $Val extends CityDashboardData>
    implements $CityDashboardDataCopyWith<$Res> {
  _$CityDashboardDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CityDashboardData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stats = null,
    Object? leaderboard = null,
    Object? achievements = null,
    Object? recentActivity = null,
    Object? availableCities = null,
  }) {
    return _then(
      _value.copyWith(
            stats: null == stats
                ? _value.stats
                : stats // ignore: cast_nullable_to_non_nullable
                      as CityStats,
            leaderboard: null == leaderboard
                ? _value.leaderboard
                : leaderboard // ignore: cast_nullable_to_non_nullable
                      as CityLeaderboard,
            achievements: null == achievements
                ? _value.achievements
                : achievements // ignore: cast_nullable_to_non_nullable
                      as List<CityAchievement>,
            recentActivity: null == recentActivity
                ? _value.recentActivity
                : recentActivity // ignore: cast_nullable_to_non_nullable
                      as List<CityActivity>,
            availableCities: null == availableCities
                ? _value.availableCities
                : availableCities // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }

  /// Create a copy of CityDashboardData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CityStatsCopyWith<$Res> get stats {
    return $CityStatsCopyWith<$Res>(_value.stats, (value) {
      return _then(_value.copyWith(stats: value) as $Val);
    });
  }

  /// Create a copy of CityDashboardData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CityLeaderboardCopyWith<$Res> get leaderboard {
    return $CityLeaderboardCopyWith<$Res>(_value.leaderboard, (value) {
      return _then(_value.copyWith(leaderboard: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CityDashboardDataImplCopyWith<$Res>
    implements $CityDashboardDataCopyWith<$Res> {
  factory _$$CityDashboardDataImplCopyWith(
    _$CityDashboardDataImpl value,
    $Res Function(_$CityDashboardDataImpl) then,
  ) = __$$CityDashboardDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    CityStats stats,
    CityLeaderboard leaderboard,
    List<CityAchievement> achievements,
    List<CityActivity> recentActivity,
    List<String> availableCities,
  });

  @override
  $CityStatsCopyWith<$Res> get stats;
  @override
  $CityLeaderboardCopyWith<$Res> get leaderboard;
}

/// @nodoc
class __$$CityDashboardDataImplCopyWithImpl<$Res>
    extends _$CityDashboardDataCopyWithImpl<$Res, _$CityDashboardDataImpl>
    implements _$$CityDashboardDataImplCopyWith<$Res> {
  __$$CityDashboardDataImplCopyWithImpl(
    _$CityDashboardDataImpl _value,
    $Res Function(_$CityDashboardDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CityDashboardData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stats = null,
    Object? leaderboard = null,
    Object? achievements = null,
    Object? recentActivity = null,
    Object? availableCities = null,
  }) {
    return _then(
      _$CityDashboardDataImpl(
        stats: null == stats
            ? _value.stats
            : stats // ignore: cast_nullable_to_non_nullable
                  as CityStats,
        leaderboard: null == leaderboard
            ? _value.leaderboard
            : leaderboard // ignore: cast_nullable_to_non_nullable
                  as CityLeaderboard,
        achievements: null == achievements
            ? _value._achievements
            : achievements // ignore: cast_nullable_to_non_nullable
                  as List<CityAchievement>,
        recentActivity: null == recentActivity
            ? _value._recentActivity
            : recentActivity // ignore: cast_nullable_to_non_nullable
                  as List<CityActivity>,
        availableCities: null == availableCities
            ? _value._availableCities
            : availableCities // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CityDashboardDataImpl implements _CityDashboardData {
  const _$CityDashboardDataImpl({
    required this.stats,
    required this.leaderboard,
    required final List<CityAchievement> achievements,
    required final List<CityActivity> recentActivity,
    final List<String> availableCities = const [],
  }) : _achievements = achievements,
       _recentActivity = recentActivity,
       _availableCities = availableCities;

  factory _$CityDashboardDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$CityDashboardDataImplFromJson(json);

  @override
  final CityStats stats;
  @override
  final CityLeaderboard leaderboard;
  final List<CityAchievement> _achievements;
  @override
  List<CityAchievement> get achievements {
    if (_achievements is EqualUnmodifiableListView) return _achievements;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_achievements);
  }

  final List<CityActivity> _recentActivity;
  @override
  List<CityActivity> get recentActivity {
    if (_recentActivity is EqualUnmodifiableListView) return _recentActivity;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentActivity);
  }

  final List<String> _availableCities;
  @override
  @JsonKey()
  List<String> get availableCities {
    if (_availableCities is EqualUnmodifiableListView) return _availableCities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_availableCities);
  }

  @override
  String toString() {
    return 'CityDashboardData(stats: $stats, leaderboard: $leaderboard, achievements: $achievements, recentActivity: $recentActivity, availableCities: $availableCities)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CityDashboardDataImpl &&
            (identical(other.stats, stats) || other.stats == stats) &&
            (identical(other.leaderboard, leaderboard) ||
                other.leaderboard == leaderboard) &&
            const DeepCollectionEquality().equals(
              other._achievements,
              _achievements,
            ) &&
            const DeepCollectionEquality().equals(
              other._recentActivity,
              _recentActivity,
            ) &&
            const DeepCollectionEquality().equals(
              other._availableCities,
              _availableCities,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    stats,
    leaderboard,
    const DeepCollectionEquality().hash(_achievements),
    const DeepCollectionEquality().hash(_recentActivity),
    const DeepCollectionEquality().hash(_availableCities),
  );

  /// Create a copy of CityDashboardData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CityDashboardDataImplCopyWith<_$CityDashboardDataImpl> get copyWith =>
      __$$CityDashboardDataImplCopyWithImpl<_$CityDashboardDataImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CityDashboardDataImplToJson(this);
  }
}

abstract class _CityDashboardData implements CityDashboardData {
  const factory _CityDashboardData({
    required final CityStats stats,
    required final CityLeaderboard leaderboard,
    required final List<CityAchievement> achievements,
    required final List<CityActivity> recentActivity,
    final List<String> availableCities,
  }) = _$CityDashboardDataImpl;

  factory _CityDashboardData.fromJson(Map<String, dynamic> json) =
      _$CityDashboardDataImpl.fromJson;

  @override
  CityStats get stats;
  @override
  CityLeaderboard get leaderboard;
  @override
  List<CityAchievement> get achievements;
  @override
  List<CityActivity> get recentActivity;
  @override
  List<String> get availableCities;

  /// Create a copy of CityDashboardData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CityDashboardDataImplCopyWith<_$CityDashboardDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
