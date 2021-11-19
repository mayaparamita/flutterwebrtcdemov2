//import 'package:simple_app/nodeflux/models/nodeflux_result_model.dart';
import 'nodeflux_job_model.dart';
import 'package:json_annotation/json_annotation.dart';

class NodefluxDataModel {
  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  NodefluxJobModel job;

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  String message;

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  bool ok;

  NodefluxDataModel({
    this.job,
    this.message,
    this.ok,
  });

  factory NodefluxDataModel.fromJson(Map<String, dynamic> json) => NodefluxDataModel(
    message: json["message"],
    ok: json["ok"],
    job: NodefluxJobModel.fromJson(json["job"]),
  );

  Map<String, dynamic> toJson() => {
    "job": job,
    "message": message,
    "ok": ok,
    //"result": List<dynamic>.from(result.map((x) => x.toJson())),
    "job": job.toJson(),
  };

  factory NodefluxDataModel.fromJson0(Map<String, dynamic> json) => NodefluxDataModel(
    message: json["message"],
    ok: json["ok"],
    job: NodefluxJobModel.fromJson0(json["job"]),
  );

  Map<String, dynamic> toJson0() => {
    "job": job,
    "message": message,
    "ok": ok,
    //"result": List<dynamic>.from(result.map((x) => x.toJson())),
    "job": job.toJson(),
  };

  factory NodefluxDataModel.fromJson00(Map<String, dynamic> json) => NodefluxDataModel(
    message: json["message"],
    ok: json["ok"],
    //job: NodefluxJobModel.fromJson0(json["job"]),
  );

  Map<String, dynamic> toJson00() => {
    //"job": job,
    "message": message,
    "ok": ok,
    //"result": List<dynamic>.from(result.map((x) => x.toJson())),
    //"job": job.toJson(),
  };

  // never been used?
  factory NodefluxDataModel.fromJsonForMatchLiveness(Map<String, dynamic> json) => NodefluxDataModel(
    message: json["message"],
    ok: json["ok"],
    job: NodefluxJobModel.fromJsonForMatchLiveness(json["job"]),
  );

  Map<String, dynamic> toJsonForMatchLiveness() => {
    "message": message,
    "ok": ok,
    "job": job.toJson(),
  };
}