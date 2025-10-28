// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventModel _$EventModelFromJson(Map<String, dynamic> json) => EventModel(
      json['id'] as String,
      json['address'] as String,
      json['address_url'] as String,
      const TimestampConverter().fromJson(json['created_at']),
      const TimestampConverter().fromJson(json['event_date']),
      json['event_image'] as String,
      json['explanation'] as String,
      json['is_deleted'] as bool,
      json['title'] as String,
      json['is_completed'] as bool,
      json['category_id'] as String,
      json['state_id'] as String,
    );

Map<String, dynamic> _$EventModelToJson(EventModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'address': instance.address,
      'address_url': instance.address_url,
      'created_at': const TimestampConverter().toJson(instance.created_at),
      'event_date': const TimestampConverter().toJson(instance.event_date),
      'event_image': instance.event_image,
      'explanation': instance.explanation,
      'is_deleted': instance.is_deleted,
      'title': instance.title,
      'is_completed': instance.is_completed,
      'category_id': instance.category_id,
      'state_id': instance.state_id,
    };
