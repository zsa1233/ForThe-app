// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cleanup_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CleanupSessionImpl _$$CleanupSessionImplFromJson(Map<String, dynamic> json) =>
    _$CleanupSessionImpl(
      id: json['id'] as String,
      hotspotId: json['hotspotId'] as String?,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      location: CleanupLocation.fromJson(
        json['location'] as Map<String, dynamic>,
      ),
      type: $enumDecode(_$CleanupTypeEnumMap, json['type']),
      estimatedDuration: json['estimatedDuration'] as String,
      beforePhotoPath: json['beforePhotoPath'] as String?,
      afterPhotoPath: json['afterPhotoPath'] as String?,
      poundsCollected: (json['poundsCollected'] as num?)?.toDouble() ?? 0.0,
      trashTypes:
          (json['trashTypes'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$TrashTypeEnumMap, e))
              .toList() ??
          const [],
      comments: json['comments'] as String?,
      status:
          $enumDecodeNullable(_$CleanupStatusEnumMap, json['status']) ??
          CleanupStatus.inProgress,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$CleanupSessionImplToJson(
  _$CleanupSessionImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'hotspotId': instance.hotspotId,
  'startTime': instance.startTime.toIso8601String(),
  'endTime': instance.endTime?.toIso8601String(),
  'location': instance.location,
  'type': _$CleanupTypeEnumMap[instance.type]!,
  'estimatedDuration': instance.estimatedDuration,
  'beforePhotoPath': instance.beforePhotoPath,
  'afterPhotoPath': instance.afterPhotoPath,
  'poundsCollected': instance.poundsCollected,
  'trashTypes': instance.trashTypes.map((e) => _$TrashTypeEnumMap[e]!).toList(),
  'comments': instance.comments,
  'status': _$CleanupStatusEnumMap[instance.status]!,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

const _$CleanupTypeEnumMap = {
  CleanupType.beach: 'beach',
  CleanupType.park: 'park',
  CleanupType.trail: 'trail',
  CleanupType.street: 'street',
  CleanupType.other: 'other',
};

const _$TrashTypeEnumMap = {
  TrashType.plastic: 'plastic',
  TrashType.paper: 'paper',
  TrashType.glass: 'glass',
  TrashType.metal: 'metal',
  TrashType.organic: 'organic',
  TrashType.electronic: 'electronic',
  TrashType.other: 'other',
};

const _$CleanupStatusEnumMap = {
  CleanupStatus.inProgress: 'in_progress',
  CleanupStatus.completed: 'completed',
  CleanupStatus.submitted: 'submitted',
  CleanupStatus.failed: 'failed',
};

_$CleanupLocationImpl _$$CleanupLocationImplFromJson(
  Map<String, dynamic> json,
) => _$CleanupLocationImpl(
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  address: json['address'] as String?,
  name: json['name'] as String?,
);

Map<String, dynamic> _$$CleanupLocationImplToJson(
  _$CleanupLocationImpl instance,
) => <String, dynamic>{
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'address': instance.address,
  'name': instance.name,
};
