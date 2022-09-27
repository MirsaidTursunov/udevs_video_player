
class Movie {
  String title;
  String description;
  String image;
  Map<String, String> resolutions;

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['title'] = title;
    map['description'] = description;
    map['image'] = image;
    map['resolutions'] = resolutions;
    return map;
  }

  @override
  String toString() {
    return 'Movie{title: $title, description: $description, image: $image, resolutions: $resolutions}';
  }

  Movie({
    required this.title,
    required this.description,
    required this.image,
    required this.resolutions,
  });
}
