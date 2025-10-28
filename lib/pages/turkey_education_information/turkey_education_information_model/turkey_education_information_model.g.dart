// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'turkey_education_information_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TurkeyEducationInformationModel _$TurkeyEducationInformationModelFromJson(
        Map<String, dynamic> json) =>
    TurkeyEducationInformationModel(
      json['id'] as String?,
      const DocumentReferenceConverter().fromJson(json['user_ref']),
      json['chapter'] as String?,
      (json['date_entry'] as num?)?.toInt(),
      (json['date_graduation'] as num?)?.toInt(),
      const TimestampConverter().fromJson(json['created_at']),
      json['is_continues'] as bool?,
      json['is_deleted'] as bool?,
      json['is_education_type'] as bool?,
      json['school_name'] as String?,
    );

Map<String, dynamic> _$TurkeyEducationInformationModelToJson(
        TurkeyEducationInformationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_ref': const DocumentReferenceConverter().toJson(instance.user_ref),
      'chapter': instance.chapter,
      'date_entry': instance.date_entry,
      'date_graduation': instance.date_graduation,
      'created_at': const TimestampConverter().toJson(instance.created_at),
      'is_continues': instance.is_continues,
      'is_deleted': instance.is_deleted,
      'is_education_type': instance.is_education_type,
      'school_name': instance.school_name,
    };
