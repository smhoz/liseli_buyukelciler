import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'activity_model.g.dart';

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
    return {
      '_seconds': object.seconds,
      '_nanoseconds': object.nanoseconds,
    };
  }
}

class DocumentReferenceConverter
    implements JsonConverter<DocumentReference<Object?>, Object?> {
  const DocumentReferenceConverter();

  @override
  DocumentReference<Object?> fromJson(Object? json) {
    if (json is DocumentReference<Object?>) {
      return json;
    } else {
      throw Exception('Expected DocumentReference, got $json');
    }
  }

  @override
  Object? toJson(DocumentReference<Object?> object) {
    return object;
  }
}

@JsonSerializable()
class ActivityModel {
  final String id;
  final String category_id;
  final String name;
  final bool is_deleted;
  @TimestampConverter()
  final Timestamp? created_at;

  ActivityModel(
    this.id,
    this.category_id,
    this.name,
    this.is_deleted,
    this.created_at,
  );

  factory ActivityModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityModelFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityModelToJson(this);
}
