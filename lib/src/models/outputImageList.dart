

class OutputImageList {
  String tag;
  String imageUrl;

  OutputImageList({
    this.tag,
    this.imageUrl,
  });

  factory OutputImageList.fromJson(Map<String, dynamic> json) => OutputImageList(
    tag: json["tag"],
    imageUrl: json["imageUrl"],
  );

  Map<String, dynamic> toJson() => {
    "tag": tag,
    "imageUrl": imageUrl,
  };
}