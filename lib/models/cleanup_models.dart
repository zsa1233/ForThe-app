import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:io';

part 'cleanup_models.freezed.dart';
part 'cleanup_models.g.dart';

@freezed
class CleanupSession with _$CleanupSession {
  const factory CleanupSession({
    required String id,
    String? hotspotId,
    required DateTime startTime,
    DateTime? endTime,
    required CleanupLocation location,
    required CleanupType type,
    required String estimatedDuration,
    @JsonKey(includeToJson: false, includeFromJson: false) File? beforePhoto,
    @JsonKey(includeToJson: false, includeFromJson: false) File? afterPhoto,
    String? beforePhotoPath,
    String? afterPhotoPath,
    @Default(0.0) double poundsCollected,
    @Default([]) List<TrashType> trashTypes,
    String? comments,
    @Default(CleanupStatus.inProgress) CleanupStatus status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _CleanupSession;

  factory CleanupSession.fromJson(Map<String, dynamic> json) =>
      _$CleanupSessionFromJson(json);
}

extension CleanupSessionExtension on CleanupSession {
  /// Create a copy with File objects from paths
  CleanupSession withPhotosFromPaths() {
    return copyWith(
      beforePhoto: beforePhotoPath != null ? File(beforePhotoPath!) : null,
      afterPhoto: afterPhotoPath != null ? File(afterPhotoPath!) : null,
    );
  }

  /// Create a copy with paths from File objects
  CleanupSession withPathsFromPhotos() {
    return copyWith(
      beforePhotoPath: beforePhoto?.path,
      afterPhotoPath: afterPhoto?.path,
    );
  }

  /// Get the duration of the cleanup
  Duration get duration {
    if (endTime == null) return Duration.zero;
    return endTime!.difference(startTime);
  }

  /// Check if the cleanup is ready for submission
  bool get isReadyForSubmission {
    return beforePhoto != null &&
           afterPhoto != null &&
           poundsCollected >= 0 &&
           trashTypes.isNotEmpty &&
           status == CleanupStatus.completed;
  }
}

@freezed
class CleanupLocation with _$CleanupLocation {
  const factory CleanupLocation({
    required double latitude,
    required double longitude,
    String? address,
    String? name,
  }) = _CleanupLocation;

  factory CleanupLocation.fromJson(Map<String, dynamic> json) =>
      _$CleanupLocationFromJson(json);
}

@JsonEnum()
enum CleanupType {
  @JsonValue('beach')
  beach,
  @JsonValue('park')
  park,
  @JsonValue('trail')
  trail,
  @JsonValue('street')
  street,
  @JsonValue('other')
  other,
}

@JsonEnum()
enum TrashType {
  @JsonValue('plastic')
  plastic,
  @JsonValue('paper')
  paper,
  @JsonValue('glass')
  glass,
  @JsonValue('metal')
  metal,
  @JsonValue('organic')
  organic,
  @JsonValue('electronic')
  electronic,
  @JsonValue('other')
  other,
}

@JsonEnum()
enum CleanupStatus {
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('completed')
  completed,
  @JsonValue('submitted')
  submitted,
  @JsonValue('failed')
  failed,
}

@freezed
class LocationVerificationResult with _$LocationVerificationResult {
  const factory LocationVerificationResult({
    required bool isValid,
    required double distanceInMeters,
    String? errorMessage,
  }) = _LocationVerificationResult;
}

@freezed
class CleanupValidationResult with _$CleanupValidationResult {
  const factory CleanupValidationResult({
    required bool isValid,
    @Default([]) List<String> errors,
  }) = _CleanupValidationResult;
}

extension CleanupTypeExtension on CleanupType {
  String get displayName {
    switch (this) {
      case CleanupType.beach:
        return 'Beach';
      case CleanupType.park:
        return 'Park';
      case CleanupType.trail:
        return 'Trail';
      case CleanupType.street:
        return 'Street';
      case CleanupType.other:
        return 'Other';
    }
  }

  String get icon {
    switch (this) {
      case CleanupType.beach:
        return '🏖️';
      case CleanupType.park:
        return '🏞️';
      case CleanupType.trail:
        return '🥾';
      case CleanupType.street:
        return '🛣️';
      case CleanupType.other:
        return '📍';
    }
  }
}

extension TrashTypeExtension on TrashType {
  String get displayName {
    switch (this) {
      case TrashType.plastic:
        return 'Plastic';
      case TrashType.paper:
        return 'Paper';
      case TrashType.glass:
        return 'Glass';
      case TrashType.metal:
        return 'Metal';
      case TrashType.organic:
        return 'Organic';
      case TrashType.electronic:
        return 'Electronic';
      case TrashType.other:
        return 'Other';
    }
  }

  String get icon {
    switch (this) {
      case TrashType.plastic:
        return '🥤';
      case TrashType.paper:
        return '📄';
      case TrashType.glass:
        return '🍺';
      case TrashType.metal:
        return '🥫';
      case TrashType.organic:
        return '🍌';
      case TrashType.electronic:
        return '📱';
      case TrashType.other:
        return '🗑️';
    }
  }
}