import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/city_dashboard_models.dart';
import '../providers/city_dashboard_provider.dart';

class CityLeaderboardScreen extends ConsumerStatefulWidget {
  const CityLeaderboardScreen({super.key});

  @override
  ConsumerState<CityLeaderboardScreen> createState() => _CityLeaderboardScreenState();
}

class _CityLeaderboardScreenState extends ConsumerState<CityLeaderboardScreen> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TimePeriod _selectedPeriod = TimePeriod.weekly;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedCity = ref.watch(selectedCityProvider);
    final leaderboardAsync = ref.watch(cityLeaderboardNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('$selectedCity Leaderboard'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          PopupMenuButton<TimePeriod>(
            icon: const Icon(Icons.filter_list),
            onSelected: (period) {
              setState(() {
                _selectedPeriod = period;
              });
              ref.read(cityLeaderboardNotifierProvider.notifier)
                  .loadLeaderboard(period);
            },
            itemBuilder: (context) => TimePeriod.values.map((period) => 
              PopupMenuItem(
                value: period,
                child: Row(
                  children: [
                    if (_selectedPeriod == period)
                      const Icon(Icons.check, color: Colors.green, size: 16),
                    if (_selectedPeriod == period)
                      const SizedBox(width: 8),
                    Text(period.displayName),
                  ],
                ),
              ),
            ).toList(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.green,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.green,
          tabs: const [
            Tab(text: 'All Users'),
            Tab(text: 'Friends'), // Future implementation
            Tab(text: 'Nearby'), // Future implementation
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(cityLeaderboardNotifierProvider.notifier).refresh();
        },
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildAllUsersTab(leaderboardAsync),
            _buildFriendsTab(),
            _buildNearbyTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildAllUsersTab(AsyncValue<CityLeaderboard> leaderboardAsync) {
    return leaderboardAsync.when(
      data: (leaderboard) => Column(
        children: [
          _buildTopThree(leaderboard.users.take(3).toList()),
          Expanded(
            child: _buildLeaderboardList(
              leaderboard.users.skip(3).toList(),
              startingRank: 4,
            ),
          ),
        ],
      ),
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
                text: 'Error loading leaderboard: $error',
                style: const TextStyle(color: Colors.red),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(cityLeaderboardNotifierProvider.notifier).refresh(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopThree(List<CityUser> topUsers) {
    if (topUsers.length < 3) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        children: [
          Text(
            _selectedPeriod.displayName,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (topUsers.length > 1) _buildPodiumUser(topUsers[1], 2),
              const SizedBox(width: 16),
              _buildPodiumUser(topUsers[0], 1, isFirst: true),
              const SizedBox(width: 16),
              if (topUsers.length > 2) _buildPodiumUser(topUsers[2], 3),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumUser(CityUser user, int position, {bool isFirst = false}) {
    final height = isFirst ? 120.0 : 100.0;
    final podiumHeight = isFirst ? 80.0 : 60.0;

    return Column(
      children: [
        if (isFirst)
          const Icon(Icons.emoji_events, color: Colors.amber, size: 32),
        Container(
          width: height,
          height: height,
          decoration: BoxDecoration(
            color: _getPodiumColor(position),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: isFirst ? 25 : 20,
                backgroundColor: Colors.white,
                child: Text(
                  user.initials,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                position.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: height,
          height: podiumHeight,
          decoration: BoxDecoration(
            color: _getPodiumColor(position).withOpacity(0.3),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: height,
          child: Column(
            children: [
              Text(
                user.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '${user.poundsCollected.toStringAsFixed(0)} lbs',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderboardList(List<CityUser> users, {int startingRank = 1}) {
    if (users.isEmpty) {
      return const Center(
        child: Text(
          'No more users to display',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: users.length + 1, // +1 for "Load More" button
      itemBuilder: (context, index) {
        if (index == users.length) {
          return _buildLoadMoreButton();
        }

        final user = users[index];
        final actualRank = startingRank + index;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: _buildLeaderboardItem(user.copyWith(rank: actualRank)),
        );
      },
    );
  }

  Widget _buildLeaderboardItem(CityUser user) {
    final isCurrentUser = user.name == 'John Doe'; // Mock current user check

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: isCurrentUser 
            ? Border.all(color: Colors.green, width: 2)
            : null,
      ),
      child: Padding(
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
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.grey[300],
              child: Text(
                user.initials,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          user.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: isCurrentUser ? Colors.green : Colors.black87,
                          ),
                        ),
                      ),
                      if (isCurrentUser)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'YOU',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${user.poundsCollected.toStringAsFixed(1)} lbs collected • ${user.cleanupsCompleted} cleanups',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                  if (user.badges.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 4,
                      children: user.badges.take(3).map((badge) => 
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _getBadgeDisplayName(badge),
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ).toList(),
                    ),
                  ],
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${user.points} pts',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                if (user.rankChange != 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: user.rankChange > 0 
                          ? Colors.green.withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          user.rankChange > 0 
                              ? Icons.arrow_upward 
                              : Icons.arrow_downward,
                          size: 12,
                          color: user.rankChange > 0 ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          user.rankChange.abs().toString(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: user.rankChange > 0 ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadMoreButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: OutlinedButton(
        onPressed: () {
          // Simulate loading more users
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Loading more users...'),
              duration: Duration(seconds: 1),
            ),
          );
        },
        child: const Text('Load More'),
      ),
    );
  }

  Widget _buildFriendsTab() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Friends Leaderboard',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Coming Soon!',
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 16),
          Text(
            'Connect with friends to see how\nyou stack up against each other.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildNearbyTab() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_on, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Nearby Users',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Coming Soon!',
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 16),
          Text(
            'See how you compare to users\nin your immediate area.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Color _getPodiumColor(int position) {
    switch (position) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey[600]!;
      case 3:
        return Colors.brown[400]!;
      default:
        return Colors.green;
    }
  }

  Color _getRankColor(int rank) {
    if (rank <= 3) return _getPodiumColor(rank);
    if (rank <= 10) return Colors.green;
    if (rank <= 50) return Colors.blue;
    return Colors.grey;
  }

  String _getBadgeDisplayName(String badge) {
    final badgeMap = {
      'eco_warrior': 'Eco Warrior',
      'park_protector': 'Park Protector',
      'beach_cleaner': 'Beach Cleaner',
      'consistent': 'Consistent',
      'trail_maintainer': 'Trail Maintainer',
      'volunteer': 'Volunteer',
      'newcomer': 'Newcomer',
    };
    return badgeMap[badge] ?? badge.toUpperCase();
  }
}