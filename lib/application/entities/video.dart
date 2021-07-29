class Video {
  final String name;
  final String fileName;
  final String slug;
  final String? picture;

  Video({
    required this.name,
    required this.fileName,
    required this.slug,
    this.picture
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      name: json['name'],
      fileName: json['fileName'],
      slug: json['slug'],
      picture: json['picture'],
    );
  }

  static List<Video> collectionFromJson(List<dynamic> json) {
    return json.map((e) => Video.fromJson(e)).toList();
  }
}
