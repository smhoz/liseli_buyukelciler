// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'acitivity_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityModel _$ActivityModelFromJson(Map<String, dynamic> json) =>
    ActivityModel(
      json['id'] as String,
      json['category_id'] as String,
      json['name'] as String,
      json['is_deleted'] as bool,
      const TimestampConverter().fromJson(json['created_at']),
    );

Map<String, dynamic> _$ActivityModelToJson(ActivityModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category_id': instance.category_id,
      'name': instance.name,
      'is_deleted': instance.is_deleted,
      'created_at': const TimestampConverter().toJson(instance.created_at),
    };
