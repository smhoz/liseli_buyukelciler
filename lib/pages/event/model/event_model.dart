import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event_model.g.dart';

class TimestampConverter implements JsonConverter<Timestamp?, Object?> {
  const TimestampConverter();

  @override
  Timestamp? fromJson(Object? json) {
    if (json is Timestamp) {
      return json;
    } else if (json is int) {
      return Timestamp.fromMillisecondsSinceEpoch(json);
    } else if (json is Map<String, dynamic>) {
      if (json.containsKey('_seconds') && json.containsKey('_nanoseconds')) {
        final int seconds = json['_seconds'];
        final int nanoseconds = json['_nanoseconds'];
        return Timestamp(seconds, nanoseconds);
      }
    }
    return null;
  }

  @override
  Object? toJson(Timestamp? object) {
    if (object == null) return null;
    return {'_seconds': object.seconds, '_nanoseconds': object.nanoseconds};
  }
}

@JsonSerializable()
class EventModel {
  final String id;
  final String address;
  final String address_url;

  @TimestampConverter()
  final Timestamp? created_at;
  @TimestampConverter()
  final Timestamp? event_date;
  final String event_image;
  final String explanation;
  final bool is_deleted;
  final String title;
  final bool is_completed;
  final String category_id;
  final String state_id;

  EventModel(
    this.id,
    this.address,
    this.address_url,
    this.created_at,
    this.event_date,
    this.event_image,
    this.explanation,
    this.is_deleted,
    this.title,
    this.is_completed,
    this.category_id,
    this.state_id,
  );

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);

  Map<String, dynamic> toJson() => _$EventModelToJson(this);
}
