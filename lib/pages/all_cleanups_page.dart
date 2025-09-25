import 'package:flutter/material.dart';

class AllCleanupsPage extends StatelessWidget {
  const AllCleanupsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cleanups = [
      CleanupData(
        location: 'Central Park',
        date: DateTime.now().subtract(const Duration(days: 1)),
        weight: 5,
        duration: const Duration(hours: 1, minutes: 30),
        itemsCollected: 23,
        type: 'Solo',
      ),
      CleanupData(
        location: 'Beach Cleanup',
        date: DateTime.now().subtract(const Duration(days: 3)),
        weight: 12,
        duration: const Duration(hours: 2, minutes: 15),
        itemsCollected: 47,
        type: 'Group',
        participants: 8,
      ),
      CleanupData(
        location: 'Trail Maintenance',
        date: DateTime.now().subtract(const Duration(days: 7)),
        weight: 8,
        duration: const Duration(hours: 1, minutes: 45),
        itemsCollected: 31,
        type: 'Solo',
      ),
      CleanupData(
        location: 'Downtown Streets',
        date: DateTime.now().subtract(const Duration(days: 10)),
        weight: 6,
        duration: const Duration(hours: 1),
        itemsCollected: 19,
        type: 'Solo',
      ),
      CleanupData(
        location: 'River Bank Cleanup',
        date: DateTime.now().subtract(const Duration(days: 14)),
        weight: 15,
        duration: const Duration(hours: 3),
        itemsCollected: 62,
        type: 'Group',
        participants: 12,
      ),
      CleanupData(
        location: 'Neighborhood Park',
        date: DateTime.now().subtract(const Duration(days: 21)),
        weight: 4,
        duration: const Duration(minutes: 45),
        itemsCollected: 15,
        type: 'Solo',
      ),
      CleanupData(
        location: 'Forest Trail',
        date: DateTime.now().subtract(const Duration(days: 28)),
        weight: 9,
        duration: const Duration(hours: 2),
        itemsCollected: 38,
        type: 'Solo',
      ),
    ];

    // Calculate totals
    final totalWeight = cleanups.fold<double>(
        0, (sum, cleanup) => sum + cleanup.weight);
    final totalItems = cleanups.fold<int>(
        0, (sum, cleanup) => sum + cleanup.itemsCollected);
    final totalDuration = cleanups.fold<Duration>(
        Duration.zero, (sum, cleanup) => sum + cleanup.duration);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Cleanup History'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterOptions(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary Stats
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatColumn(
                      'Total Cleanups',
                      cleanups.length.toString(),
                      Icons.cleaning_services,
                      Colors.green,
                    ),
                    _buildStatColumn(
                      'Total Weight',
                      '${totalWeight.toStringAsFixed(0)} lbs',
                      Icons.fitness_center,
                      Colors.blue,
                    ),
                    _buildStatColumn(
                      'Items Collected',
                      totalItems.toString(),
                      Icons.recycling,
                      Colors.orange,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.timer, color: Colors.grey[600], size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Total Time: ${_formatDuration(totalDuration)}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Cleanup List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cleanups.length,
              itemBuilder: (context, index) {
                final cleanup = cleanups[index];
                return _buildCleanupCard(context, cleanup);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildCleanupCard(BuildContext context, CleanupData cleanup) {
    return GestureDetector(
      onTap: () {
        _showCleanupDetails(context, cleanup);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
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
                        cleanup.location,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDate(cleanup.date),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: cleanup.type == 'Group'
                        ? Colors.purple[50]
                        : Colors.blue[50],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        cleanup.type == 'Group' ? Icons.group : Icons.person,
                        size: 16,
                        color: cleanup.type == 'Group'
                            ? Colors.purple
                            : Colors.blue,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        cleanup.type,
                        style: TextStyle(
                          color: cleanup.type == 'Group'
                              ? Colors.purple
                              : Colors.blue,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildCleanupStat(
                  Icons.fitness_center,
                  '${cleanup.weight} lbs',
                  Colors.green,
                ),
                const SizedBox(width: 16),
                _buildCleanupStat(
                  Icons.timer,
                  _formatDuration(cleanup.duration),
                  Colors.orange,
                ),
                const SizedBox(width: 16),
                _buildCleanupStat(
                  Icons.recycling,
                  '${cleanup.itemsCollected} items',
                  Colors.blue,
                ),
                if (cleanup.participants != null) ...[
                  const SizedBox(width: 16),
                  _buildCleanupStat(
                    Icons.people,
                    '${cleanup.participants}',
                    Colors.purple,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCleanupStat(IconData icon, String value, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '$difference days ago';
    } else if (difference < 30) {
      final weeks = (difference / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else {
      final months = (difference / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    }
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  void _showCleanupDetails(BuildContext context, CleanupData cleanup) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Cleanup Details',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildDetailRow('Location', cleanup.location),
            _buildDetailRow('Date', _formatDate(cleanup.date)),
            _buildDetailRow('Type', cleanup.type),
            if (cleanup.participants != null)
              _buildDetailRow('Participants', '${cleanup.participants} people'),
            _buildDetailRow('Duration', _formatDuration(cleanup.duration)),
            _buildDetailRow('Weight Collected', '${cleanup.weight} lbs'),
            _buildDetailRow('Items Collected', '${cleanup.itemsCollected} items'),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      // TODO: Implement share functionality
                    },
                    icon: const Icon(Icons.share),
                    label: const Text('Share'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      // TODO: Navigate to view on map
                    },
                    icon: const Icon(Icons.map, color: Colors.white),
                    label: const Text(
                      'View on Map',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filter Cleanups',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Last 7 days'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Last 30 days'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('All time'),
              onTap: () => Navigator.pop(context),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Solo cleanups only'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text('Group cleanups only'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

class CleanupData {
  final String location;
  final DateTime date;
  final double weight;
  final Duration duration;
  final int itemsCollected;
  final String type;
  final int? participants;

  CleanupData({
    required this.location,
    required this.date,
    required this.weight,
    required this.duration,
    required this.itemsCollected,
    required this.type,
    this.participants,
  });
}