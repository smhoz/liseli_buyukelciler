// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'school_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SchoolModel _$SchoolModelFromJson(Map<String, dynamic> json) => SchoolModel(
      json['id'] as String,
      json['state_id'] as String,
      json['name'] as String,
      json['is_education_type'] as bool,
      json['is_deleted'] as bool,
      const TimestampConverter().fromJson(json['created_at']),
    );

Map<String, dynamic> _$SchoolModelToJson(SchoolModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'state_id': instance.state_id,
      'name': instance.name,
      'is_education_type': instance.is_education_type,
      'is_deleted': instance.is_deleted,
      'created_at': const TimestampConverter().toJson(instance.created_at),
    };
