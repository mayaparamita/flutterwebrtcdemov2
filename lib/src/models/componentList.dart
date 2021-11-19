class ComponentList {
  String code;
  String label;
  String value;
  String imageUrl;
  dynamic refImageUrl;

  ComponentList({
    this.code,
    this.label,
    this.value,
    this.imageUrl,
    this.refImageUrl,
  });

  factory ComponentList.fromJson(Map<String, dynamic> json) => ComponentList(
    code: json["code"],
    label: json["label"],
    value: json["value"],
    imageUrl: json["imageUrl"],
    refImageUrl: json["refImageUrl"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "label": label,
    "value": value,
    "imageUrl": imageUrl,
    "refImageUrl": refImageUrl,
  };
}