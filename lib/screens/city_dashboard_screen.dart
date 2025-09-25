import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/city_dashboard_models.dart';
import '../providers/city_dashboard_provider.dart';
import '../widgets/custom_circular_progress.dart';
import 'city_leaderboard_screen.dart';

class CityDashboardScreen extends ConsumerWidget {
  const CityDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(cityDashboardProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(cityDashboardProvider);
            await ref.read(cityDashboardProvider.future);
          },
          child: dashboardAsync.when(
            data: (data) => _buildDashboard(context, ref, data),
            loading: () => const Center(
              child: CircularProgressIndicator(color: Colors.green),
            ),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  SelectableText.rich(
                    TextSpan(
                      text: 'Error loading dashboard: $error',
                      style: const TextStyle(color: Colors.red),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => ref.invalidate(cityDashboardProvider),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, WidgetRef ref, CityDashboardData data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCityHeader(context, ref, data.stats),
          const SizedBox(height: 24),
          _buildStatsGrid(context, data.stats),
          const SizedBox(height: 24),
          _buildProgressSection(context, data.achievements),
          const SizedBox(height: 24),
          _buildLeaderboardPreview(context, ref, data.leaderboard),
          const SizedBox(height: 24),
          _buildRecentActivity(context, data.recentActivity),
        ],
      ),
    );
  }

  Widget _buildCityHeader(BuildContext context, WidgetRef ref, CityStats stats) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${stats.cityName}, ${stats.state}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Your Local Impact Hub',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _showCitySelector(context, ref),
                icon: const Icon(Icons.location_city),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.green.withOpacity(0.1),
                  foregroundColor: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Your Rank',
                  '#${stats.userRank.toInt()}',
                  'of ${stats.activeUsers} users',
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Your Impact',
                  '${stats.userContribution.toStringAsFixed(1)} lbs',
                  'collected locally',
                  Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, CityStats stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'City Impact',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
          children: [
            _buildStatCard(
              'Total Collected',
              '${(stats.totalPoundsCollected / 1000).toStringAsFixed(1)}K lbs',
              '${stats.totalCleanups} cleanups',
              Colors.green,
            ),
            _buildStatCard(
              'Active Users',
              '${(stats.activeUsers / 1000).toStringAsFixed(1)}K',
              'community members',
              Colors.blue,
            ),
            _buildStatCard(
              'Hotspots',
              '${stats.completedHotspots}/${stats.totalHotspots}',
              'completed',
              Colors.orange,
            ),
            _buildStatCard(
              'Top Contributors',
              stats.topContributors.length.toString(),
              'leading the way',
              Colors.purple,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressSection(BuildContext context, List<CityAchievement> achievements) {
    final incompleteAchievements = achievements
        .where((a) => !a.isCompleted && !a.isHidden)
        .take(3)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Progress',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: incompleteAchievements.map((achievement) {
                  final progress = achievement.currentValue / achievement.targetValue;
                  return AnimatedCircularProgress(
                    value: progress.clamp(0.0, 1.0),
                    size: 80,
                    color: _getAchievementColor(achievement.category),
                    label: achievement.name,
                    centerText: achievement.icon,
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _showAllAchievements(context, achievements),
                      icon: const Icon(Icons.emoji_events),
                      label: const Text('View All Achievements'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderboardPreview(BuildContext context, WidgetRef ref, CityLeaderboard leaderboard) {
    // TODO: SCALABILITY - Optimize for 100s of users
    // Current: Shows top 5 users from mock data
    // Future: 
    // 1. Show top 10-20 users initially
    // 2. Add "Load More" or infinite scroll in full leaderboard view
    // 3. Show user's rank if not in top list (e.g., "Your rank: #234")
    // 4. Consider virtual scrolling for performance
    // See LEADERBOARD_SCALABILITY_TODO.md for full implementation plan
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Local Leaderboard',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CityLeaderboardScreen(),
                  ),
                );
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: leaderboard.users.take(3).map((user) => 
              _buildLeaderboardItem(user, isPreview: true)
            ).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivity(BuildContext context, List<CityActivity> activities) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent City Activity',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: activities.take(5).map((activity) => 
              _buildActivityItem(activity)
            ).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, String subtitle, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getIconForStat(title),
                  color: color,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardItem(CityUser user, {bool isPreview = false}) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getRankColor(user.rank),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                user.rank.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey[300],
            child: Text(
              user.initials,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${user.poundsCollected.toStringAsFixed(1)} lbs • ${user.cleanupsCompleted} cleanups',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (!isPreview) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${user.points} pts',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (user.rankChange != 0)
                  Row(
                    children: [
                      Icon(
                        user.rankChange > 0 ? Icons.arrow_upward : Icons.arrow_downward,
                        size: 12,
                        color: user.rankChange > 0 ? Colors.green : Colors.red,
                      ),
                      Text(
                        user.rankChange.abs().toString(),
                        style: TextStyle(
                          fontSize: 12,
                          color: user.rankChange > 0 ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActivityItem(CityActivity activity) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                activity.icon ?? '🌱',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                    children: [
                      TextSpan(
                        text: activity.userName,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      TextSpan(text: ' ${activity.description}'),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatTimeAgo(activity.timestamp),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getAchievementColor(String category) {
    switch (category) {
      case 'collection':
        return Colors.green;
      case 'ranking':
        return Colors.purple;
      case 'cleanups':
        return Colors.blue;
      case 'milestone':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Color _getRankColor(int rank) {
    if (rank == 1) return Colors.amber;
    if (rank == 2) return Colors.grey[600]!;
    if (rank == 3) return Colors.brown[400]!;
    return Colors.green;
  }

  IconData _getIconForStat(String title) {
    switch (title) {
      case 'Total Collected':
        return Icons.fitness_center;
      case 'Active Users':
        return Icons.people;
      case 'Hotspots':
        return Icons.place;
      case 'Top Contributors':
        return Icons.star;
      case 'Your Rank':
        return Icons.leaderboard;
      case 'Your Impact':
        return Icons.eco;
      default:
        return Icons.analytics;
    }
  }

  String _formatTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  void _showCitySelector(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) => const CitySelector(),
    );
  }

  void _showAllAchievements(BuildContext context, List<CityAchievement> achievements) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AchievementsModal(achievements: achievements),
    );
  }
}

class CitySelector extends ConsumerWidget {
  const CitySelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final citiesAsync = ref.watch(availableCitiesProvider);
    final comingSoonAsync = ref.watch(comingSoonCitiesProvider);
    final selectedCity = ref.watch(selectedCityProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Select Your City',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          citiesAsync.when(
            data: (cities) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Available cities
                ...cities.map((city) => ListTile(
                  title: Text(city),
                  trailing: selectedCity == city 
                      ? const Icon(Icons.check, color: Colors.green)
                      : null,
                  onTap: () {
                    ref.read(selectedCityProvider.notifier).selectCity(city);
                    Navigator.pop(context);
                  },
                )),
                
                // Coming soon section
                comingSoonAsync.when(
                  data: (comingSoonCities) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (comingSoonCities.isNotEmpty) ...[
                        ...comingSoonCities.map((city) => ListTile(
                          title: Text(
                            city,
                            style: TextStyle(
                              color: Colors.grey[500],
                            ),
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Coming Soon',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.orange[700],
                              ),
                            ),
                          ),
                          onTap: () {
                            // Show coming soon message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('$city is coming soon! Stay tuned.'),
                                backgroundColor: Colors.orange,
                              ),
                            );
                          },
                        )),
                      ],
                    ],
                  ),
                  loading: () => const SizedBox.shrink(),
                  error: (error, stack) => const SizedBox.shrink(),
                ),
              ],
            ),
            loading: () => const CircularProgressIndicator(),
            error: (error, stack) => Text('Error: $error'),
          ),
        ],
      ),
    );
  }
}

class AchievementsModal extends StatelessWidget {
  final List<CityAchievement> achievements;

  const AchievementsModal({super.key, required this.achievements});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            'City Achievements',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: achievements.length,
              itemBuilder: (context, index) {
                final achievement = achievements[index];
                final progress = achievement.currentValue / achievement.targetValue;
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: achievement.isCompleted 
                                ? Colors.green.withOpacity(0.1)
                                : Colors.grey.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              achievement.icon,
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                achievement.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                achievement.description,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              if (!achievement.isCompleted) ...[
                                LinearProgressIndicator(
                                  value: progress.clamp(0.0, 1.0),
                                  backgroundColor: Colors.grey[300],
                                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${achievement.currentValue.toStringAsFixed(1)} / ${achievement.targetValue.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ] else ...[
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Completed ${achievement.completedAt != null ? _formatDate(achievement.completedAt!) : ''}',
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}