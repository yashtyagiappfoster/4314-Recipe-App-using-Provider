class RecipeModel {
  String? image;
  String? url;
  String? source;
  String? label;

  RecipeModel({this.image, this.url, this.source, this.label});

  factory RecipeModel.fromMap(Map<String, dynamic> jsonData) {
    return RecipeModel(
      url: jsonData["url"],
      label: jsonData["label"],
      image: jsonData["image"],
      source: jsonData["source"],
    );
  }
}
