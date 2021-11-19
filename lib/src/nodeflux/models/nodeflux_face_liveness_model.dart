import 'package:json_annotation/json_annotation.dart';

class NodefluxFaceLivenessModel {
  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  bool live;

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  double liveness;

  NodefluxFaceLivenessModel({
    this.live,
    this.liveness,
  });

  factory NodefluxFaceLivenessModel.fromJson(Map<String, dynamic> json) => NodefluxFaceLivenessModel(
    live: json["live"],
    liveness: json["liveness"],
  );

  Map<String, dynamic> toJson() => {
    "live": live,
    "liveness": liveness,
  };
}