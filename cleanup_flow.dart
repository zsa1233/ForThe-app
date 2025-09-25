import 'package:flutter/material.dart';

/// CleanupStartScreen - First screen in the cleanup flow
class CleanupStartScreen extends StatelessWidget {
  final String? hotspotId;
  
  const CleanupStartScreen({super.key, this.hotspotId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Start Cleanup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Location Details',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            // Location card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hotspot ID: ${hotspotId ?? "New Location"}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Current Location'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Options
            const Text(
              'Cleanup Type',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            
            // Cleanup type options
            Wrap(
              spacing: 8,
              children: [
                _buildChip('Beach', Icons.beach_access),
                _buildChip('Park', Icons.park),
                _buildChip('Trail', Icons.hiking),
                _buildChip('Street', Icons.add_road),
                _buildChip('Other', Icons.more_horiz),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Estimated time
            const Text(
              'Estimated Time',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            
            // Time options
            Wrap(
              spacing: 8,
              children: [
                _buildChip('15 min', Icons.timer),
                _buildChip('30 min', Icons.timer),
                _buildChip('1 hour', Icons.timer),
                _buildChip('2+ hours', Icons.timer),
              ],
            ),
            
            const Spacer(),
            
            // Start button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => const CleanupCameraScreen(step: 'before'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Start Cleanup'),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildChip(String label, IconData icon) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(label),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }
}

/// CleanupCameraScreen - For taking before/after photos
class CleanupCameraScreen extends StatelessWidget {
  final String step;
  final String? cleanupId;
  
  const CleanupCameraScreen({
    super.key, 
    required this.step,
    this.cleanupId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${step.capitalize()} Photo'),
      ),
      body: Column(
        children: [
          // Camera preview placeholder
          Expanded(
            child: Container(
              color: Colors.black,
              child: Center(
                child: Icon(
                  Icons.camera_alt,
                  size: 100,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ),
          ),
          
          // Camera controls
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  color: Colors.white,
                ),
                FloatingActionButton(
                  onPressed: () {
                    // In a real app, this would capture a photo
                    if (step == 'before') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CleanupProgressScreen(cleanupId: 'new-cleanup'),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CleanupSubmissionScreen(cleanupId: 'new-cleanup'),
                        ),
                      );
                    }
                  },
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.camera, color: Colors.black),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.flip_camera_ios),
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// CleanupProgressScreen - For tracking cleanup progress
class CleanupProgressScreen extends StatefulWidget {
  final String? cleanupId;
  
  const CleanupProgressScreen({super.key, this.cleanupId});

  @override
  State<CleanupProgressScreen> createState() => _CleanupProgressScreenState();
}

class _CleanupProgressScreenState extends State<CleanupProgressScreen> {
  int lbsCollected = 0;
  final List<String> _trashTypes = ['Plastic', 'Paper', 'Glass', 'Metal', 'Other'];
  final Map<String, bool> _selectedTypes = {
    'Plastic': false, 
    'Paper': false, 
    'Glass': false, 
    'Metal': false,
    'Other': false
  };
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cleanup Progress'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timer section
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.timer, size: 24),
                SizedBox(width: 8),
                Text(
                  '00:15:32',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 32),
            
            // Pounds collected
            const Text(
              'Pounds Collected',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    if (lbsCollected > 0) {
                      setState(() {
                        lbsCollected--;
                      });
                    }
                  },
                  icon: const Icon(Icons.remove_circle),
                  color: Colors.red,
                ),
                Expanded(
                  child: Text(
                    '$lbsCollected lbs',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      lbsCollected++;
                    });
                  },
                  icon: const Icon(Icons.add_circle),
                  color: Colors.green,
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Trash types
            const Text(
              'Trash Types',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            
            Wrap(
              spacing: 8,
              children: _trashTypes.map((type) => FilterChip(
                label: Text(type),
                selected: _selectedTypes[type]!,
                onSelected: (selected) {
                  setState(() {
                    _selectedTypes[type] = selected;
                  });
                },
              )).toList(),
            ),
            
            const Spacer(),
            
            // Finish button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CleanupCameraScreen(
                      step: 'after',
                      cleanupId: 'new-cleanup',
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Take After Photo'),
            ),
          ],
        ),
      ),
    );
  }
}

/// CleanupSubmissionScreen - Final submission form
class CleanupSubmissionScreen extends StatelessWidget {
  final String? cleanupId;
  
  const CleanupSubmissionScreen({super.key, this.cleanupId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Cleanup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Before/After photos
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(child: Text('Before')),
                      ),
                      const SizedBox(height: 4),
                      const Text('Before', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(child: Text('After')),
                      ),
                      const SizedBox(height: 4),
                      const Text('After', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Summary
            const Text(
              'Cleanup Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildSummaryRow('Duration', '15 min'),
                    const Divider(),
                    _buildSummaryRow('Weight Collected', '5 lbs'),
                    const Divider(),
                    _buildSummaryRow('Location Type', 'Park'),
                    const Divider(),
                    _buildSummaryRow('Trash Types', 'Plastic, Paper'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Comments section
            const Text(
              'Comments',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Share details about your cleanup...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            
            const Spacer(),
            
            // Submit button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CleanupSuccessScreen(
                      cleanupId: 'new-cleanup',
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Submit Cleanup'),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value),
        ],
      ),
    );
  }
}

/// CleanupSuccessScreen - Confirmation screen with rewards
class CleanupSuccessScreen extends StatelessWidget {
  final String? cleanupId;
  
  const CleanupSuccessScreen({super.key, this.cleanupId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Success'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Success icon
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 80,
              ),
            ),
            const SizedBox(height: 24),
            
            // Success message
            const Text(
              'Cleanup Submitted!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            const Text(
              'Thank you for making a difference!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            
            // Rewards earned
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Rewards Earned',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              '+25',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            Text('points'),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              '5',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            Text('lbs'),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(Icons.emoji_events, color: Colors.amber),
                            Text('Badge'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const Spacer(),
            
            // Done button
            ElevatedButton(
              onPressed: () {
                // Return to home screen
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Done'),
            ),
            const SizedBox(height: 16),
            
            // Share button
            OutlinedButton.icon(
              onPressed: () {
                // Would open share dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sharing not implemented in demo')),
                );
              },
              icon: const Icon(Icons.share),
              label: const Text('Share Your Impact'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper extension
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}