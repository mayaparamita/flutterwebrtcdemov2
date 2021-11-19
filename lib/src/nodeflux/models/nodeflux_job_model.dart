import 'nodeflux_result_model.dart';
import 'package:json_annotation/json_annotation.dart';

class NodefluxJobModel {
  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  String id;

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  NodefluxResultModel result;

  NodefluxJobModel({
    this.id,
    this.result,
  });

  factory NodefluxJobModel.fromJson(Map<String, dynamic> json) => NodefluxJobModel(
    id: json["id"],
    result: NodefluxResultModel.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    //"result": List<dynamic>.from(result.map((x) => x.toJson())),
    "result": result.toJson(),
  };

  factory NodefluxJobModel.fromJson0(Map<String, dynamic> json) => NodefluxJobModel(
    id: json["id"],
    result: NodefluxResultModel.fromJson0(json["result"]),
  );

  Map<String, dynamic> toJson0() => {
    "id": id,
    //"result": List<dynamic>.from(result.map((x) => x.toJson())),
    "result": result.toJson(),
  };

  factory NodefluxJobModel.fromJsonForMatchLiveness(Map<String, dynamic> json) => NodefluxJobModel(
    id: json["id"],
    result: NodefluxResultModel.fromJsonForMatchLiveness(json["result"]),
  );

  Map<String, dynamic> toJsonForMatchLiveness() => {
    "id": id,
    //"result": List<dynamic>.from(result.map((x) => x.toJson())),
    "result": result.toJson(),
  };
}