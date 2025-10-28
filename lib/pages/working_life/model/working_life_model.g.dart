// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'working_life_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkingLifeModel _$WorkingLifeModelFromJson(Map<String, dynamic> json) =>
    WorkingLifeModel(
      json['id'] as String,
      const DocumentReferenceConverter().fromJson(json['user_ref']),
      json['company_name'] as String,
      json['task'] as String,
      const TimestampConverter().fromJson(json['date_start']),
      const TimestampConverter().fromJson(json['date_end']),
      json['is_working'] as bool,
      const TimestampConverter().fromJson(json['created_at']),
      json['is_deleted'] as bool,
    );

Map<String, dynamic> _$WorkingLifeModelToJson(WorkingLifeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_ref': const DocumentReferenceConverter().toJson(instance.user_ref),
      'company_name': instance.company_name,
      'task': instance.task,
      'date_start': const TimestampConverter().toJson(instance.date_start),
      'date_end': const TimestampConverter().toJson(instance.date_end),
      'is_working': instance.is_working,
      'created_at': const TimestampConverter().toJson(instance.created_at),
      'is_deleted': instance.is_deleted,
    };
