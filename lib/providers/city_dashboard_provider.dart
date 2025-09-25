import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/city_dashboard_models.dart';
import '../services/city_dashboard_service.dart';
import 'dart:developer' as developer;

part 'city_dashboard_provider.g.dart';

// Selected city provider
@riverpod
class SelectedCity extends _$SelectedCity {
  @override
  String build() {
    // Default to St. Louis, but this could be based on user location
    return 'St. Louis';
  }

  void selectCity(String cityName) {
    state = cityName;
    developer.log('Selected city changed to: $cityName');
  }
}

// City dashboard data provider
@riverpod
Future<CityDashboardData> cityDashboard(CityDashboardRef ref) async {
  final selectedCity = ref.watch(selectedCityProvider);
  final service = ref.read(cityDashboardServiceProvider);
  
  try {
    final data = await service.getCityDashboard(selectedCity);
    developer.log('Loaded dashboard for $selectedCity');
    return data;
  } catch (e) {
    developer.log('Error loading city dashboard: $e');
    rethrow;
  }
}

// City leaderboard provider with time period
@riverpod
class CityLeaderboardNotifier extends _$CityLeaderboardNotifier {
  @override
  Future<CityLeaderboard> build() async {
    final selectedCity = ref.watch(selectedCityProvider);
    final service = ref.read(cityDashboardServiceProvider);
    
    return await service.getCityLeaderboard(selectedCity, TimePeriod.weekly);
  }

  Future<void> loadLeaderboard(TimePeriod period) async {
    try {
      state = const AsyncValue.loading();
      
      final selectedCity = ref.read(selectedCityProvider);
      final service = ref.read(cityDashboardServiceProvider);
      
      final leaderboard = await service.getCityLeaderboard(selectedCity, period);
      state = AsyncValue.data(leaderboard);
      
      developer.log('Loaded leaderboard for $selectedCity - ${period.name}');
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      developer.log('Error loading leaderboard: $e');
    }
  }

  Future<void> refresh() async {
    final currentState = state;
    if (currentState is AsyncData<CityLeaderboard>) {
      final period = TimePeriod.values.firstWhere(
        (p) => p.name == currentState.value.period,
        orElse: () => TimePeriod.weekly,
      );
      await loadLeaderboard(period);
    }
  }
}

// Available cities provider
@riverpod
Future<List<String>> availableCities(AvailableCitiesRef ref) async {
  final service = ref.read(cityDashboardServiceProvider);
  return await service.getAvailableCities();
}

// Coming soon cities provider
@riverpod
Future<List<String>> comingSoonCities(ComingSoonCitiesRef ref) async {
  final service = ref.read(cityDashboardServiceProvider);
  return await service.getComingSoonCities();
}

// User stats provider (extracted from city dashboard)
@riverpod
Future<UserCityStats> userCityStats(UserCityStatsRef ref) async {
  final dashboardData = await ref.watch(cityDashboardProvider.future);
  
  return UserCityStats(
    rank: dashboardData.stats.userRank.toInt(),
    contribution: dashboardData.stats.userContribution,
    cityName: dashboardData.stats.cityName,
    totalUsers: dashboardData.stats.activeUsers,
  );
}

// City achievements provider
@riverpod
Future<List<CityAchievement>> cityAchievements(CityAchievementsRef ref) async {
  final dashboardData = await ref.watch(cityDashboardProvider.future);
  return dashboardData.achievements;
}

// Recent activity provider
@riverpod
Future<List<CityActivity>> recentActivity(RecentActivityRef ref) async {
  final dashboardData = await ref.watch(cityDashboardProvider.future);
  return dashboardData.recentActivity;
}

// Helper class for user stats
class UserCityStats {
  final int rank;
  final double contribution;
  final String cityName;
  final int totalUsers;

  const UserCityStats({
    required this.rank,
    required this.contribution,
    required this.cityName,
    required this.totalUsers,
  });

  double get percentile => (1 - (rank / totalUsers)) * 100;
}