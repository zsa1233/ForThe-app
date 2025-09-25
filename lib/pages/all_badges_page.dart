import 'package:flutter/material.dart';

class AllBadgesPage extends StatelessWidget {
  const AllBadgesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final badges = [
      BadgeData(
        icon: Icons.cleaning_services,
        name: 'First Cleanup',
        description: 'Complete your first cleanup activity',
        color: Colors.green,
        isUnlocked: true,
        unlockedDate: 'June 1, 2023',
      ),
      BadgeData(
        icon: Icons.fitness_center,
        name: '50 lbs Club',
        description: 'Collect 50 pounds of trash',
        color: Colors.blue,
        isUnlocked: true,
        unlockedDate: 'June 15, 2023',
      ),
      BadgeData(
        icon: Icons.local_fire_department,
        name: '7-Day Streak',
        description: 'Clean up for 7 consecutive days',
        color: Colors.orange,
        isUnlocked: true,
        unlockedDate: 'June 22, 2023',
      ),
      BadgeData(
        icon: Icons.favorite,
        name: 'Volunteer',
        description: 'Join a community cleanup event',
        color: Colors.red,
        isUnlocked: true,
        unlockedDate: 'June 8, 2023',
      ),
      BadgeData(
        icon: Icons.fitness_center,
        name: '100 lbs Club',
        description: 'Collect 100 pounds of trash',
        color: Colors.purple,
        isUnlocked: false,
        progress: '89/100 lbs',
      ),
      BadgeData(
        icon: Icons.shield,
        name: 'Plastic Fighter',
        description: 'Collect 50 plastic items',
        color: Colors.teal,
        isUnlocked: false,
        progress: '32/50 items',
      ),
      BadgeData(
        icon: Icons.water_drop,
        name: 'Water Guardian',
        description: 'Clean up 5 water bodies',
        color: Colors.cyan,
        isUnlocked: false,
        progress: '2/5 cleanups',
      ),
      BadgeData(
        icon: Icons.group,
        name: 'Team Leader',
        description: 'Lead 3 group cleanup events',
        color: Colors.indigo,
        isUnlocked: false,
        progress: '0/3 events',
      ),
      BadgeData(
        icon: Icons.eco,
        name: 'Eco Master',
        description: 'Reach level 10',
        color: Colors.green[700]!,
        isUnlocked: false,
        progress: 'Level 8/10',
      ),
      BadgeData(
        icon: Icons.star,
        name: 'All Star',
        description: 'Be in top 10 for 3 months',
        color: Colors.amber,
        isUnlocked: false,
        progress: '1/3 months',
      ),
      BadgeData(
        icon: Icons.calendar_month,
        name: '30-Day Warrior',
        description: 'Clean up for 30 consecutive days',
        color: Colors.deepPurple,
        isUnlocked: false,
        progress: '7/30 days',
      ),
      BadgeData(
        icon: Icons.recycling,
        name: 'Recycling Champion',
        description: 'Sort and recycle 100 items correctly',
        color: Colors.green[800]!,
        isUnlocked: false,
        progress: '45/100 items',
      ),
    ];

    final unlockedBadges = badges.where((b) => b.isUnlocked).toList();
    final lockedBadges = badges.where((b) => !b.isUnlocked).toList();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('All Badges'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: CustomScrollView(
        slivers: [
          // Stats Header
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatColumn('Total', '${badges.length}', Colors.blue),
                  _buildStatColumn(
                      'Earned', '${unlockedBadges.length}', Colors.green),
                  _buildStatColumn(
                      'Locked', '${lockedBadges.length}', Colors.grey),
                ],
              ),
            ),
          ),
          
          // Earned Badges Section
          if (unlockedBadges.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Text(
                  'Earned Badges',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildBadgeCard(
                    context,
                    unlockedBadges[index],
                  ),
                  childCount: unlockedBadges.length,
                ),
              ),
            ),
          ],
          
          // Locked Badges Section
          if (lockedBadges.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Text(
                  'Locked Badges',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildBadgeCard(
                    context,
                    lockedBadges[index],
                  ),
                  childCount: lockedBadges.length,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildBadgeCard(BuildContext context, BadgeData badge) {
    return GestureDetector(
      onTap: () {
        _showBadgeDetails(context, badge);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: badge.isUnlocked
              ? null
              : Border.all(color: Colors.grey[300]!, width: 2),
          boxShadow: badge.isUnlocked
              ? [
                  BoxShadow(
                    color: badge.color.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: badge.isUnlocked
                    ? badge.color.withOpacity(0.1)
                    : Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: Icon(
                badge.icon,
                color: badge.isUnlocked ? badge.color : Colors.grey[400],
                size: 36,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              badge.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: badge.isUnlocked ? Colors.black : Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            if (badge.isUnlocked)
              Text(
                badge.unlockedDate!,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              )
            else
              Text(
                badge.progress!,
                style: TextStyle(
                  fontSize: 12,
                  color: badge.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showBadgeDetails(BuildContext context, BadgeData badge) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: badge.isUnlocked
                    ? badge.color.withOpacity(0.1)
                    : Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: Icon(
                badge.icon,
                color: badge.isUnlocked ? badge.color : Colors.grey[400],
                size: 48,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              badge.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              badge.description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            if (badge.isUnlocked) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green[600],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Earned on ${badge.unlockedDate}',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: badge.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  badge.progress!,
                  style: TextStyle(
                    color: badge.color,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (badge.progress!.contains('/')) ...[
                LinearProgressIndicator(
                  value: _getProgressValue(badge.progress!),
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(badge.color),
                ),
              ],
            ],
            const SizedBox(height: 24),
            if (!badge.isUnlocked)
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: badge.color,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Keep Going!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  double _getProgressValue(String progress) {
    final parts = progress.split('/');
    if (parts.length == 2) {
      final current = int.tryParse(parts[0].replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      final total = int.tryParse(parts[1].replaceAll(RegExp(r'[^0-9]'), '')) ?? 1;
      return current / total;
    }
    return 0.0;
  }
}

class BadgeData {
  final IconData icon;
  final String name;
  final String description;
  final Color color;
  final bool isUnlocked;
  final String? unlockedDate;
  final String? progress;

  BadgeData({
    required this.icon,
    required this.name,
    required this.description,
    required this.color,
    required this.isUnlocked,
    this.unlockedDate,
    this.progress,
  });
}