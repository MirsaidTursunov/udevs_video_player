class TvChannel {
  const TvChannel({
    required this.id,
    required this.image,
    required this.name,
    required this.resolutions,
    required this.paymentType,
    required this.hasAccess,
  });

  final String id;
  final String image;
  final String name;
  final Map<String, String> resolutions;
  final String paymentType;
  final bool hasAccess;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['image'] = image;
    map['name'] = name;
    map['resolutions'] = resolutions;
    map['paymentType'] = paymentType;
    map['hacAccess'] = hasAccess;
    return map;
  }
}
