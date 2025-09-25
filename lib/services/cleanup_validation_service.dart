import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cleanup_models.dart';

class CleanupValidationService {
  
  /// Validate pounds collected input
  CleanupValidationResult validatePoundsCollected(double pounds) {
    final errors = <String>[];
    
    if (pounds < 0) {
      errors.add('Pounds collected cannot be negative');
    }
    
    if (pounds > 1000) {
      errors.add('Pounds collected seems unrealistic (max 1000 lbs)');
    }
    
    // Allow 0 pounds for cases where cleanup was attempted but minimal trash found
    
    return CleanupValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }

  /// Validate trash types selection
  CleanupValidationResult validateTrashTypes(List<TrashType> trashTypes) {
    final errors = <String>[];
    
    if (trashTypes.isEmpty) {
      errors.add('Please select at least one trash type');
    }
    
    return CleanupValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }

  /// Validate before photo
  CleanupValidationResult validateBeforePhoto(dynamic beforePhoto) {
    final errors = <String>[];
    
    if (beforePhoto == null) {
      errors.add('Before photo is required');
    }
    
    return CleanupValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }

  /// Validate after photo
  CleanupValidationResult validateAfterPhoto(dynamic afterPhoto) {
    final errors = <String>[];
    
    if (afterPhoto == null) {
      errors.add('After photo is required');
    }
    
    return CleanupValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }

  /// Validate cleanup duration
  CleanupValidationResult validateDuration(DateTime startTime, DateTime? endTime) {
    final errors = <String>[];
    
    if (endTime == null) {
      return const CleanupValidationResult(isValid: true, errors: []);
    }
    
    final duration = endTime.difference(startTime);
    
    if (duration.isNegative) {
      errors.add('End time cannot be before start time');
    }
    
    if (duration.inMinutes < 1) {
      errors.add('Cleanup duration must be at least 1 minute');
    }
    
    if (duration.inHours > 24) {
      errors.add('Cleanup duration cannot exceed 24 hours');
    }
    
    return CleanupValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }

  /// Validate comments length
  CleanupValidationResult validateComments(String? comments) {
    final errors = <String>[];
    
    if (comments != null && comments.length > 500) {
      errors.add('Comments cannot exceed 500 characters');
    }
    
    return CleanupValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }

  /// Validate entire cleanup session
  CleanupValidationResult validateCleanupSession(CleanupSession session) {
    final allErrors = <String>[];
    
    // Validate pounds
    final poundsResult = validatePoundsCollected(session.poundsCollected);
    allErrors.addAll(poundsResult.errors);
    
    // Validate trash types
    final trashTypesResult = validateTrashTypes(session.trashTypes);
    allErrors.addAll(trashTypesResult.errors);
    
    // Validate photos
    final beforePhotoResult = validateBeforePhoto(session.beforePhoto);
    allErrors.addAll(beforePhotoResult.errors);
    
    final afterPhotoResult = validateAfterPhoto(session.afterPhoto);
    allErrors.addAll(afterPhotoResult.errors);
    
    // Validate duration
    final durationResult = validateDuration(session.startTime, session.endTime);
    allErrors.addAll(durationResult.errors);
    
    // Validate comments
    final commentsResult = validateComments(session.comments);
    allErrors.addAll(commentsResult.errors);
    
    return CleanupValidationResult(
      isValid: allErrors.isEmpty,
      errors: allErrors,
    );
  }

  /// Check if cleanup is ready for submission
  bool isReadyForSubmission(CleanupSession session) {
    return session.beforePhoto != null &&
           session.afterPhoto != null &&
           session.poundsCollected >= 0 &&
           session.trashTypes.isNotEmpty &&
           session.endTime != null;
  }

  /// Format validation errors for display
  String formatValidationErrors(List<String> errors) {
    if (errors.isEmpty) return '';
    
    if (errors.length == 1) {
      return errors.first;
    }
    
    return errors.map((error) => '• $error').join('\n');
  }
}

// Provider for CleanupValidationService
final cleanupValidationServiceProvider = Provider<CleanupValidationService>((ref) {
  return CleanupValidationService();
});