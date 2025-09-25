import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cleanup_models.dart';
import '../providers/cleanup_session_provider.dart';
import '../services/cleanup_timer_service.dart';
import 'dart:io';

/// Enhanced submission screen with validation and offline support
class EnhancedCleanupSubmissionScreen extends ConsumerStatefulWidget {
  const EnhancedCleanupSubmissionScreen({super.key});

  @override
  ConsumerState<EnhancedCleanupSubmissionScreen> createState() => 
      _EnhancedCleanupSubmissionScreenState();
}

class _EnhancedCleanupSubmissionScreenState 
    extends ConsumerState<EnhancedCleanupSubmissionScreen> {
  final _commentsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sessionAsync = ref.watch(cleanupSessionNotifierProvider);
    final timerState = ref.watch(cleanupTimerServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Cleanup'),
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: sessionAsync.when(
        data: (session) => _buildContent(context, session, timerState),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              SelectableText.rich(
                TextSpan(
                  text: 'Error loading session: $error',
                  style: const TextStyle(color: Colors.red),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context, 
    CleanupSession? session,
    CleanupTimerState timerState,
  ) {
    if (session == null) {
      return const Center(
        child: Text('No active cleanup session'),
      );
    }

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Before/After photos
            const Text(
              'Photos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildPhotoSection(
                    'Before', 
                    session.beforePhoto,
                    Colors.red.shade100,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildPhotoSection(
                    'After', 
                    session.afterPhoto,
                    Colors.green.shade100,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Summary card
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Cleanup Summary',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildSummaryRow(
                      'Duration', 
                      ref.read(cleanupTimerServiceProvider.notifier)
                          .formatDuration(timerState.elapsedSeconds),
                      Icons.timer,
                    ),
                    const Divider(height: 24),
                    _buildSummaryRow(
                      'Weight Collected', 
                      '${session.poundsCollected.toStringAsFixed(1)} lbs',
                      Icons.scale,
                    ),
                    const Divider(height: 24),
                    _buildSummaryRow(
                      'Location Type', 
                      session.type.displayName,
                      Icons.location_on,
                    ),
                    const Divider(height: 24),
                    _buildSummaryRow(
                      'Trash Types', 
                      session.trashTypes.isEmpty 
                          ? 'None selected'
                          : session.trashTypes
                              .map((t) => t.displayName)
                              .join(', '),
                      Icons.delete,
                    ),
                    if (session.hotspotId != null) ...[
                      const Divider(height: 24),
                      _buildSummaryRow(
                        'Hotspot ID', 
                        session.hotspotId!,
                        Icons.place,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Comments section
            const Text(
              'Comments (Optional)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _commentsController,
              maxLines: 4,
              maxLength: 500,
              decoration: InputDecoration(
                hintText: 'Share details about your cleanup experience...\n'
                          '• What challenges did you face?\n'
                          '• What did you discover?\n'
                          '• Any suggestions for future cleanups?',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                counterText: '${_commentsController.text.length}/500',
              ),
              validator: (value) {
                if (value != null && value.length > 500) {
                  return 'Comments cannot exceed 500 characters';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {}); // Update character counter
                ref.read(cleanupSessionNotifierProvider.notifier)
                    .updateComments(value.isEmpty ? null : value);
              },
            ),
            
            const SizedBox(height: 32),
            
            // Validation status
            if (!session.isReadyForSubmission) ...[
              Card(
                color: Colors.orange.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Icon(Icons.warning, color: Colors.orange.shade700),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _getValidationMessage(session),
                          style: TextStyle(color: Colors.orange.shade700),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            // Submit button
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitCleanup,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 50),
                disabledBackgroundColor: Colors.grey.shade300,
              ),
              child: _isSubmitting 
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Submit Cleanup', style: TextStyle(fontSize: 16)),
            ),
            
            const SizedBox(height: 8),
            
            // Save as draft button
            OutlinedButton(
              onPressed: _isSubmitting ? null : _saveAsDraft,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Save as Draft', style: TextStyle(fontSize: 16)),
            ),
            
            const SizedBox(height: 8),
            
            // Edit details button
            OutlinedButton.icon(
              onPressed: _isSubmitting ? null : _goBackToEdit,
              icon: const Icon(Icons.edit),
              label: const Text('Edit Details'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoSection(String label, File? photo, Color backgroundColor) {
    return Column(
      children: [
        Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: photo != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    photo,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => 
                        const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error, color: Colors.red),
                              SizedBox(height: 4),
                              Text('Error loading image', 
                                   style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                  ),
                )
              : const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.photo, size: 40, color: Colors.grey),
                      SizedBox(height: 4),
                      Text('No photo', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label, 
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  String _getValidationMessage(CleanupSession session) {
    final issues = <String>[];
    
    if (session.beforePhoto == null) issues.add('Before photo missing');
    if (session.afterPhoto == null) issues.add('After photo missing');
    if (session.trashTypes.isEmpty) issues.add('No trash types selected');
    if (session.poundsCollected < 0) issues.add('Invalid weight');
    
    if (issues.isEmpty) {
      return 'Ready for submission!';
    }
    
    return 'Issues to fix: ${issues.join(', ')}';
  }

  Future<void> _submitCleanup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      // Complete the session first
      await ref.read(cleanupSessionNotifierProvider.notifier)
          .completeCleanupSession();
      
      // Then submit
      await ref.read(cleanupSessionNotifierProvider.notifier)
          .submitCleanupSession();

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const CleanupSuccessScreen(),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: SelectableText.rich(
              TextSpan(
                text: 'Failed to submit cleanup: $e',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _saveAsDraft() async {
    try {
      // Update comments
      await ref.read(cleanupSessionNotifierProvider.notifier)
          .updateComments(_commentsController.text.isEmpty 
              ? null 
              : _commentsController.text);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cleanup saved as draft'),
            backgroundColor: Colors.green,
          ),
        );
        
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: SelectableText.rich(
              TextSpan(
                text: 'Failed to save draft: $e',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  void _goBackToEdit() {
    // Save current comments first
    ref.read(cleanupSessionNotifierProvider.notifier)
        .updateComments(_commentsController.text.isEmpty 
            ? null 
            : _commentsController.text);
    
    // Go back to progress screen to edit details
    Navigator.pop(context);
  }
}

/// Success screen after submission
class CleanupSuccessScreen extends ConsumerWidget {
  const CleanupSuccessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionAsync = ref.watch(cleanupSessionNotifierProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Success!'),
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              ref.read(cleanupSessionNotifierProvider.notifier).clearSession();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            tooltip: 'Go Home',
          ),
        ],
      ),
      body: sessionAsync.when(
        data: (session) => _buildSuccessContent(context, ref, session),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => const Center(
          child: Text('Error loading success data'),
        ),
      ),
    );
  }

  Widget _buildSuccessContent(
    BuildContext context, 
    WidgetRef ref, 
    CleanupSession? session,
  ) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Success animation/icon
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.eco,
              color: Colors.green,
              size: 80,
            ),
          ),
          const SizedBox(height: 32),
          
          // Success message
          const Text(
            'Cleanup Submitted!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          
          Text(
            'Thank you for making a difference in your community!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 32),
          
          // Impact summary
          if (session != null) ...[
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      'Your Impact',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildImpactStat(
                          '${session.poundsCollected.toStringAsFixed(1)}',
                          'lbs cleaned',
                          Icons.scale,
                          Colors.blue,
                        ),
                        _buildImpactStat(
                          '${session.duration.inMinutes}',
                          'minutes',
                          Icons.timer,
                          Colors.orange,
                        ),
                        _buildImpactStat(
                          '${session.trashTypes.length}',
                          'trash types',
                          Icons.category,
                          Colors.purple,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16, 
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.emoji_events, 
                            color: Colors.amber,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '+${(session.poundsCollected * 5).toInt()} points earned',
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
          
          const Spacer(),
          
          // Action buttons
          ElevatedButton(
            onPressed: () {
              // Clear session and return to home
              ref.read(cleanupSessionNotifierProvider.notifier).clearSession();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text('Back to Home', style: TextStyle(fontSize: 16)),
          ),
          const SizedBox(height: 12),
          
          OutlinedButton.icon(
            onPressed: () {
              // Share functionality would go here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Share feature coming soon!'),
                ),
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
    );
  }

  Widget _buildImpactStat(
    String value, 
    String label, 
    IconData icon, 
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}