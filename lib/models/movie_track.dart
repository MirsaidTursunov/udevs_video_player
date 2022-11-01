class MovieTrack {
  MovieTrack({
    String? episodeKey,
    String? seasonKey,
    bool? isMegogo,
    String? movieKey,
    int? seconds,
    String? userId,
  }) {
    _episodeKey = episodeKey;
    _isMegogo = isMegogo;
    _movieKey = movieKey;
    _seasonKey = seasonKey;
    _seconds = seconds;
    _userId = userId;
  }

  MovieTrack.fromJson(dynamic json) {
    _episodeKey = json['episode_key'];
    _isMegogo = json['is_megogo'];
    _movieKey = json['movie_key'];
    _seasonKey = json['season_key'];
    _seconds = json['seconds'];
    _userId = json['user_id'];
  }

  String? _episodeKey;
  bool? _isMegogo;
  String? _movieKey;
  String? _seasonKey;
  int? _seconds;
  String? _userId;

  String? get episodeKey => _episodeKey;

  bool? get isMegogo => _isMegogo;

  String? get movieKey => _movieKey;

  String? get seasonKey => _seasonKey;

  num? get seconds => _seconds;

  String? get userId => _userId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['episode_key'] = _episodeKey;
    map['is_megogo'] = _isMegogo;
    map['movie_key'] = _movieKey;
    map['season_key'] = _seasonKey;
    map['seconds'] = _seconds;
    map['user_id'] = _userId;
    return map;
  }
}
