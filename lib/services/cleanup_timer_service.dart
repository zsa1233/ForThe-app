import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:developer' as developer;

class CleanupTimerService extends StateNotifier<CleanupTimerState> {
  CleanupTimerService() : super(const CleanupTimerState());
  
  Timer? _timer;
  
  /// Start the cleanup timer
  void startTimer() {
    if (state.isRunning) return;
    
    final startTime = DateTime.now();
    state = state.copyWith(
      isRunning: true,
      startTime: startTime,
      elapsedSeconds: 0,
    );
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      
      final elapsed = DateTime.now().difference(startTime).inSeconds;
      state = state.copyWith(elapsedSeconds: elapsed);
    });
    
    developer.log('Cleanup timer started');
  }
  
  /// Stop the cleanup timer
  void stopTimer() {
    _timer?.cancel();
    _timer = null;
    
    if (state.isRunning) {
      final endTime = DateTime.now();
      state = state.copyWith(
        isRunning: false,
        endTime: endTime,
      );
      
      developer.log('Cleanup timer stopped. Duration: ${formatDuration(state.elapsedSeconds)}');
    }
  }
  
  /// Pause the timer
  void pauseTimer() {
    if (!state.isRunning) return;
    
    _timer?.cancel();
    _timer = null;
    
    state = state.copyWith(isRunning: false);
    developer.log('Cleanup timer paused');
  }
  
  /// Resume the timer
  void resumeTimer() {
    if (state.isRunning || state.startTime == null) return;
    
    // Calculate the new start time to maintain elapsed duration
    final now = DateTime.now();
    final adjustedStartTime = now.subtract(Duration(seconds: state.elapsedSeconds));
    
    state = state.copyWith(
      isRunning: true,
      startTime: adjustedStartTime,
    );
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      
      final elapsed = DateTime.now().difference(adjustedStartTime).inSeconds;
      state = state.copyWith(elapsedSeconds: elapsed);
    });
    
    developer.log('Cleanup timer resumed');
  }
  
  /// Reset the timer
  void resetTimer() {
    _timer?.cancel();
    _timer = null;
    
    state = const CleanupTimerState();
    developer.log('Cleanup timer reset');
  }
  
  /// Get duration in a readable format
  String formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

class CleanupTimerState {
  final bool isRunning;
  final DateTime? startTime;
  final DateTime? endTime;
  final int elapsedSeconds;
  
  const CleanupTimerState({
    this.isRunning = false,
    this.startTime,
    this.endTime,
    this.elapsedSeconds = 0,
  });
  
  CleanupTimerState copyWith({
    bool? isRunning,
    DateTime? startTime,
    DateTime? endTime,
    int? elapsedSeconds,
  }) {
    return CleanupTimerState(
      isRunning: isRunning ?? this.isRunning,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
    );
  }
  
  /// Get total duration
  Duration get totalDuration {
    if (startTime == null) return Duration.zero;
    
    final end = endTime ?? (isRunning ? DateTime.now() : startTime!);
    return end.difference(startTime!);
  }
  
  /// Check if timer has meaningful duration (> 30 seconds)
  bool get hasMeaningfulDuration => elapsedSeconds > 30;
}

// Provider for CleanupTimerService
final cleanupTimerServiceProvider = 
    StateNotifierProvider<CleanupTimerService, CleanupTimerState>((ref) {
  return CleanupTimerService();
});