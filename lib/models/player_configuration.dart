import 'dart:core';

import 'package:udevs_video_player/models/movie_track.dart';
import 'package:udevs_video_player/models/programs_info.dart';
import 'package:udevs_video_player/models/season.dart';
import 'package:udevs_video_player/models/story.dart';

class PlayerConfiguration {
  Map<String, String> initialResolution;
  Map<String, String> resolutions;
  List<Story> story;
  MovieTrack? movieTrack;
  String qualityText;
  PlayerType type;
  String platform;
  String speedText;
  String closeText;
  String seasonText;
  int lastPosition;
  int storyIndex;
  String title;
  String episodeButtonText;
  String storyButtonText;
  String nextButtonText;
  List<Season> seasons;
  String tvProgramsText;
  List<ProgramsInfo> programsInfoList;
  bool showController;
  bool playVideoFromAsset;
  String assetPath;
  int seasonIndex;
  int episodeIndex;
  bool isMegogo;
  bool isPremier;
  String videoId;
  String sessionId;
  String megogoAccessToken;
  String authorization;
  String autoText;
  String baseUrl;

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['initialResolution'] = initialResolution;
    map['resolutions'] = resolutions;
    map['qualityText'] = qualityText;
    map['speedText'] = speedText;
    map['type'] = type.name;
    map['lastPosition'] = lastPosition;
    map['title'] = title;
    map['platform'] = platform;
    map['episodeButtonText'] = episodeButtonText;
    map['nextButtonText'] = nextButtonText;
    map['seasons'] = seasons.map((v) => v.toJson()).toList();
    map['tvProgramsText'] = tvProgramsText;
    map['programsInfoList'] = programsInfoList.map((v) => v.toJson()).toList();
    map['showController'] = showController;
    map['playVideoFromAsset'] = playVideoFromAsset;
    map['assetPath'] = assetPath;
    map['seasonIndex'] = seasonIndex;
    map['episodeIndex'] = episodeIndex;
    map['isMegogo'] = isMegogo;
    map['isPremier'] = isPremier;
    map['videoId'] = videoId;
    map['sessionId'] = sessionId;
    map['megogoAccessToken'] = megogoAccessToken;
    map['authorization'] = authorization;
    map['autoText'] = autoText;
    map['baseUrl'] = baseUrl;
    map['story'] = story;
    map['storyButtonText'] = storyButtonText;
    map['closeText'] = closeText;
    map['seasonText'] = seasonText;
    map['storyIndex'] = storyIndex;
    map['movieTrack'] = movieTrack?.toJson();
    return map;
  }

  @override
  String toString() {
    return 'PlayerConfiguration{initialResolution: $initialResolution, resolutions: $resolutions, qualityText: $qualityText, speedText: $speedText, lastPosition: $lastPosition, title: $title, episodeButtonText: $episodeButtonText, nextButtonText: $nextButtonText, seasons: $seasons, tvProgramsText: $tvProgramsText, programsInfoList: $programsInfoList, showController: $showController, playVideoFromAsset: $playVideoFromAsset, assetPath: $assetPath, seasonIndex: $seasonIndex, episodeIndex: $episodeIndex, isMegogo: $isMegogo, isPremier: $isPremier, videoId: $videoId, sessionId: $sessionId, megogoAccessToken: $megogoAccessToken, authorization: $authorization, autoText: $autoText baseUrl: $baseUrl}';
  }

  PlayerConfiguration({
    required this.type,
    required this.initialResolution,
    required this.seasonText,
    required this.storyIndex,
    required this.resolutions,
    required this.qualityText,
    required this.platform,
    this.movieTrack,
    required this.speedText,
    required this.lastPosition,
    required this.title,
    required this.episodeButtonText,
    required this.nextButtonText,
    required this.seasons,
    required this.tvProgramsText,
    required this.programsInfoList,
    required this.showController,
    required this.playVideoFromAsset,
    required this.assetPath,
    required this.seasonIndex,
    required this.episodeIndex,
    required this.isMegogo,
    required this.isPremier,
    required this.videoId,
    required this.sessionId,
    required this.megogoAccessToken,
    required this.authorization,
    required this.autoText,
    required this.baseUrl,
    required this.story,
    required this.storyButtonText,
    required this.closeText,
  });
}

enum PlayerType { movie, trailer, tv, story, serial }
