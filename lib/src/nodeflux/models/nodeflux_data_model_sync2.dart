//import 'package:simple_app/nodeflux/models/nodeflux_result_model.dart';
import 'nodeflux_job_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'nodeflux_result2_model.dart';

class NodefluxDataModelSync2 {
  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  String analytic_type;

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  String job_id;

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  String message;

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  bool ok;

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  List<NodefluxResult2Model> result;

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  String status;

  // @JsonKey(defaultValue: null)
  // @JsonKey(required: false)
  // String code;

  NodefluxDataModelSync2({
    this.analytic_type,
    this.job_id,
    this.message,
    this.ok,
    this.status,
    this.result,
    //this.code
  });

  // fourth, if step 3 passed (face liveness: true), check face_match
  factory NodefluxDataModelSync2.fromJson(Map<String, dynamic> json) => NodefluxDataModelSync2(
    analytic_type: json["analytic_type"],
    job_id: json["job_id"],
    message: json["message"],
    ok: json["ok"],
    status: json["status"],
    result: List<NodefluxResult2Model>.from(json["result"].map((x) => NodefluxResult2Model.fromJsonForMatchLiveness(x))), // jalan (tp gak jalan kalo kosong)

  );

  Map<String, dynamic> toJson() => {
    "analytic_type":analytic_type,
    "job_id": job_id,
    "message": message,
    "ok": ok,
    "status": status,
    "result": List<dynamic>.from(result.map((x) => x.toJsonForMatchLiveness())), // jalan (tp gak jalan kalo kosong)
  };

  // third, check liveness > live
  // if liveness > live: true -> check face match (fromJson)
  // if liveness > live: false -> berhenti
  factory NodefluxDataModelSync2.fromJson2(Map<String, dynamic> json) => NodefluxDataModelSync2(
    analytic_type: json["analytic_type"],
    job_id: json["job_id"],
    message: json["message"],
    ok: json["ok"],
    status: json["status"],
    result: List<NodefluxResult2Model>.from(json["result"].map((x) => NodefluxResult2Model.fromJsonForMatchLiveness(x))), // jalan (tp gak jalan kalo kosong)

  );

  Map<String, dynamic> toJson2() => {
    "analytic_type":analytic_type,
    "job_id": job_id,
    "message": message,
    "ok": ok,
    "status": status,
    "result": List<dynamic>.from(result.map((x) => x.toJsonForMatchLiveness())), // jalan (tp gak jalan kalo kosong)
  };

  factory NodefluxDataModelSync2.fromJson1(Map<String, dynamic> json) => NodefluxDataModelSync2(
    analytic_type: json["analytic_type"],
    job_id: json["job_id"],
    message: json["message"],
    ok: json["ok"],
    status: json["status"],
    result: List<NodefluxResult2Model>.from(json["result"].map((x) => NodefluxResult2Model.fromJsonForLiveness(x))), // jalan (tp gak jalan kalo kosong)

  );

  Map<String, dynamic> toJson1() => {
    "analytic_type":analytic_type,
    "job_id": job_id,
    "message": message,
    "ok": ok,
    "status": status,
    "result": List<dynamic>.from(result.map((x) => x.toJsonForLiveness())), // jalan (tp gak jalan kalo kosong)
  };

  // second, check status
  // if status: incompleted -> stop
  // if status: success -> check liveness > live fromJson0
  factory NodefluxDataModelSync2.fromJson00(Map<String, dynamic> json) => NodefluxDataModelSync2(
    analytic_type: json["analytic_type"],
    job_id: json["job_id"],
    message: json["message"],
    ok: json["ok"],
    status: json["status"],
    //result: List<NodefluxResult2Model>.from(json["result"].map((x) => NodefluxResult2Model.fromJsonForLiveness(x))), // jalan (tp gak jalan kalo kosong)
  );

  Map<String, dynamic> toJson00() => {
    "analytic_type":analytic_type,
    "job_id": job_id,
    "message": message,
    "ok": ok,
    "status": status,
    //"result": List<dynamic>.from(result.map((x) => x.toJsonForLiveness())), // jalan (tp gak jalan kalo kosong)
  };

  // first, check if ok true or false and second,
  // if ok true, check status is success or others;
  // if ok false, there is no status
  factory NodefluxDataModelSync2.fromJson000(Map<String, dynamic> json) => NodefluxDataModelSync2(
    message: json["message"],
    ok: json["ok"],
    //code: json["code"]
    //status: json["status"]
    //job: NodefluxJobModel.fromJson0(json["job"]),
  );

  Map<String, dynamic> toJson000() => {
    //"job": job,
    "message": message,
    "ok": ok,
    //"code":code
    //"status": status
    //"result": List<dynamic>.from(result.map((x) => x.toJson())),
    //"job": job.toJson(),
  };
}