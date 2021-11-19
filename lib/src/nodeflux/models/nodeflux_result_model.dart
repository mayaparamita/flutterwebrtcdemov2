import 'nodeflux_result2_model.dart';
import 'package:json_annotation/json_annotation.dart';

class NodefluxResultModel {
  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  String status;

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  String analytic_type;

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  List<NodefluxResult2Model> result;
  //NodefluxResult2Model result;

  NodefluxResultModel({
    this.status,
    this.analytic_type,
    this.result,
  });


  factory NodefluxResultModel.fromJson(Map<String, dynamic> json) => NodefluxResultModel(
    status: json["status"],
    analytic_type: json["analytic_type"],
    result: List<NodefluxResult2Model>.from(json["result"].map((x) => NodefluxResult2Model.fromJson(x))), // jalan (tp gak jalan kalo kosong)
    //result: NodefluxResult2Model.fromJson(json["result"]), // gak jalan
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "analytic_type": analytic_type,
    "result": List<dynamic>.from(result.map((x) => x.toJson())), // jalan (tp gak jalan kalo kosong)
    //"result":result.toJson(), // gak jalan
  };

  factory NodefluxResultModel.fromJson0(Map<String, dynamic> json) => NodefluxResultModel(
    status: json["status"],
    analytic_type: json["analytic_type"],
  );

  Map<String, dynamic> toJson0() => {
    "status": status,
    "analytic_type": analytic_type,
  };

  factory NodefluxResultModel.fromJsonForMatchLiveness(Map<dynamic, dynamic> json) => NodefluxResultModel(
    status: json["status"],
    analytic_type: json["analytic_type"],
    result: List<NodefluxResult2Model>.from(json["result"].map((x) => NodefluxResult2Model.fromJsonForMatchLiveness(x))), // gak jalan
    //result: List<NodefluxResult2LivenessModel>.from(json["result"].map((x) => NodefluxResult2LivenessModel.fromJson(x))), // gak jalan
    //result: List<NodefluxResult2LivenessModel>.fromJson(json["result"]), // jalan

  );

  Map<String, dynamic> toJsonForMatchLiveness() => {
    "status": status,
    "analytic_type": analytic_type,
    "result": List<dynamic>.from(result.map((x) => x.toJson())), // gak jalan
    //"result":result.toJson(), // jalan
  };
}