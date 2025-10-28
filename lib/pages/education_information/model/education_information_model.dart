import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'education_information_model.g.dart';

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

class DocumentReferenceConverter implements JsonConverter<DocumentReference<Object?>, Object?> {
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
class EducationInformationModel {
  final String? id;
  final String? class_name;
  final String? school_name;
  final String? state_name;
  final String? country_name;
  final String? country_code;
  @DocumentReferenceConverter()
  final DocumentReference<Object?> user_ref;
  final int? date_start;
  final int? date_end;
  @TimestampConverter()
  final Timestamp? created_at;
  final bool? is_deleted;

  EducationInformationModel(
    this.id,
    this.class_name,
    this.school_name,
    this.state_name,
    this.country_name,
    this.country_code,
    this.user_ref,
    this.date_start,
    this.date_end,
    this.created_at,
    this.is_deleted,
  );

  factory EducationInformationModel.fromJson(Map<String, dynamic> json) =>
      _$EducationInformationModelFromJson(json);

  Map<String, dynamic> toJson() => _$EducationInformationModelToJson(this);
}
