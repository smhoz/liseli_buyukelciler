// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StateModel _$StateModelFromJson(Map<String, dynamic> json) => StateModel(
      json['id'] as String,
      json['name'] as String,
      json['is_deleted'] as bool,
      const TimestampConverter().fromJson(json['created_at']),
    );

Map<String, dynamic> _$StateModelToJson(StateModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'is_deleted': instance.is_deleted,
      'created_at': const TimestampConverter().toJson(instance.created_at),
    };
