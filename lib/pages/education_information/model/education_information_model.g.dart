// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'education_information_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EducationInformationModel _$EducationInformationModelFromJson(
        Map<String, dynamic> json) =>
    EducationInformationModel(
      json['id'] as String?,
      json['class_name'] as String?,
      json['school_name'] as String?,
      json['state_name'] as String?,
      json['country_name'] as String?,
      json['country_code'] as String?,
      const DocumentReferenceConverter().fromJson(json['user_ref']),
      (json['date_start'] as num?)?.toInt(),
      (json['date_end'] as num?)?.toInt(),
      const TimestampConverter().fromJson(json['created_at']),
      json['is_deleted'] as bool?,
    );

Map<String, dynamic> _$EducationInformationModelToJson(
        EducationInformationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'class_name': instance.class_name,
      'school_name': instance.school_name,
      'state_name': instance.state_name,
      'country_name': instance.country_name,
      'country_code': instance.country_code,
      'user_ref': const DocumentReferenceConverter().toJson(instance.user_ref),
      'date_start': instance.date_start,
      'date_end': instance.date_end,
      'created_at': const TimestampConverter().toJson(instance.created_at),
      'is_deleted': instance.is_deleted,
    };
