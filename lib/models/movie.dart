
class Movie {
  String id;
  String title;
  String description;
  String image;
  int duration;
  Map<String, String> resolutions;

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['description'] = description;
    map['image'] = image;
    map['duration'] = duration;
    map['resolutions'] = resolutions;
    return map;
  }

  @override
  String toString() {
    return 'Movie{id: $id, title: $title, description: $description, image: $image, duration: $duration, resolutions: $resolutions}';
  }

  Movie({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.duration,
    required this.resolutions,
  });
}
