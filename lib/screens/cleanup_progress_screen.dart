import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cleanup_models.dart';
import '../services/cleanup_timer_service.dart';
import '../providers/cleanup_session_provider.dart';
import 'cleanup_flow_enhanced.dart';
import 'cleanup_submission_screen.dart';

/// Enhanced cleanup progress screen with timer and validation
class EnhancedCleanupProgressScreen extends ConsumerStatefulWidget {
  const EnhancedCleanupProgressScreen({super.key});

  @override
  ConsumerState<EnhancedCleanupProgressScreen> createState() => 
      _EnhancedCleanupProgressScreenState();
}

class _EnhancedCleanupProgressScreenState 
    extends ConsumerState<EnhancedCleanupProgressScreen> {
  final _poundsController = TextEditingController();
  final Set<TrashType> _selectedTypes = {};
  final _formKey = GlobalKey<FormState>();
  bool _isTimerPaused = false;

  @override
  void initState() {
    super.initState();
    _poundsController.text = '0';
  }

  @override
  void dispose() {
    _poundsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timerState = ref.watch(cleanupTimerServiceProvider);
    final sessionAsync = ref.watch(cleanupSessionNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cleanup Progress'),
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
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Go Back'),
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
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No active cleanup session',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please start a new cleanup to continue',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Go to Home'),
            ),
          ],
        ),
      );
    }

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timer section
            Card(
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          timerState.isRunning ? Icons.timer : Icons.pause,
                          size: 24,
                          color: Colors.green.shade700,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          ref.read(cleanupTimerServiceProvider.notifier)
                              .formatDuration(timerState.elapsedSeconds),
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _toggleTimer,
                          icon: Icon(
                            timerState.isRunning ? Icons.pause : Icons.play_arrow,
                          ),
                          label: Text(
                            timerState.isRunning ? 'Pause' : 'Resume',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: timerState.isRunning 
                                ? Colors.orange 
                                : Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton.icon(
                          onPressed: _resetTimer,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reset'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Pounds collected
            const Text(
              'Pounds Collected',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _poundsController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: 'Enter pounds collected',
                suffixText: 'lbs',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.scale),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter pounds collected';
                }
                final pounds = double.tryParse(value);
                if (pounds == null) {
                  return 'Please enter a valid number';
                }
                if (pounds < 0) {
                  return 'Pounds cannot be negative';
                }
                if (pounds > 1000) {
                  return 'Pounds seems unrealistic (max 1000)';
                }
                return null;
              },
              onChanged: (value) {
                final pounds = double.tryParse(value);
                if (pounds != null && pounds >= 0) {
                  ref.read(cleanupSessionNotifierProvider.notifier)
                      .updatePoundsCollected(pounds);
                }
              },
            ),
            
            const SizedBox(height: 24),
            
            // Trash types
            const Text(
              'Trash Types Found',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Select all types of trash you collected:',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: TrashType.values.map((type) => 
                _buildTrashTypeChip(type)).toList(),
            ),
            
            const Spacer(),
            
            // Continue button
            ElevatedButton(
              onPressed: _canContinue() ? _continueToAfterPhoto : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 50),
                disabledBackgroundColor: Colors.grey.shade300,
              ),
              child: const Text('Take After Photo'),
            ),
            
            if (!_canContinue()) ...[
              const SizedBox(height: 8),
              SelectableText.rich(
                TextSpan(
                  text: _getContinueError(),
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

  Widget _buildTrashTypeChip(TrashType type) {
    return FilterChip(
      label: Text('${type.icon} ${type.displayName}'),
      selected: _selectedTypes.contains(type),
      onSelected: (selected) {
        setState(() {
          if (selected) {
            _selectedTypes.add(type);
          } else {
            _selectedTypes.remove(type);
          }
        });
        
        // Update session
        ref.read(cleanupSessionNotifierProvider.notifier)
            .updateTrashTypes(_selectedTypes.toList());
      },
    );
  }

  void _toggleTimer() {
    final timerNotifier = ref.read(cleanupTimerServiceProvider.notifier);
    final timerState = ref.read(cleanupTimerServiceProvider);
    
    if (timerState.isRunning) {
      timerNotifier.pauseTimer();
      setState(() => _isTimerPaused = true);
    } else {
      if (_isTimerPaused) {
        timerNotifier.resumeTimer();
      } else {
        timerNotifier.startTimer();
      }
      setState(() => _isTimerPaused = false);
    }
  }

  void _resetTimer() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Timer'),
        content: const Text('Are you sure you want to reset the timer? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(cleanupTimerServiceProvider.notifier).resetTimer();
              setState(() => _isTimerPaused = false);
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  bool _canContinue() {
    return _formKey.currentState?.validate() ?? false &&
           _selectedTypes.isNotEmpty;
  }

  String _getContinueError() {
    if (_selectedTypes.isEmpty) {
      return 'Please select at least one trash type';
    }
    final pounds = double.tryParse(_poundsController.text);
    if (pounds == null || pounds < 0) {
      return 'Please enter a valid amount of pounds collected';
    }
    return '';
  }

  Future<void> _continueToAfterPhoto() async {
    if (!_canContinue()) return;

    // Ensure all data is saved
    final pounds = double.tryParse(_poundsController.text) ?? 0.0;
    await ref.read(cleanupSessionNotifierProvider.notifier)
        .updatePoundsCollected(pounds);

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const EnhancedCleanupCameraScreen(
            step: CleanupCameraStep.after,
          ),
        ),
      );
    }
  }
}