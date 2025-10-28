import 'package:json_annotation/json_annotation.dart';
import 'package:sosyal_medya/backend/backend.dart';

part 'turkey_education_information_model.g.dart';

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
class TurkeyEducationInformationModel {
  final String? id;
  @DocumentReferenceConverter()
  final DocumentReference<Object?> user_ref;
  final String? chapter;
  final int? date_entry;
  final int? date_graduation;
  @TimestampConverter()
  final Timestamp? created_at;
  final bool? is_continues;
  final bool? is_deleted;
  final bool? is_education_type;
  final String? school_name;

  TurkeyEducationInformationModel(
      this.id,
      this.user_ref,
      this.chapter,
      this.date_entry,
      this.date_graduation,
      this.created_at,
      this.is_continues,
      this.is_deleted,
      this.is_education_type,
      this.school_name);

  factory TurkeyEducationInformationModel.fromJson(Map<String, dynamic> json) =>
      _$TurkeyEducationInformationModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$TurkeyEducationInformationModelToJson(this);
}
