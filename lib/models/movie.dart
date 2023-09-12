class Movie {

  Movie({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.duration,
    required this.resolutions,
  });
  String id;
  String title;
  String description;
  String image;
  int duration;
  Map<String, String> resolutions;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['description'] = description;
    map['image'] = image;
    map['duration'] = duration;
    map['resolutions'] = resolutions;
    return map;
  }

  @override
  String toString() => 'Movie{id: $id, title: $title, description: $description, image: $image, duration: $duration, resolutions: $resolutions}';
}

class Channel {

  const Channel({
    required this.id,
    required this.image,
    required this.name,
    required this.resolutions,
  });
  final String id;
  final String name;
  final String image;
  final Map<String, String> resolutions;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['image'] = image;
    map['name'] = name;
    map['resolutions'] = resolutions;
    return map;
  }

  @override
  String toString() => 'Channel{id: $id, image: $image, resolutions: $resolutions, name: $name}';
}
