class Movie {
  Movie({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.resolutions,
  });

  String id;
  String title;
  String description;
  String image;
  Map<String, String> resolutions;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['description'] = description;
    map['image'] = image;
    map['resolutions'] = resolutions;
    return map;
  }

  @override
  String toString() =>
      'Movie{id: $id, title: $title, description: $description, image: $image, resolutions: $resolutions}';
}
