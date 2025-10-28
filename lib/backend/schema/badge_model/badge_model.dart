import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sosyal_medya/pages/event/model/event_model.dart';

part 'badge_model.g.dart';

@JsonSerializable()
class BadgeModel {
  final String id;
  final String name;
  final String file_url;
  @TimestampConverter()
  final Timestamp? created_at;
  final bool is_deleted;

  BadgeModel(
    this.id,
    this.name,
    this.file_url,
    this.created_at,
    this.is_deleted,
  );

  factory BadgeModel.fromJson(Map<String, dynamic> json) =>
      _$BadgeModelFromJson(json);

  Map<String, dynamic> toJson() => _$BadgeModelToJson(this);
}
