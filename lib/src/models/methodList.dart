import 'componentList.dart';

class MethodList {
  String method;
  String label;
  List<ComponentList> componentList;

  MethodList({
    this.method,
    this.label,
    this.componentList,
  });

  factory MethodList.fromJson(Map<String, dynamic> json) => MethodList(
    method: json["method"],
    label: json["label"],
    componentList: List<ComponentList>.from(json["componentList"].map((x) => ComponentList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "method": method,
    "label": label,
    "componentList": List<dynamic>.from(componentList.map((x) => x.toJson())),
  };
}