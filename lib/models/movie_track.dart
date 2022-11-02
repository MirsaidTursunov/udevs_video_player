class MovieTrack {
  final String episodeKey;
  final String element;
  final bool isMegogo;
  final String movieKey;
  final String seasonKey;
  final int seconds;
  final String userId;

  MovieTrack({
    required this.episodeKey,
    required this.element,
    required this.seasonKey,
    required this.isMegogo,
    required this.movieKey,
    required this.seconds,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['episode_key'] = episodeKey;
    map['is_megogo'] = isMegogo;
    map['movie_key'] = movieKey;
    map['season_key'] = seasonKey;
    map['seconds'] = seconds;
    map['user_id'] = userId;
    map['element'] = element;
    return map;
  }
}
