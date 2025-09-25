// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city_dashboard_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$cityDashboardHash() => r'ed11ed64b98baba61ed55e8b5ad1a4d741ea863b';

/// See also [cityDashboard].
@ProviderFor(cityDashboard)
final cityDashboardProvider =
    AutoDisposeFutureProvider<CityDashboardData>.internal(
      cityDashboard,
      name: r'cityDashboardProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$cityDashboardHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CityDashboardRef = AutoDisposeFutureProviderRef<CityDashboardData>;
String _$availableCitiesHash() => r'3ff5f28b29e9038950e6553cef1f1c2ee594b7e8';

/// See also [availableCities].
@ProviderFor(availableCities)
final availableCitiesProvider =
    AutoDisposeFutureProvider<List<String>>.internal(
      availableCities,
      name: r'availableCitiesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$availableCitiesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AvailableCitiesRef = AutoDisposeFutureProviderRef<List<String>>;
String _$comingSoonCitiesHash() => r'1e921b05aed162b2660055f94e58c95c2cfcbb6a';

/// See also [comingSoonCities].
@ProviderFor(comingSoonCities)
final comingSoonCitiesProvider =
    AutoDisposeFutureProvider<List<String>>.internal(
      comingSoonCities,
      name: r'comingSoonCitiesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$comingSoonCitiesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ComingSoonCitiesRef = AutoDisposeFutureProviderRef<List<String>>;
String _$userCityStatsHash() => r'cec155a326b3d49f7945795195e6f3e73dfdfb66';

/// See also [userCityStats].
@ProviderFor(userCityStats)
final userCityStatsProvider = AutoDisposeFutureProvider<UserCityStats>.internal(
  userCityStats,
  name: r'userCityStatsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userCityStatsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserCityStatsRef = AutoDisposeFutureProviderRef<UserCityStats>;
String _$cityAchievementsHash() => r'3efb4ac3b05e243fc7ce517f8384c1facc5ef844';

/// See also [cityAchievements].
@ProviderFor(cityAchievements)
final cityAchievementsProvider =
    AutoDisposeFutureProvider<List<CityAchievement>>.internal(
      cityAchievements,
      name: r'cityAchievementsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$cityAchievementsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CityAchievementsRef =
    AutoDisposeFutureProviderRef<List<CityAchievement>>;
String _$recentActivityHash() => r'27956311a1f1844b5d4ae3325b829e40f80ec5fb';

/// See also [recentActivity].
@ProviderFor(recentActivity)
final recentActivityProvider =
    AutoDisposeFutureProvider<List<CityActivity>>.internal(
      recentActivity,
      name: r'recentActivityProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$recentActivityHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RecentActivityRef = AutoDisposeFutureProviderRef<List<CityActivity>>;
String _$selectedCityHash() => r'1fe1b2c0961091003dd56b5624f1f89640f6e82f';

/// See also [SelectedCity].
@ProviderFor(SelectedCity)
final selectedCityProvider =
    AutoDisposeNotifierProvider<SelectedCity, String>.internal(
      SelectedCity.new,
      name: r'selectedCityProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectedCityHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedCity = AutoDisposeNotifier<String>;
String _$cityLeaderboardNotifierHash() =>
    r'867e86c6818e84320e4905c6ce63849649ae60e7';

/// See also [CityLeaderboardNotifier].
@ProviderFor(CityLeaderboardNotifier)
final cityLeaderboardNotifierProvider =
    AutoDisposeAsyncNotifierProvider<
      CityLeaderboardNotifier,
      CityLeaderboard
    >.internal(
      CityLeaderboardNotifier.new,
      name: r'cityLeaderboardNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$cityLeaderboardNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CityLeaderboardNotifier = AutoDisposeAsyncNotifier<CityLeaderboard>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
