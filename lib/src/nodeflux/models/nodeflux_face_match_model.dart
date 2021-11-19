import 'package:json_annotation/json_annotation.dart';

class NodefluxFaceMatchModel {
  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  bool match;

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  double similarity;

  NodefluxFaceMatchModel({
    this.match,
    this.similarity,
  });

  factory NodefluxFaceMatchModel.fromJson(Map<String, dynamic> json) => NodefluxFaceMatchModel(
    match: json["match"],
    similarity: json["similarity"],
  );

  Map<String, dynamic> toJson() => {
    "match": match,
    "similarity": similarity,
  };
}