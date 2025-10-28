// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badge_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BadgeModel _$BadgeModelFromJson(Map<String, dynamic> json) => BadgeModel(
      json['id'] as String,
      json['name'] as String,
      json['file_url'] as String,
      const TimestampConverter().fromJson(json['created_at']),
      json['is_deleted'] as bool,
    );

Map<String, dynamic> _$BadgeModelToJson(BadgeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'file_url': instance.file_url,
      'created_at': const TimestampConverter().toJson(instance.created_at),
      'is_deleted': instance.is_deleted,
    };
