// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'obd_device.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ObdDevice _$ObdDeviceFromJson(Map<String, dynamic> json) {
  return _ObdDevice.fromJson(json);
}

/// @nodoc
mixin _$ObdDevice {
  String get id => throw _privateConstructorUsedError;
  String get name =>
      throw _privateConstructorUsedError; // e.g., "My WiFi Dongle", "Scanner 1"
  String get host => throw _privateConstructorUsedError;
  int get port => throw _privateConstructorUsedError;
  bool get isLastConnected => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ObdDeviceCopyWith<ObdDevice> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ObdDeviceCopyWith<$Res> {
  factory $ObdDeviceCopyWith(ObdDevice value, $Res Function(ObdDevice) then) =
      _$ObdDeviceCopyWithImpl<$Res, ObdDevice>;
  @useResult
  $Res call(
      {String id, String name, String host, int port, bool isLastConnected});
}

/// @nodoc
class _$ObdDeviceCopyWithImpl<$Res, $Val extends ObdDevice>
    implements $ObdDeviceCopyWith<$Res> {
  _$ObdDeviceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? host = null,
    Object? port = null,
    Object? isLastConnected = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      host: null == host
          ? _value.host
          : host // ignore: cast_nullable_to_non_nullable
              as String,
      port: null == port
          ? _value.port
          : port // ignore: cast_nullable_to_non_nullable
              as int,
      isLastConnected: null == isLastConnected
          ? _value.isLastConnected
          : isLastConnected // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ObdDeviceImplCopyWith<$Res>
    implements $ObdDeviceCopyWith<$Res> {
  factory _$$ObdDeviceImplCopyWith(
          _$ObdDeviceImpl value, $Res Function(_$ObdDeviceImpl) then) =
      __$$ObdDeviceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id, String name, String host, int port, bool isLastConnected});
}

/// @nodoc
class __$$ObdDeviceImplCopyWithImpl<$Res>
    extends _$ObdDeviceCopyWithImpl<$Res, _$ObdDeviceImpl>
    implements _$$ObdDeviceImplCopyWith<$Res> {
  __$$ObdDeviceImplCopyWithImpl(
      _$ObdDeviceImpl _value, $Res Function(_$ObdDeviceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? host = null,
    Object? port = null,
    Object? isLastConnected = null,
  }) {
    return _then(_$ObdDeviceImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      host: null == host
          ? _value.host
          : host // ignore: cast_nullable_to_non_nullable
              as String,
      port: null == port
          ? _value.port
          : port // ignore: cast_nullable_to_non_nullable
              as int,
      isLastConnected: null == isLastConnected
          ? _value.isLastConnected
          : isLastConnected // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ObdDeviceImpl implements _ObdDevice {
  const _$ObdDeviceImpl(
      {required this.id,
      required this.name,
      required this.host,
      required this.port,
      this.isLastConnected = false});

  factory _$ObdDeviceImpl.fromJson(Map<String, dynamic> json) =>
      _$$ObdDeviceImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
// e.g., "My WiFi Dongle", "Scanner 1"
  @override
  final String host;
  @override
  final int port;
  @override
  @JsonKey()
  final bool isLastConnected;

  @override
  String toString() {
    return 'ObdDevice(id: $id, name: $name, host: $host, port: $port, isLastConnected: $isLastConnected)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ObdDeviceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.host, host) || other.host == host) &&
            (identical(other.port, port) || other.port == port) &&
            (identical(other.isLastConnected, isLastConnected) ||
                other.isLastConnected == isLastConnected));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, host, port, isLastConnected);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ObdDeviceImplCopyWith<_$ObdDeviceImpl> get copyWith =>
      __$$ObdDeviceImplCopyWithImpl<_$ObdDeviceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ObdDeviceImplToJson(
      this,
    );
  }
}

abstract class _ObdDevice implements ObdDevice {
  const factory _ObdDevice(
      {required final String id,
      required final String name,
      required final String host,
      required final int port,
      final bool isLastConnected}) = _$ObdDeviceImpl;

  factory _ObdDevice.fromJson(Map<String, dynamic> json) =
      _$ObdDeviceImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override // e.g., "My WiFi Dongle", "Scanner 1"
  String get host;
  @override
  int get port;
  @override
  bool get isLastConnected;
  @override
  @JsonKey(ignore: true)
  _$$ObdDeviceImplCopyWith<_$ObdDeviceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
