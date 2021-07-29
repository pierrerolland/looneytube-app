import 'package:looneytube/application/entities/video.dart';

class Category {
  final String name;
  final String slug;
  final String? picture;
  final List<Video>? videos;

  Category({
    required this.name,
    required this.slug,
    this.picture,
    this.videos
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['name'],
      slug: json['slug'],
      picture: json['picture'],
      videos: json['videos'] != null ? Video.collectionFromJson(json['videos']) : null,
    );
  }

  static List<Category> collectionFromJson(List<dynamic> json) {
    return json.map((e) => Category.fromJson(e)).toList();
  }
}
