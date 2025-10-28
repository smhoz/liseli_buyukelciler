import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'working_life_model.g.dart';

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
class WorkingLifeModel {
  final String id;
  @DocumentReferenceConverter()
  final DocumentReference<Object?> user_ref;
  final String company_name;
  final String task;
  @TimestampConverter()
  final Timestamp? date_start;
  @TimestampConverter()
  final Timestamp? date_end;
  final bool is_working;
  @TimestampConverter()
  final Timestamp? created_at;
  final bool is_deleted;

  WorkingLifeModel(
      this.id,
      this.user_ref,
      this.company_name,
      this.task,
      this.date_start,
      this.date_end,
      this.is_working,
      this.created_at,
      this.is_deleted);

  factory WorkingLifeModel.fromJson(json) => _$WorkingLifeModelFromJson(json);

  Map<String, dynamic> toJson() => _$WorkingLifeModelToJson(this);
}
