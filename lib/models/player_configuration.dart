import 'dart:core';

import 'package:udevs_video_player/models/season.dart';

class PlayerConfiguration {
  PlayerConfiguration({
    required this.initialResolution,
    required this.resolutions,
    required this.qualityText,
    required this.speedText,
    required this.lastPosition,
    required this.title,
    required this.isSerial,
    required this.seasons,
    required this.isYoutube,
    required this.showController,
    required this.seasonIndex,
    required this.episodeIndex,
    required this.episodeText,
    required this.seasonText,
    required this.videoId,
    required this.sessionId,
    required this.authorization,
    required this.autoText,
    required this.baseUrl,
    required this.programsText,
  });

  final Map<String, String> initialResolution;
  final Map<String, String> resolutions;
  final String qualityText;
  final String speedText;
  final int lastPosition;
  final String title;
  final bool isSerial;
  final List<Season> seasons;
  final bool isYoutube;
  final bool showController;
  final int seasonIndex;
  final int episodeIndex;
  final String episodeText;
  final String seasonText;
  final String programsText;
  final String videoId;
  final String sessionId;
  final String authorization;
  final String autoText;
  final String baseUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['initialResolution'] = initialResolution;
    map['resolutions'] = resolutions;
    map['qualityText'] = qualityText;
    map['speedText'] = speedText;
    map['lastPosition'] = lastPosition;
    map['title'] = title;
    map['isSerial'] = isSerial;
    map['seasons'] = seasons.map((v) => v.toJson()).toList();
    map['showController'] = showController;
    map['seasonIndex'] = seasonIndex;
    map['episodeIndex'] = episodeIndex;
    map['episodeText'] = episodeText;
    map['seasonText'] = seasonText;
    map['videoId'] = videoId;
    map['sessionId'] = sessionId;
    map['authorization'] = authorization;
    map['autoText'] = autoText;
    map['baseUrl'] = baseUrl;
    map['programsText'] = programsText;
    map['isYoutube'] = isYoutube;
    return map;
  }

  @override
  String toString() =>
      'PlayerConfiguration{initialResolution: $initialResolution, resolutions: $resolutions, qualityText: $qualityText, speedText: $speedText, lastPosition: $lastPosition, title: $title, isSerial: $isSerial, seasons: $seasons, isYoutube: $isYoutube, showController: $showController, seasonIndex: $seasonIndex, episodeIndex: $episodeIndex, episodeText: $episodeText, seasonText: $seasonText, videoId: $videoId, sessionId: $sessionId, authorization: $authorization, autoText: $autoText, baseUrl: $baseUrl,programsText: $programsText}';
}
