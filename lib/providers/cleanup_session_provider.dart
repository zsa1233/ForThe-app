import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/cleanup_models.dart';
import '../services/location_service.dart';
import '../services/camera_service.dart';
import '../services/local_storage_service.dart';
import '../services/cleanup_validation_service.dart';
import '../services/cleanup_timer_service.dart';
import 'dart:developer' as developer;
import 'package:uuid/uuid.dart';

part 'cleanup_session_provider.g.dart';

@riverpod
class CleanupSessionNotifier extends _$CleanupSessionNotifier {
  @override
  FutureOr<CleanupSession?> build() async {
    // Check for existing active session on startup
    try {
      final localStorage = ref.read(localStorageServiceProvider);
      final activeSession = await localStorage.getActiveCleanupSession();
      
      if (activeSession != null) {
        // Restore File objects from paths
        final sessionWithFiles = activeSession.withPhotosFromPaths();
        developer.log('Active cleanup session loaded: ${activeSession.id}');
        return sessionWithFiles;
      }
      
      return null; // No active session found
    } catch (e) {
      developer.log('Error loading active session: $e');
      return null;
    }
  }

  /// Start a new cleanup session
  Future<void> startCleanupSession({
    String? hotspotId,
    required CleanupType type,
    required String estimatedDuration,
    CleanupLocation? location,
  }) async {
    try {
      state = const AsyncValue.loading();

      // Get current location if not provided, or use a default for testing
      final locationService = ref.read(locationServiceProvider);
      final currentLocation = location ?? await locationService.getCurrentLocation() ?? 
        // Default location for testing (St. Louis coordinates)
        const CleanupLocation(latitude: 38.6270, longitude: -90.1994);

      // Create new session
      final sessionId = const Uuid().v4();
      final now = DateTime.now();
      
      final newSession = CleanupSession(
        id: sessionId,
        hotspotId: hotspotId,
        startTime: now,
        location: currentLocation,
        type: type,
        estimatedDuration: estimatedDuration,
        status: CleanupStatus.inProgress,
        createdAt: now,
        updatedAt: now,
      );

      // Save to local storage
      final localStorage = ref.read(localStorageServiceProvider);
      await localStorage.saveCleanupSession(newSession);

      // Start timer
      ref.read(cleanupTimerServiceProvider.notifier).startTimer();

      state = AsyncValue.data(newSession);
      developer.log('Cleanup session started: $sessionId');
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      developer.log('Error starting cleanup session: $e');
    }
  }

  /// Capture before photo
  Future<void> captureBeforePhoto() async {
    final currentSession = await future;
    if (currentSession == null) return;

    try {
      state = const AsyncValue.loading();

      final cameraService = ref.read(cameraServiceProvider);
      final photo = await cameraService.captureImage();

      if (photo != null) {
        final updatedSession = currentSession.copyWith(
          beforePhoto: photo,
          beforePhotoPath: photo.path,
          updatedAt: DateTime.now(),
        );

        // Save to local storage
        final localStorage = ref.read(localStorageServiceProvider);
        await localStorage.saveCleanupSession(updatedSession);

        state = AsyncValue.data(updatedSession);
        developer.log('Before photo captured: ${photo.path}');
      } else {
        state = AsyncValue.data(currentSession);
        developer.log('Before photo capture cancelled');
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      developer.log('Error capturing before photo: $e');
    }
  }

  /// Capture after photo
  Future<void> captureAfterPhoto() async {
    final currentSession = await future;
    if (currentSession == null) return;

    try {
      state = const AsyncValue.loading();

      final cameraService = ref.read(cameraServiceProvider);
      final photo = await cameraService.captureImage();

      if (photo != null) {
        final updatedSession = currentSession.copyWith(
          afterPhoto: photo,
          afterPhotoPath: photo.path,
          updatedAt: DateTime.now(),
        );

        // Save to local storage
        final localStorage = ref.read(localStorageServiceProvider);
        await localStorage.saveCleanupSession(updatedSession);

        state = AsyncValue.data(updatedSession);
        developer.log('After photo captured: ${photo.path}');
      } else {
        state = AsyncValue.data(currentSession);
        developer.log('After photo capture cancelled');
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      developer.log('Error capturing after photo: $e');
    }
  }

  /// Update pounds collected
  Future<void> updatePoundsCollected(double pounds) async {
    final currentSession = await future;
    if (currentSession == null) return;

    try {
      // Validate pounds
      final validationService = ref.read(cleanupValidationServiceProvider);
      final validation = validationService.validatePoundsCollected(pounds);
      
      if (!validation.isValid) {
        throw Exception(validation.errors.join(', '));
      }

      final updatedSession = currentSession.copyWith(
        poundsCollected: pounds,
        updatedAt: DateTime.now(),
      );

      // Save to local storage
      final localStorage = ref.read(localStorageServiceProvider);
      await localStorage.saveCleanupSession(updatedSession);

      state = AsyncValue.data(updatedSession);
      developer.log('Pounds collected updated: $pounds');
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      developer.log('Error updating pounds collected: $e');
    }
  }

  /// Update trash types
  Future<void> updateTrashTypes(List<TrashType> trashTypes) async {
    final currentSession = await future;
    if (currentSession == null) return;

    try {
      final updatedSession = currentSession.copyWith(
        trashTypes: trashTypes,
        updatedAt: DateTime.now(),
      );

      // Save to local storage
      final localStorage = ref.read(localStorageServiceProvider);
      await localStorage.saveCleanupSession(updatedSession);

      state = AsyncValue.data(updatedSession);
      developer.log('Trash types updated: ${trashTypes.map((t) => t.displayName).join(', ')}');
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      developer.log('Error updating trash types: $e');
    }
  }

  /// Update comments
  Future<void> updateComments(String? comments) async {
    final currentSession = await future;
    if (currentSession == null) return;

    try {
      // Validate comments
      final validationService = ref.read(cleanupValidationServiceProvider);
      final validation = validationService.validateComments(comments);
      
      if (!validation.isValid) {
        throw Exception(validation.errors.join(', '));
      }

      final updatedSession = currentSession.copyWith(
        comments: comments,
        updatedAt: DateTime.now(),
      );

      // Save to local storage
      final localStorage = ref.read(localStorageServiceProvider);
      await localStorage.saveCleanupSession(updatedSession);

      state = AsyncValue.data(updatedSession);
      developer.log('Comments updated');
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      developer.log('Error updating comments: $e');
    }
  }

  /// Complete the cleanup session
  Future<void> completeCleanupSession() async {
    final currentSession = await future;
    if (currentSession == null) return;

    try {
      state = const AsyncValue.loading();

      // Stop timer
      ref.read(cleanupTimerServiceProvider.notifier).stopTimer();
      final timerState = ref.read(cleanupTimerServiceProvider);

      final updatedSession = currentSession.copyWith(
        status: CleanupStatus.completed,
        endTime: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Validate the session
      final validationService = ref.read(cleanupValidationServiceProvider);
      final validation = validationService.validateCleanupSession(updatedSession);

      if (!validation.isValid) {
        throw Exception('Cleanup session validation failed: ${validation.errors.join(', ')}');
      }

      // Save to local storage
      final localStorage = ref.read(localStorageServiceProvider);
      await localStorage.saveCleanupSession(updatedSession);

      // Add to pending uploads
      await localStorage.addToPendingUploads(updatedSession.id);

      state = AsyncValue.data(updatedSession);
      developer.log('Cleanup session completed: ${updatedSession.id}');
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      developer.log('Error completing cleanup session: $e');
    }
  }

  /// Submit the cleanup session
  Future<void> submitCleanupSession() async {
    final currentSession = await future;
    if (currentSession == null) return;

    try {
      state = const AsyncValue.loading();

      // Ensure session is completed
      if (currentSession.status != CleanupStatus.completed) {
        throw Exception('Session must be completed before submission');
      }

      // Here you would typically submit to Firebase
      // For now, we'll just mark as submitted
      final submittedSession = currentSession.copyWith(
        status: CleanupStatus.submitted,
        updatedAt: DateTime.now(),
      );

      // Save to local storage
      final localStorage = ref.read(localStorageServiceProvider);
      await localStorage.saveCleanupSession(submittedSession);

      // Remove from pending uploads
      await localStorage.removeFromPendingUploads(submittedSession.id);

      state = AsyncValue.data(submittedSession);
      developer.log('Cleanup session submitted: ${submittedSession.id}');
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      developer.log('Error submitting cleanup session: $e');
    }
  }

  /// Load an existing cleanup session
  Future<void> loadCleanupSession(String sessionId) async {
    try {
      state = const AsyncValue.loading();

      final localStorage = ref.read(localStorageServiceProvider);
      final session = await localStorage.loadCleanupSession(sessionId);

      if (session == null) {
        throw Exception('Session not found: $sessionId');
      }

      // Restore File objects from paths
      final sessionWithFiles = session.withPhotosFromPaths();
      
      state = AsyncValue.data(sessionWithFiles);
      developer.log('Cleanup session loaded: $sessionId');
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      developer.log('Error loading cleanup session: $e');
    }
  }

  /// Clear the current session
  void clearSession() {
    // Stop timer if running
    ref.read(cleanupTimerServiceProvider.notifier).resetTimer();
    
    state = const AsyncValue.data(null);
    developer.log('Cleanup session cleared');
  }
}

