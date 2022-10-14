class Story {
  final String id;
  final String title;
  final String fileName;
  final String quality;
  final String slug;
  final int duration;

  Story({
    required this.id,
    required this.fileName,
    required this.quality,
    required this.duration,
    required this.slug,
    required this.title,
  });

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['quality'] = quality;
    map['duration'] = duration;
    map['slug'] = slug;
    map['fileName'] = fileName;
    return map;
  }
}
