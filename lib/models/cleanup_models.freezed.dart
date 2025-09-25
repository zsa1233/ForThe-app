// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cleanup_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CleanupSession _$CleanupSessionFromJson(Map<String, dynamic> json) {
  return _CleanupSession.fromJson(json);
}

/// @nodoc
mixin _$CleanupSession {
  String get id => throw _privateConstructorUsedError;
  String? get hotspotId => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime? get endTime => throw _privateConstructorUsedError;
  CleanupLocation get location => throw _privateConstructorUsedError;
  CleanupType get type => throw _privateConstructorUsedError;
  String get estimatedDuration => throw _privateConstructorUsedError;
  @JsonKey(includeToJson: false, includeFromJson: false)
  File? get beforePhoto => throw _privateConstructorUsedError;
  @JsonKey(includeToJson: false, includeFromJson: false)
  File? get afterPhoto => throw _privateConstructorUsedError;
  String? get beforePhotoPath => throw _privateConstructorUsedError;
  String? get afterPhotoPath => throw _privateConstructorUsedError;
  double get poundsCollected => throw _privateConstructorUsedError;
  List<TrashType> get trashTypes => throw _privateConstructorUsedError;
  String? get comments => throw _privateConstructorUsedError;
  CleanupStatus get status => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this CleanupSession to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CleanupSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CleanupSessionCopyWith<CleanupSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CleanupSessionCopyWith<$Res> {
  factory $CleanupSessionCopyWith(
    CleanupSession value,
    $Res Function(CleanupSession) then,
  ) = _$CleanupSessionCopyWithImpl<$Res, CleanupSession>;
  @useResult
  $Res call({
    String id,
    String? hotspotId,
    DateTime startTime,
    DateTime? endTime,
    CleanupLocation location,
    CleanupType type,
    String estimatedDuration,
    @JsonKey(includeToJson: false, includeFromJson: false) File? beforePhoto,
    @JsonKey(includeToJson: false, includeFromJson: false) File? afterPhoto,
    String? beforePhotoPath,
    String? afterPhotoPath,
    double poundsCollected,
    List<TrashType> trashTypes,
    String? comments,
    CleanupStatus status,
    DateTime? createdAt,
    DateTime? updatedAt,
  });

  $CleanupLocationCopyWith<$Res> get location;
}

/// @nodoc
class _$CleanupSessionCopyWithImpl<$Res, $Val extends CleanupSession>
    implements $CleanupSessionCopyWith<$Res> {
  _$CleanupSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CleanupSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? hotspotId = freezed,
    Object? startTime = null,
    Object? endTime = freezed,
    Object? location = null,
    Object? type = null,
    Object? estimatedDuration = null,
    Object? beforePhoto = freezed,
    Object? afterPhoto = freezed,
    Object? beforePhotoPath = freezed,
    Object? afterPhotoPath = freezed,
    Object? poundsCollected = null,
    Object? trashTypes = null,
    Object? comments = freezed,
    Object? status = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            hotspotId: freezed == hotspotId
                ? _value.hotspotId
                : hotspotId // ignore: cast_nullable_to_non_nullable
                      as String?,
            startTime: null == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endTime: freezed == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            location: null == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as CleanupLocation,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as CleanupType,
            estimatedDuration: null == estimatedDuration
                ? _value.estimatedDuration
                : estimatedDuration // ignore: cast_nullable_to_non_nullable
                      as String,
            beforePhoto: freezed == beforePhoto
                ? _value.beforePhoto
                : beforePhoto // ignore: cast_nullable_to_non_nullable
                      as File?,
            afterPhoto: freezed == afterPhoto
                ? _value.afterPhoto
                : afterPhoto // ignore: cast_nullable_to_non_nullable
                      as File?,
            beforePhotoPath: freezed == beforePhotoPath
                ? _value.beforePhotoPath
                : beforePhotoPath // ignore: cast_nullable_to_non_nullable
                      as String?,
            afterPhotoPath: freezed == afterPhotoPath
                ? _value.afterPhotoPath
                : afterPhotoPath // ignore: cast_nullable_to_non_nullable
                      as String?,
            poundsCollected: null == poundsCollected
                ? _value.poundsCollected
                : poundsCollected // ignore: cast_nullable_to_non_nullable
                      as double,
            trashTypes: null == trashTypes
                ? _value.trashTypes
                : trashTypes // ignore: cast_nullable_to_non_nullable
                      as List<TrashType>,
            comments: freezed == comments
                ? _value.comments
                : comments // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as CleanupStatus,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }

  /// Create a copy of CleanupSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CleanupLocationCopyWith<$Res> get location {
    return $CleanupLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CleanupSessionImplCopyWith<$Res>
    implements $CleanupSessionCopyWith<$Res> {
  factory _$$CleanupSessionImplCopyWith(
    _$CleanupSessionImpl value,
    $Res Function(_$CleanupSessionImpl) then,
  ) = __$$CleanupSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String? hotspotId,
    DateTime startTime,
    DateTime? endTime,
    CleanupLocation location,
    CleanupType type,
    String estimatedDuration,
    @JsonKey(includeToJson: false, includeFromJson: false) File? beforePhoto,
    @JsonKey(includeToJson: false, includeFromJson: false) File? afterPhoto,
    String? beforePhotoPath,
    String? afterPhotoPath,
    double poundsCollected,
    List<TrashType> trashTypes,
    String? comments,
    CleanupStatus status,
    DateTime? createdAt,
    DateTime? updatedAt,
  });

  @override
  $CleanupLocationCopyWith<$Res> get location;
}

/// @nodoc
class __$$CleanupSessionImplCopyWithImpl<$Res>
    extends _$CleanupSessionCopyWithImpl<$Res, _$CleanupSessionImpl>
    implements _$$CleanupSessionImplCopyWith<$Res> {
  __$$CleanupSessionImplCopyWithImpl(
    _$CleanupSessionImpl _value,
    $Res Function(_$CleanupSessionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CleanupSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? hotspotId = freezed,
    Object? startTime = null,
    Object? endTime = freezed,
    Object? location = null,
    Object? type = null,
    Object? estimatedDuration = null,
    Object? beforePhoto = freezed,
    Object? afterPhoto = freezed,
    Object? beforePhotoPath = freezed,
    Object? afterPhotoPath = freezed,
    Object? poundsCollected = null,
    Object? trashTypes = null,
    Object? comments = freezed,
    Object? status = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$CleanupSessionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        hotspotId: freezed == hotspotId
            ? _value.hotspotId
            : hotspotId // ignore: cast_nullable_to_non_nullable
                  as String?,
        startTime: null == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endTime: freezed == endTime
            ? _value.endTime
            : endTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        location: null == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as CleanupLocation,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as CleanupType,
        estimatedDuration: null == estimatedDuration
            ? _value.estimatedDuration
            : estimatedDuration // ignore: cast_nullable_to_non_nullable
                  as String,
        beforePhoto: freezed == beforePhoto
            ? _value.beforePhoto
            : beforePhoto // ignore: cast_nullable_to_non_nullable
                  as File?,
        afterPhoto: freezed == afterPhoto
            ? _value.afterPhoto
            : afterPhoto // ignore: cast_nullable_to_non_nullable
                  as File?,
        beforePhotoPath: freezed == beforePhotoPath
            ? _value.beforePhotoPath
            : beforePhotoPath // ignore: cast_nullable_to_non_nullable
                  as String?,
        afterPhotoPath: freezed == afterPhotoPath
            ? _value.afterPhotoPath
            : afterPhotoPath // ignore: cast_nullable_to_non_nullable
                  as String?,
        poundsCollected: null == poundsCollected
            ? _value.poundsCollected
            : poundsCollected // ignore: cast_nullable_to_non_nullable
                  as double,
        trashTypes: null == trashTypes
            ? _value._trashTypes
            : trashTypes // ignore: cast_nullable_to_non_nullable
                  as List<TrashType>,
        comments: freezed == comments
            ? _value.comments
            : comments // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as CleanupStatus,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CleanupSessionImpl implements _CleanupSession {
  const _$CleanupSessionImpl({
    required this.id,
    this.hotspotId,
    required this.startTime,
    this.endTime,
    required this.location,
    required this.type,
    required this.estimatedDuration,
    @JsonKey(includeToJson: false, includeFromJson: false) this.beforePhoto,
    @JsonKey(includeToJson: false, includeFromJson: false) this.afterPhoto,
    this.beforePhotoPath,
    this.afterPhotoPath,
    this.poundsCollected = 0.0,
    final List<TrashType> trashTypes = const [],
    this.comments,
    this.status = CleanupStatus.inProgress,
    this.createdAt,
    this.updatedAt,
  }) : _trashTypes = trashTypes;

  factory _$CleanupSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$CleanupSessionImplFromJson(json);

  @override
  final String id;
  @override
  final String? hotspotId;
  @override
  final DateTime startTime;
  @override
  final DateTime? endTime;
  @override
  final CleanupLocation location;
  @override
  final CleanupType type;
  @override
  final String estimatedDuration;
  @override
  @JsonKey(includeToJson: false, includeFromJson: false)
  final File? beforePhoto;
  @override
  @JsonKey(includeToJson: false, includeFromJson: false)
  final File? afterPhoto;
  @override
  final String? beforePhotoPath;
  @override
  final String? afterPhotoPath;
  @override
  @JsonKey()
  final double poundsCollected;
  final List<TrashType> _trashTypes;
  @override
  @JsonKey()
  List<TrashType> get trashTypes {
    if (_trashTypes is EqualUnmodifiableListView) return _trashTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_trashTypes);
  }

  @override
  final String? comments;
  @override
  @JsonKey()
  final CleanupStatus status;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'CleanupSession(id: $id, hotspotId: $hotspotId, startTime: $startTime, endTime: $endTime, location: $location, type: $type, estimatedDuration: $estimatedDuration, beforePhoto: $beforePhoto, afterPhoto: $afterPhoto, beforePhotoPath: $beforePhotoPath, afterPhotoPath: $afterPhotoPath, poundsCollected: $poundsCollected, trashTypes: $trashTypes, comments: $comments, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CleanupSessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.hotspotId, hotspotId) ||
                other.hotspotId == hotspotId) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.estimatedDuration, estimatedDuration) ||
                other.estimatedDuration == estimatedDuration) &&
            (identical(other.beforePhoto, beforePhoto) ||
                other.beforePhoto == beforePhoto) &&
            (identical(other.afterPhoto, afterPhoto) ||
                other.afterPhoto == afterPhoto) &&
            (identical(other.beforePhotoPath, beforePhotoPath) ||
                other.beforePhotoPath == beforePhotoPath) &&
            (identical(other.afterPhotoPath, afterPhotoPath) ||
                other.afterPhotoPath == afterPhotoPath) &&
            (identical(other.poundsCollected, poundsCollected) ||
                other.poundsCollected == poundsCollected) &&
            const DeepCollectionEquality().equals(
              other._trashTypes,
              _trashTypes,
            ) &&
            (identical(other.comments, comments) ||
                other.comments == comments) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    hotspotId,
    startTime,
    endTime,
    location,
    type,
    estimatedDuration,
    beforePhoto,
    afterPhoto,
    beforePhotoPath,
    afterPhotoPath,
    poundsCollected,
    const DeepCollectionEquality().hash(_trashTypes),
    comments,
    status,
    createdAt,
    updatedAt,
  );

  /// Create a copy of CleanupSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CleanupSessionImplCopyWith<_$CleanupSessionImpl> get copyWith =>
      __$$CleanupSessionImplCopyWithImpl<_$CleanupSessionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CleanupSessionImplToJson(this);
  }
}

abstract class _CleanupSession implements CleanupSession {
  const factory _CleanupSession({
    required final String id,
    final String? hotspotId,
    required final DateTime startTime,
    final DateTime? endTime,
    required final CleanupLocation location,
    required final CleanupType type,
    required final String estimatedDuration,
    @JsonKey(includeToJson: false, includeFromJson: false)
    final File? beforePhoto,
    @JsonKey(includeToJson: false, includeFromJson: false)
    final File? afterPhoto,
    final String? beforePhotoPath,
    final String? afterPhotoPath,
    final double poundsCollected,
    final List<TrashType> trashTypes,
    final String? comments,
    final CleanupStatus status,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$CleanupSessionImpl;

  factory _CleanupSession.fromJson(Map<String, dynamic> json) =
      _$CleanupSessionImpl.fromJson;

  @override
  String get id;
  @override
  String? get hotspotId;
  @override
  DateTime get startTime;
  @override
  DateTime? get endTime;
  @override
  CleanupLocation get location;
  @override
  CleanupType get type;
  @override
  String get estimatedDuration;
  @override
  @JsonKey(includeToJson: false, includeFromJson: false)
  File? get beforePhoto;
  @override
  @JsonKey(includeToJson: false, includeFromJson: false)
  File? get afterPhoto;
  @override
  String? get beforePhotoPath;
  @override
  String? get afterPhotoPath;
  @override
  double get poundsCollected;
  @override
  List<TrashType> get trashTypes;
  @override
  String? get comments;
  @override
  CleanupStatus get status;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of CleanupSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CleanupSessionImplCopyWith<_$CleanupSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CleanupLocation _$CleanupLocationFromJson(Map<String, dynamic> json) {
  return _CleanupLocation.fromJson(json);
}

/// @nodoc
mixin _$CleanupLocation {
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;

  /// Serializes this CleanupLocation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CleanupLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CleanupLocationCopyWith<CleanupLocation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CleanupLocationCopyWith<$Res> {
  factory $CleanupLocationCopyWith(
    CleanupLocation value,
    $Res Function(CleanupLocation) then,
  ) = _$CleanupLocationCopyWithImpl<$Res, CleanupLocation>;
  @useResult
  $Res call({double latitude, double longitude, String? address, String? name});
}

/// @nodoc
class _$CleanupLocationCopyWithImpl<$Res, $Val extends CleanupLocation>
    implements $CleanupLocationCopyWith<$Res> {
  _$CleanupLocationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CleanupLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
    Object? address = freezed,
    Object? name = freezed,
  }) {
    return _then(
      _value.copyWith(
            latitude: null == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double,
            longitude: null == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double,
            address: freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String?,
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CleanupLocationImplCopyWith<$Res>
    implements $CleanupLocationCopyWith<$Res> {
  factory _$$CleanupLocationImplCopyWith(
    _$CleanupLocationImpl value,
    $Res Function(_$CleanupLocationImpl) then,
  ) = __$$CleanupLocationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double latitude, double longitude, String? address, String? name});
}

/// @nodoc
class __$$CleanupLocationImplCopyWithImpl<$Res>
    extends _$CleanupLocationCopyWithImpl<$Res, _$CleanupLocationImpl>
    implements _$$CleanupLocationImplCopyWith<$Res> {
  __$$CleanupLocationImplCopyWithImpl(
    _$CleanupLocationImpl _value,
    $Res Function(_$CleanupLocationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CleanupLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
    Object? address = freezed,
    Object? name = freezed,
  }) {
    return _then(
      _$CleanupLocationImpl(
        latitude: null == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double,
        longitude: null == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double,
        address: freezed == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String?,
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CleanupLocationImpl implements _CleanupLocation {
  const _$CleanupLocationImpl({
    required this.latitude,
    required this.longitude,
    this.address,
    this.name,
  });

  factory _$CleanupLocationImpl.fromJson(Map<String, dynamic> json) =>
      _$$CleanupLocationImplFromJson(json);

  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final String? address;
  @override
  final String? name;

  @override
  String toString() {
    return 'CleanupLocation(latitude: $latitude, longitude: $longitude, address: $address, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CleanupLocationImpl &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, latitude, longitude, address, name);

  /// Create a copy of CleanupLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CleanupLocationImplCopyWith<_$CleanupLocationImpl> get copyWith =>
      __$$CleanupLocationImplCopyWithImpl<_$CleanupLocationImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CleanupLocationImplToJson(this);
  }
}

abstract class _CleanupLocation implements CleanupLocation {
  const factory _CleanupLocation({
    required final double latitude,
    required final double longitude,
    final String? address,
    final String? name,
  }) = _$CleanupLocationImpl;

  factory _CleanupLocation.fromJson(Map<String, dynamic> json) =
      _$CleanupLocationImpl.fromJson;

  @override
  double get latitude;
  @override
  double get longitude;
  @override
  String? get address;
  @override
  String? get name;

  /// Create a copy of CleanupLocation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CleanupLocationImplCopyWith<_$CleanupLocationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$LocationVerificationResult {
  bool get isValid => throw _privateConstructorUsedError;
  double get distanceInMeters => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of LocationVerificationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LocationVerificationResultCopyWith<LocationVerificationResult>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocationVerificationResultCopyWith<$Res> {
  factory $LocationVerificationResultCopyWith(
    LocationVerificationResult value,
    $Res Function(LocationVerificationResult) then,
  ) =
      _$LocationVerificationResultCopyWithImpl<
        $Res,
        LocationVerificationResult
      >;
  @useResult
  $Res call({bool isValid, double distanceInMeters, String? errorMessage});
}

/// @nodoc
class _$LocationVerificationResultCopyWithImpl<
  $Res,
  $Val extends LocationVerificationResult
>
    implements $LocationVerificationResultCopyWith<$Res> {
  _$LocationVerificationResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LocationVerificationResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isValid = null,
    Object? distanceInMeters = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            isValid: null == isValid
                ? _value.isValid
                : isValid // ignore: cast_nullable_to_non_nullable
                      as bool,
            distanceInMeters: null == distanceInMeters
                ? _value.distanceInMeters
                : distanceInMeters // ignore: cast_nullable_to_non_nullable
                      as double,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LocationVerificationResultImplCopyWith<$Res>
    implements $LocationVerificationResultCopyWith<$Res> {
  factory _$$LocationVerificationResultImplCopyWith(
    _$LocationVerificationResultImpl value,
    $Res Function(_$LocationVerificationResultImpl) then,
  ) = __$$LocationVerificationResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isValid, double distanceInMeters, String? errorMessage});
}

/// @nodoc
class __$$LocationVerificationResultImplCopyWithImpl<$Res>
    extends
        _$LocationVerificationResultCopyWithImpl<
          $Res,
          _$LocationVerificationResultImpl
        >
    implements _$$LocationVerificationResultImplCopyWith<$Res> {
  __$$LocationVerificationResultImplCopyWithImpl(
    _$LocationVerificationResultImpl _value,
    $Res Function(_$LocationVerificationResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LocationVerificationResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isValid = null,
    Object? distanceInMeters = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$LocationVerificationResultImpl(
        isValid: null == isValid
            ? _value.isValid
            : isValid // ignore: cast_nullable_to_non_nullable
                  as bool,
        distanceInMeters: null == distanceInMeters
            ? _value.distanceInMeters
            : distanceInMeters // ignore: cast_nullable_to_non_nullable
                  as double,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$LocationVerificationResultImpl implements _LocationVerificationResult {
  const _$LocationVerificationResultImpl({
    required this.isValid,
    required this.distanceInMeters,
    this.errorMessage,
  });

  @override
  final bool isValid;
  @override
  final double distanceInMeters;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'LocationVerificationResult(isValid: $isValid, distanceInMeters: $distanceInMeters, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocationVerificationResultImpl &&
            (identical(other.isValid, isValid) || other.isValid == isValid) &&
            (identical(other.distanceInMeters, distanceInMeters) ||
                other.distanceInMeters == distanceInMeters) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isValid, distanceInMeters, errorMessage);

  /// Create a copy of LocationVerificationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LocationVerificationResultImplCopyWith<_$LocationVerificationResultImpl>
  get copyWith =>
      __$$LocationVerificationResultImplCopyWithImpl<
        _$LocationVerificationResultImpl
      >(this, _$identity);
}

abstract class _LocationVerificationResult
    implements LocationVerificationResult {
  const factory _LocationVerificationResult({
    required final bool isValid,
    required final double distanceInMeters,
    final String? errorMessage,
  }) = _$LocationVerificationResultImpl;

  @override
  bool get isValid;
  @override
  double get distanceInMeters;
  @override
  String? get errorMessage;

  /// Create a copy of LocationVerificationResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LocationVerificationResultImplCopyWith<_$LocationVerificationResultImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CleanupValidationResult {
  bool get isValid => throw _privateConstructorUsedError;
  List<String> get errors => throw _privateConstructorUsedError;

  /// Create a copy of CleanupValidationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CleanupValidationResultCopyWith<CleanupValidationResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CleanupValidationResultCopyWith<$Res> {
  factory $CleanupValidationResultCopyWith(
    CleanupValidationResult value,
    $Res Function(CleanupValidationResult) then,
  ) = _$CleanupValidationResultCopyWithImpl<$Res, CleanupValidationResult>;
  @useResult
  $Res call({bool isValid, List<String> errors});
}

/// @nodoc
class _$CleanupValidationResultCopyWithImpl<
  $Res,
  $Val extends CleanupValidationResult
>
    implements $CleanupValidationResultCopyWith<$Res> {
  _$CleanupValidationResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CleanupValidationResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? isValid = null, Object? errors = null}) {
    return _then(
      _value.copyWith(
            isValid: null == isValid
                ? _value.isValid
                : isValid // ignore: cast_nullable_to_non_nullable
                      as bool,
            errors: null == errors
                ? _value.errors
                : errors // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CleanupValidationResultImplCopyWith<$Res>
    implements $CleanupValidationResultCopyWith<$Res> {
  factory _$$CleanupValidationResultImplCopyWith(
    _$CleanupValidationResultImpl value,
    $Res Function(_$CleanupValidationResultImpl) then,
  ) = __$$CleanupValidationResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isValid, List<String> errors});
}

/// @nodoc
class __$$CleanupValidationResultImplCopyWithImpl<$Res>
    extends
        _$CleanupValidationResultCopyWithImpl<
          $Res,
          _$CleanupValidationResultImpl
        >
    implements _$$CleanupValidationResultImplCopyWith<$Res> {
  __$$CleanupValidationResultImplCopyWithImpl(
    _$CleanupValidationResultImpl _value,
    $Res Function(_$CleanupValidationResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CleanupValidationResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? isValid = null, Object? errors = null}) {
    return _then(
      _$CleanupValidationResultImpl(
        isValid: null == isValid
            ? _value.isValid
            : isValid // ignore: cast_nullable_to_non_nullable
                  as bool,
        errors: null == errors
            ? _value._errors
            : errors // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc

class _$CleanupValidationResultImpl implements _CleanupValidationResult {
  const _$CleanupValidationResultImpl({
    required this.isValid,
    final List<String> errors = const [],
  }) : _errors = errors;

  @override
  final bool isValid;
  final List<String> _errors;
  @override
  @JsonKey()
  List<String> get errors {
    if (_errors is EqualUnmodifiableListView) return _errors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_errors);
  }

  @override
  String toString() {
    return 'CleanupValidationResult(isValid: $isValid, errors: $errors)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CleanupValidationResultImpl &&
            (identical(other.isValid, isValid) || other.isValid == isValid) &&
            const DeepCollectionEquality().equals(other._errors, _errors));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    isValid,
    const DeepCollectionEquality().hash(_errors),
  );

  /// Create a copy of CleanupValidationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CleanupValidationResultImplCopyWith<_$CleanupValidationResultImpl>
  get copyWith =>
      __$$CleanupValidationResultImplCopyWithImpl<
        _$CleanupValidationResultImpl
      >(this, _$identity);
}

abstract class _CleanupValidationResult implements CleanupValidationResult {
  const factory _CleanupValidationResult({
    required final bool isValid,
    final List<String> errors,
  }) = _$CleanupValidationResultImpl;

  @override
  bool get isValid;
  @override
  List<String> get errors;

  /// Create a copy of CleanupValidationResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CleanupValidationResultImplCopyWith<_$CleanupValidationResultImpl>
  get copyWith => throw _privateConstructorUsedError;
}
