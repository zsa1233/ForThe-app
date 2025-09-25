import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cleanup_models.dart';
import '../screens/cleanup_flow_enhanced.dart';
import '../screens/cleanup_progress_screen.dart';
import '../providers/cleanup_session_provider.dart';
import '../services/local_storage_service.dart';

/// Demo screen to showcase the cleanup flow features
class CleanupDemoScreen extends ConsumerStatefulWidget {
  const CleanupDemoScreen({super.key});

  @override
  ConsumerState<CleanupDemoScreen> createState() => _CleanupDemoScreenState();
}

class _CleanupDemoScreenState extends ConsumerState<CleanupDemoScreen> {
  List<CleanupSession> savedSessions = [];
  
  @override
  void initState() {
    super.initState();
    _loadSavedSessions();
  }

  Future<void> _loadSavedSessions() async {
    final localStorage = ref.read(localStorageServiceProvider);
    final sessions = await localStorage.loadCleanupSessions();
    setState(() {
      savedSessions = sessions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cleanup Flow Demo'),
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showInfoDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Features overview card
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.eco, color: Colors.green.shade600, size: 28),
                        const SizedBox(width: 8),
                        const Text(
                          'Enhanced Cleanup Flow',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Complete implementation with the following features:',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    ..._buildFeatureList(),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Start new cleanup section
            const Text(
              'Start New Cleanup',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            
            // Quick start options
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildStartOption(
                      'Start at Current Location',
                      'Begin cleanup without hotspot verification',
                      Icons.location_on,
                      Colors.blue,
                      () => _startCleanup(null, null),
                    ),
                    const SizedBox(height: 12),
                    _buildStartOption(
                      'Start with Mock Hotspot',
                      'Test location verification feature',
                      Icons.place,
                      Colors.orange,
                      () => _startCleanup(
                        'demo-hotspot-123',
                        const CleanupLocation(
                          latitude: 37.7749, // San Francisco coordinates
                          longitude: -122.4194,
                          name: 'Demo Hotspot - Golden Gate Park',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Saved sessions section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Saved Sessions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: _loadSavedSessions,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            savedSessions.isEmpty
                ? Card(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'No saved cleanup sessions yet',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Start your first cleanup to see it here',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Column(
                    children: savedSessions
                        .map((session) => _buildSessionCard(session))
                        .toList(),
                  ),
            
            const SizedBox(height: 24),
            
            // Demo controls
            const Text(
              'Demo Controls',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _clearAllData,
                            icon: const Icon(Icons.clear_all, color: Colors.red),
                            label: const Text('Clear All Data'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _showStorageStats,
                            icon: const Icon(Icons.storage),
                            label: const Text('Storage Stats'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFeatureList() {
    final features = [
      '📸 Camera integration with before/after photos',
      '📍 Location verification (within 100m of hotspot)',
      '⏱️ Live cleanup timer with pause/resume',
      '⚖️ Form validation for pounds collected',
      '🗂️ Trash type categorization',
      '💾 Offline support with local storage',
      '📤 Smart submission with visual feedback',
      '🎯 Real-time progress tracking',
    ];

    return features.map((feature) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              feature,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    )).toList();
  }

  Widget _buildStartOption(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionCard(CleanupSession session) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(session.status).withOpacity(0.2),
          child: Icon(
            _getStatusIcon(session.status),
            color: _getStatusColor(session.status),
          ),
        ),
        title: Text(
          '${session.type.displayName} Cleanup',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${session.poundsCollected.toStringAsFixed(1)} lbs'),
            Text(
              session.startTime.toString().split(' ')[0],
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        trailing: Chip(
          label: Text(
            session.status.name.toUpperCase(),
            style: const TextStyle(fontSize: 10),
          ),
          backgroundColor: _getStatusColor(session.status).withOpacity(0.2),
        ),
        onTap: () => _showSessionDetails(session),
      ),
    );
  }

  Color _getStatusColor(CleanupStatus status) {
    switch (status) {
      case CleanupStatus.inProgress:
        return Colors.orange;
      case CleanupStatus.completed:
        return Colors.blue;
      case CleanupStatus.submitted:
        return Colors.green;
      case CleanupStatus.failed:
        return Colors.red;
    }
  }

  IconData _getStatusIcon(CleanupStatus status) {
    switch (status) {
      case CleanupStatus.inProgress:
        return Icons.pending;
      case CleanupStatus.completed:
        return Icons.check_circle_outline;
      case CleanupStatus.submitted:
        return Icons.cloud_done;
      case CleanupStatus.failed:
        return Icons.error_outline;
    }
  }

  void _startCleanup(String? hotspotId, CleanupLocation? hotspotLocation) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EnhancedCleanupStartScreen(
          hotspotId: hotspotId,
          hotspotLocation: hotspotLocation,
        ),
      ),
    ).then((_) => _loadSavedSessions()); // Refresh when returning
  }

  void _showSessionDetails(CleanupSession session) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${session.type.displayName} Cleanup'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Status', session.status.name.toUpperCase()),
            _buildDetailRow('Pounds', '${session.poundsCollected} lbs'),
            _buildDetailRow('Duration', session.duration.toString()),
            _buildDetailRow('Trash Types', 
                session.trashTypes.map((t) => t.displayName).join(', ')),
            if (session.comments != null)
              _buildDetailRow('Comments', session.comments!),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          if (session.status == CleanupStatus.completed)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _resumeSession(session);
              },
              child: const Text('Resume'),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _resumeSession(CleanupSession session) {
    ref.read(cleanupSessionNotifierProvider.notifier)
        .loadCleanupSession(session.id);
    
    // Navigate to appropriate screen based on session state
    // This is simplified - in a real app you'd check what step to resume
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EnhancedCleanupProgressScreen(),
      ),
    );
  }

  Future<void> _clearAllData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'This will delete all saved cleanup sessions. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final localStorage = ref.read(localStorageServiceProvider);
      await localStorage.clearAllData();
      await _loadSavedSessions();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All data cleared'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  Future<void> _showStorageStats() async {
    final localStorage = ref.read(localStorageServiceProvider);
    final stats = await localStorage.getStorageStats();
    
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Storage Statistics'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildStatRow('Total Sessions', stats['totalSessions']?.toString() ?? '0'),
              _buildStatRow('Pending Uploads', stats['pendingUploads']?.toString() ?? '0'),
              _buildStatRow('Completed', stats['completedSessions']?.toString() ?? '0'),
              _buildStatRow('Submitted', stats['submittedSessions']?.toString() ?? '0'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cleanup Flow Demo'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'This demo showcases a complete cleanup flow implementation with:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 12),
              Text(
                '• Multi-step UI flow (6 steps)\n'
                '• Camera integration\n'
                '• Location verification\n'
                '• Form validation\n'
                '• Offline storage\n'
                '• Timer functionality\n'
                '• Visual feedback\n'
                '• Image compression',
              ),
              SizedBox(height: 12),
              Text(
                'Try starting a cleanup to experience the full flow!',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}