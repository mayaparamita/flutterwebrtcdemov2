import 'methodList.dart';
import 'outputImageList.dart';

class KtpModel {
  String status;
  String messageCode;
  String message;
  String id;
  List<MethodList> methodList;
  List<OutputImageList> outputImageList;

  KtpModel({
    this.status,
    this.messageCode,
    this.message,
    this.id,
    this.methodList,
    this.outputImageList,
  });

  factory KtpModel.fromJson(Map<String, dynamic> json) => KtpModel(
    status: json["status"],
    messageCode: json["messageCode"],
    message: json["message"],
    id: json["id"],
    methodList: List<MethodList>.from(json["methodList"].map((x) => MethodList.fromJson(x))),
    outputImageList: List<OutputImageList>.from(json["outputImageList"].map((x) => OutputImageList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "messageCode": messageCode,
    "message": message,
    "id": id,
    "methodList": List<dynamic>.from(methodList.map((x) => x.toJson())),
    "outputImageList": List<dynamic>.from(outputImageList.map((x) => x.toJson())),
  };
}
