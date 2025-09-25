import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:developer' as developer;

/// Custom exception classes for better error handling
abstract class FirebaseServiceException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const FirebaseServiceException(this.message, {this.code, this.originalError});

  @override
  String toString() => 'FirebaseServiceException: $message (code: $code)';
}

class NetworkException extends FirebaseServiceException {
  const NetworkException(String message, {String? code, dynamic originalError})
      : super(message, code: code, originalError: originalError);
}

class AuthException extends FirebaseServiceException {
  const AuthException(String message, {String? code, dynamic originalError})
      : super(message, code: code, originalError: originalError);
}

class DataException extends FirebaseServiceException {
  const DataException(String message, {String? code, dynamic originalError})
      : super(message, code: code, originalError: originalError);
}

class StorageException extends FirebaseServiceException {
  const StorageException(String message, {String? code, dynamic originalError})
      : super(message, code: code, originalError: originalError);
}

class PermissionException extends FirebaseServiceException {
  const PermissionException(String message, {String? code, dynamic originalError})
      : super(message, code: code, originalError: originalError);
}

/// Error handler service for Firebase operations
class FirebaseErrorHandler {
  /// Handle Firestore exceptions and convert to user-friendly messages
  static FirebaseServiceException handleFirestoreError(dynamic error) {
    if (error is FirebaseException) {
      switch (error.code) {
        case 'permission-denied':
          return PermissionException(
            'You do not have permission to perform this action.',
            code: error.code,
            originalError: error,
          );
        case 'not-found':
          return DataException(
            'The requested data was not found.',
            code: error.code,
            originalError: error,
          );
        case 'unavailable':
        case 'deadline-exceeded':
          return NetworkException(
            'Service is temporarily unavailable. Please try again.',
            code: error.code,
            originalError: error,
          );
        case 'cancelled':
          return DataException(
            'Operation was cancelled.',
            code: error.code,
            originalError: error,
          );
        case 'data-loss':
          return DataException(
            'Data corruption detected. Please contact support.',
            code: error.code,
            originalError: error,
          );
        case 'failed-precondition':
          return DataException(
            'Operation cannot be completed in current state.',
            code: error.code,
            originalError: error,
          );
        case 'out-of-range':
          return DataException(
            'Invalid data range provided.',
            code: error.code,
            originalError: error,
          );
        case 'unauthenticated':
          return AuthException(
            'You must be signed in to perform this action.',
            code: error.code,
            originalError: error,
          );
        case 'resource-exhausted':
          return NetworkException(
            'Service limit reached. Please try again later.',
            code: error.code,
            originalError: error,
          );
        default:
          return DataException(
            'An unexpected error occurred: ${error.message}',
            code: error.code,
            originalError: error,
          );
      }
    }

    if (error is SocketException) {
      return NetworkException(
        'No internet connection available.',
        originalError: error,
      );
    }

    if (error is TimeoutException) {
      return NetworkException(
        'Request timed out. Please check your connection.',
        originalError: error,
      );
    }

    return DataException(
      'An unexpected error occurred: $error',
      originalError: error,
    );
  }

  /// Handle Firebase Auth exceptions
  static FirebaseServiceException handleAuthError(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return AuthException(
            'No user found with this email address.',
            code: error.code,
            originalError: error,
          );
        case 'wrong-password':
          return AuthException(
            'Incorrect password. Please try again.',
            code: error.code,
            originalError: error,
          );
        case 'email-already-in-use':
          return AuthException(
            'An account already exists with this email address.',
            code: error.code,
            originalError: error,
          );
        case 'weak-password':
          return AuthException(
            'Password is too weak. Please choose a stronger password.',
            code: error.code,
            originalError: error,
          );
        case 'invalid-email':
          return AuthException(
            'Please enter a valid email address.',
            code: error.code,
            originalError: error,
          );
        case 'user-disabled':
          return AuthException(
            'This account has been disabled. Please contact support.',
            code: error.code,
            originalError: error,
          );
        case 'too-many-requests':
          return AuthException(
            'Too many failed attempts. Please try again later.',
            code: error.code,
            originalError: error,
          );
        case 'network-request-failed':
          return NetworkException(
            'Network error. Please check your connection.',
            code: error.code,
            originalError: error,
          );
        default:
          return AuthException(
            'Authentication failed: ${error.message}',
            code: error.code,
            originalError: error,
          );
      }
    }

    return AuthException(
      'Authentication error: $error',
      originalError: error,
    );
  }

  /// Handle Firebase Storage exceptions
  static FirebaseServiceException handleStorageError(dynamic error) {
    if (error is FirebaseException) {
      switch (error.code) {
        case 'object-not-found':
          return StorageException(
            'File not found.',
            code: error.code,
            originalError: error,
          );
        case 'bucket-not-found':
          return StorageException(
            'Storage bucket not found.',
            code: error.code,
            originalError: error,
          );
        case 'project-not-found':
          return StorageException(
            'Project not found.',
            code: error.code,
            originalError: error,
          );
        case 'quota-exceeded':
          return StorageException(
            'Storage quota exceeded.',
            code: error.code,
            originalError: error,
          );
        case 'unauthenticated':
          return AuthException(
            'You must be signed in to upload files.',
            code: error.code,
            originalError: error,
          );
        case 'unauthorized':
          return PermissionException(
            'You do not have permission to access this file.',
            code: error.code,
            originalError: error,
          );
        case 'retry-limit-exceeded':
          return NetworkException(
            'Upload failed after multiple attempts. Please try again.',
            code: error.code,
            originalError: error,
          );
        case 'invalid-checksum':
          return StorageException(
            'File upload failed due to data corruption.',
            code: error.code,
            originalError: error,
          );
        case 'canceled':
          return StorageException(
            'Upload was cancelled.',
            code: error.code,
            originalError: error,
          );
        default:
          return StorageException(
            'Storage error: ${error.message}',
            code: error.code,
            originalError: error,
          );
      }
    }

    return StorageException(
      'Storage error: $error',
      originalError: error,
    );
  }

  /// Check if error is retryable
  static bool isRetryableError(dynamic error) {
    if (error is FirebaseException) {
      switch (error.code) {
        case 'unavailable':
        case 'deadline-exceeded':
        case 'resource-exhausted':
        case 'aborted':
        case 'internal':
        case 'network-request-failed':
        case 'retry-limit-exceeded':
          return true;
        default:
          return false;
      }
    }

    if (error is SocketException || error is TimeoutException) {
      return true;
    }

    return false;
  }

  /// Get appropriate retry delay based on attempt number
  static Duration getRetryDelay(int attempt) {
    // Exponential backoff with jitter
    final baseDelay = Duration(milliseconds: 1000);
    final maxDelay = Duration(seconds: 30);
    
    final delay = Duration(
      milliseconds: (baseDelay.inMilliseconds * (1 << (attempt - 1))).clamp(
        baseDelay.inMilliseconds,
        maxDelay.inMilliseconds,
      ),
    );
    
    // Add jitter (±25%)
    final jitter = (delay.inMilliseconds * 0.25).round();
    final randomJitter = (jitter * 2 * (0.5 - (DateTime.now().millisecond % 100) / 100)).round();
    
    return Duration(milliseconds: delay.inMilliseconds + randomJitter);
  }
}

/// Retry mechanism utility
class RetryUtil {
  /// Execute a function with retry logic
  static Future<T> retry<T>(
    Future<T> Function() operation, {
    int maxAttempts = 3,
    Duration? initialDelay,
    bool Function(dynamic error)? retryIf,
    void Function(int attempt, dynamic error)? onRetry,
  }) async {
    int attempt = 0;
    dynamic lastError;

    while (attempt < maxAttempts) {
      attempt++;
      
      try {
        return await operation();
      } catch (error) {
        lastError = error;
        
        // Check if we should retry
        final shouldRetry = retryIf?.call(error) ?? 
                           FirebaseErrorHandler.isRetryableError(error);
        
        if (!shouldRetry || attempt >= maxAttempts) {
          rethrow;
        }

        // Calculate delay
        final delay = initialDelay ?? FirebaseErrorHandler.getRetryDelay(attempt);
        
        // Call retry callback
        onRetry?.call(attempt, error);
        
        developer.log(
          'Retry attempt $attempt/$maxAttempts after ${delay.inMilliseconds}ms delay. Error: $error'
        );
        
        // Wait before retry
        await Future.delayed(delay);
      }
    }

    throw lastError;
  }

  /// Execute with timeout and retry
  static Future<T> retryWithTimeout<T>(
    Future<T> Function() operation, {
    Duration timeout = const Duration(seconds: 30),
    int maxAttempts = 3,
    Duration? initialDelay,
    bool Function(dynamic error)? retryIf,
    void Function(int attempt, dynamic error)? onRetry,
  }) async {
    return retry(
      () => operation().timeout(timeout),
      maxAttempts: maxAttempts,
      initialDelay: initialDelay,
      retryIf: retryIf,
      onRetry: onRetry,
    );
  }
}

/// Circuit breaker pattern for Firebase operations
class CircuitBreaker {
  final int failureThreshold;
  final Duration resetTimeout;
  final Duration callTimeout;

  int _failureCount = 0;
  DateTime? _lastFailureTime;
  bool _isOpen = false;

  CircuitBreaker({
    this.failureThreshold = 5,
    this.resetTimeout = const Duration(minutes: 1),
    this.callTimeout = const Duration(seconds: 10),
  });

  Future<T> execute<T>(Future<T> Function() operation) async {
    if (_isOpen) {
      if (_canReset()) {
        _reset();
      } else {
        throw NetworkException(
          'Service temporarily unavailable. Please try again later.',
          code: 'circuit-breaker-open',
        );
      }
    }

    try {
      final result = await operation().timeout(callTimeout);
      _onSuccess();
      return result;
    } catch (error) {
      _onFailure();
      rethrow;
    }
  }

  bool _canReset() {
    final now = DateTime.now();
    return _lastFailureTime != null &&
           now.difference(_lastFailureTime!) > resetTimeout;
  }

  void _reset() {
    _failureCount = 0;
    _isOpen = false;
    _lastFailureTime = null;
    developer.log('Circuit breaker reset');
  }

  void _onSuccess() {
    _failureCount = 0;
    developer.log('Circuit breaker: Operation succeeded');
  }

  void _onFailure() {
    _failureCount++;
    _lastFailureTime = DateTime.now();
    
    if (_failureCount >= failureThreshold) {
      _isOpen = true;
      developer.log('Circuit breaker opened after $_failureCount failures');
    }
  }

  bool get isOpen => _isOpen;
  int get failureCount => _failureCount;
}

/// Global circuit breaker instances
final firebaseCircuitBreaker = CircuitBreaker();
final storageCircuitBreaker = CircuitBreaker();

/// Provider for error handler
final firebaseErrorHandlerProvider = Provider<FirebaseErrorHandler>((ref) {
  return FirebaseErrorHandler();
});