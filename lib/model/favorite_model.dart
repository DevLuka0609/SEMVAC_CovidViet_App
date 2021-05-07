import 'dart:convert';

class FavoriteModel {
  final int id;
  final String title;
  final String description;
  final String images;
  final String date;
  final String favors;
  final String opens;
  final String shares;
  static final columns = [
    "id",
    "title",
    "description",
    "image",
    "date",
    "favors",
    "opens",
    "shares"
  ];

  FavoriteModel(this.id, this.title, this.description, this.images, this.date,
      this.favors, this.opens, this.shares);

  factory FavoriteModel.fromMap(Map<String, dynamic> data) {
    return FavoriteModel(
      data['id'],
      data['title'],
      data['description'],
      data['images'],
      data['date'],
      data['favors'],
      data['opens'],
      data['shares'],
    );
  }
  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "description": description,
        "images": images,
        "date": date,
        "favors": favors,
        "opens": opens,
        "shares": shares,
      };
}

FavoriteModel favorsFromJson(String str) {
  final jsonData = json.decode(str);
  return FavoriteModel.fromMap(jsonData);
}

String favorstToJson(FavoriteModel data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}
