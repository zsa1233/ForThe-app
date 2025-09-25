import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cleanup_models.dart';
import '../services/location_service.dart';
import '../services/camera_service.dart';
import '../services/cleanup_timer_service.dart';
import '../providers/cleanup_session_provider.dart';
import 'cleanup_progress_screen.dart';
import 'cleanup_submission_screen.dart';
import 'dart:io';

/// Enhanced CleanupStartScreen with location verification
class EnhancedCleanupStartScreen extends ConsumerStatefulWidget {
  final String? hotspotId;
  final CleanupLocation? hotspotLocation;
  
  const EnhancedCleanupStartScreen({
    super.key, 
    this.hotspotId,
    this.hotspotLocation,
  });

  @override
  ConsumerState<EnhancedCleanupStartScreen> createState() => 
      _EnhancedCleanupStartScreenState();
}

class _EnhancedCleanupStartScreenState 
    extends ConsumerState<EnhancedCleanupStartScreen> {
  CleanupType? selectedType;
  String selectedDuration = '15 min';
  bool isLocationVerified = false;
  String? locationError;

  @override
  void initState() {
    super.initState();
    if (widget.hotspotLocation != null) {
      _verifyLocation();
    }
  }

  Future<void> _verifyLocation() async {
    if (widget.hotspotLocation == null) return;
    
    final locationService = ref.read(locationServiceProvider);
    final result = await locationService.verifyUserAtHotspot(
      hotspotLocation: widget.hotspotLocation!,
    );
    
    setState(() {
      isLocationVerified = result.isValid;
      locationError = result.errorMessage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Start Cleanup'),
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Location verification section
            if (widget.hotspotLocation != null) ...[
              Card(
                color: isLocationVerified ? Colors.green.shade50 : Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            isLocationVerified 
                                ? Icons.location_on 
                                : Icons.location_off,
                            color: isLocationVerified 
                                ? Colors.green 
                                : Colors.red,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isLocationVerified 
                                ? 'Location Verified' 
                                : 'Location Check Failed',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isLocationVerified 
                                  ? Colors.green.shade700 
                                  : Colors.red.shade700,
                            ),
                          ),
                        ],
                      ),
                      if (locationError != null) ...[
                        const SizedBox(height: 8),
                        SelectableText.rich(
                          TextSpan(
                            text: locationError,
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                        ),
                      ],
                      if (!isLocationVerified) ...[
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: _verifyLocation,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry Location Check'),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Hotspot info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hotspot ID: ${widget.hotspotId ?? "New Location"}',
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
            
            // Cleanup type selection
            const Text(
              'Cleanup Type',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: CleanupType.values.map((type) => 
                _buildTypeChip(type)).toList(),
            ),
            
            const SizedBox(height: 24),
            
            // Estimated time
            const Text(
              'Estimated Time',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['15 min', '30 min', '1 hour', '2+ hours']
                  .map((duration) => _buildDurationChip(duration)).toList(),
            ),
            
            const Spacer(),
            
            // Start button
            ElevatedButton(
              onPressed: _canStartCleanup() ? _startCleanup : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                disabledBackgroundColor: Colors.grey.shade300,
              ),
              child: const Text('Start Cleanup'),
            ),
            
            if (!_canStartCleanup()) ...[
              const SizedBox(height: 8),
              SelectableText.rich(
                TextSpan(
                  text: _getStartButtonError(),
                  style: const TextStyle(color: Colors.red),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTypeChip(CleanupType type) {
    return FilterChip(
      label: Text('${type.icon} ${type.displayName}'),
      selected: selectedType == type,
      onSelected: (selected) {
        setState(() {
          selectedType = selected ? type : null;
        });
      },
    );
  }

  Widget _buildDurationChip(String duration) {
    return FilterChip(
      label: Text(duration),
      selected: selectedDuration == duration,
      onSelected: (selected) {
        setState(() {
          selectedDuration = duration;
        });
      },
    );
  }

  bool _canStartCleanup() {
    return selectedType != null && 
           (widget.hotspotLocation == null || isLocationVerified);
  }

  String _getStartButtonError() {
    if (selectedType == null) {
      return 'Please select a cleanup type';
    }
    if (widget.hotspotLocation != null && !isLocationVerified) {
      return 'Location verification required to start cleanup';
    }
    return '';
  }

  Future<void> _startCleanup() async {
    if (!_canStartCleanup()) return;

    try {
      await ref.read(cleanupSessionNotifierProvider.notifier)
          .startCleanupSession(
        hotspotId: widget.hotspotId,
        type: selectedType!,
        estimatedDuration: selectedDuration,
      );

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const EnhancedCleanupCameraScreen(
              step: CleanupCameraStep.before,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: SelectableText.rich(
              TextSpan(
                text: 'Failed to start cleanup: $e',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

enum CleanupCameraStep { before, after }

/// Enhanced camera screen with proper integration
class EnhancedCleanupCameraScreen extends ConsumerWidget {
  final CleanupCameraStep step;
  
  const EnhancedCleanupCameraScreen({
    super.key,
    required this.step,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${_getStepName()} Photo'),
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Instructions
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: Text(
              _getInstructions(),
              style: TextStyle(
                color: Colors.blue.shade700,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          // Camera preview placeholder
          Expanded(
            child: Container(
              color: Colors.black,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt,
                      size: 100,
                      color: Colors.white.withOpacity(0.7),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Tap the camera button to capture',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 16,
                      ),
                    ),
                  ],
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
                  iconSize: 30,
                ),
                FloatingActionButton(
                  onPressed: () => _capturePhoto(context, ref),
                  backgroundColor: Colors.white,
                  heroTag: 'camera_${step.name}',
                  child: const Icon(Icons.camera, color: Colors.black, size: 30),
                ),
                IconButton(
                  onPressed: () {
                    // Gallery option
                    _showImageSourceDialog(context, ref);
                  },
                  icon: const Icon(Icons.photo_library),
                  color: Colors.white,
                  iconSize: 30,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getStepName() {
    return step == CleanupCameraStep.before ? 'Before' : 'After';
  }

  String _getInstructions() {
    return step == CleanupCameraStep.before
        ? 'Take a photo of the area before cleanup. Include the trash and surrounding area.'
        : 'Now take a picture of the same area where you cleaned trash';
  }

  Future<void> _capturePhoto(BuildContext context, WidgetRef ref) async {
    try {
      if (step == CleanupCameraStep.before) {
        await ref.read(cleanupSessionNotifierProvider.notifier)
            .captureBeforePhoto();
      } else {
        await ref.read(cleanupSessionNotifierProvider.notifier)
            .captureAfterPhoto();
      }

      if (context.mounted) {
        if (step == CleanupCameraStep.before) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const EnhancedCleanupProgressScreen(),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const EnhancedCleanupSubmissionScreen(),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: SelectableText.rich(
              TextSpan(
                text: 'Failed to capture photo: $e',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showImageSourceDialog(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _capturePhoto(context, ref);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickFromGallery(context, ref);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickFromGallery(BuildContext context, WidgetRef ref) async {
    // Implementation for picking from gallery would go here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Gallery picker not implemented in demo'),
      ),
    );
  }
}