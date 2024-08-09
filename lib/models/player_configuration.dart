import 'dart:core';

import 'package:udevs_video_player/models/season.dart';

export 'programs_info.dart';
export 'season.dart';
export 'tv_categories.dart';
export 'tv_channel.dart';

class PlayerConfiguration {
  const PlayerConfiguration(
      {required this.initialResolution,
      required this.resolutions,
      required this.qualityText,
      required this.speedText,
      required this.lastPosition,
      required this.title,
      required this.isSerial,
      required this.episodeButtonText,
      required this.nextButtonText,
      required this.seasons,
      required this.showController,
      required this.playVideoFromAsset,
      required this.assetPath,
      required this.seasonIndex,
      required this.episodeIndex,
      required this.isMegogo,
      required this.isMoreTv,
      required this.isPremier,
      required this.videoId,
      required this.sessionId,
      required this.megogoAccessToken,
      required this.authorization,
      required this.autoText,
      required this.baseUrl,
      required this.fromCache,
      required this.movieShareLink,
      required this.userId,
      required this.profileId});

  final Map<String, String> initialResolution;
  final Map<String, String> resolutions;
  final String qualityText;
  final String speedText;
  final int lastPosition;
  final String title;
  final bool isSerial;
  final String episodeButtonText;
  final String nextButtonText;
  final List<Season> seasons;
  final bool showController;
  final bool playVideoFromAsset;
  final String assetPath;
  final int seasonIndex;
  final int episodeIndex;
  final bool isMegogo;
  final bool isPremier;
  final bool isMoreTv;
  final String videoId;
  final String sessionId;
  final String megogoAccessToken;
  final String authorization;
  final String autoText;
  final String baseUrl;
  final String movieShareLink;
  final bool fromCache;
  final String userId;
  final String profileId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['initialResolution'] = initialResolution;
    map['resolutions'] = resolutions;
    map['qualityText'] = qualityText;
    map['speedText'] = speedText;
    map['lastPosition'] = lastPosition;
    map['title'] = title;
    map['isSerial'] = isSerial;
    map['episodeButtonText'] = episodeButtonText;
    map['nextButtonText'] = nextButtonText;
    map['seasons'] = seasons.map((v) => v.toJson()).toList();
    map['showController'] = showController;
    map['playVideoFromAsset'] = playVideoFromAsset;
    map['assetPath'] = assetPath;
    map['seasonIndex'] = seasonIndex;
    map['episodeIndex'] = episodeIndex;
    map['isMegogo'] = isMegogo;
    map['isMoreTv'] = isMoreTv;
    map['isPremier'] = isPremier;
    map['videoId'] = videoId;
    map['sessionId'] = sessionId;
    map['megogoAccessToken'] = megogoAccessToken;
    map['authorization'] = authorization;
    map['autoText'] = autoText;
    map['baseUrl'] = baseUrl;
    map['fromCache'] = fromCache;
    map['movieShareLink'] = movieShareLink;
    map['profileId'] = profileId;
    map['userId'] = userId;
    return map;
  }

  @override
  String toString() => 'PlayerConfiguration{'
      'initialResolution: $initialResolution, '
      'resolutions: $resolutions, '
      'qualityText: $qualityText, '
      'speedText: $speedText, '
      'lastPosition: $lastPosition, '
      'title: $title, '
      'isSerial: $isSerial, '
      'episodeButtonText: $episodeButtonText, '
      'nextButtonText: $nextButtonText, '
      'seasons: $seasons, '
      'showController: $showController, '
      'playVideoFromAsset: $playVideoFromAsset, '
      'assetPath: $assetPath, '
      'seasonIndex: $seasonIndex, '
      'episodeIndex: $episodeIndex, '
      'isMegogo: $isMegogo, '
      'isMoreTv: $isMoreTv, '
      'isPremier: $isPremier, '
      'videoId: $videoId, '
      'sessionId: $sessionId, '
      'megogoAccessToken: $megogoAccessToken, '
      'authorization: $authorization, '
      'autoText: $autoText '
      'baseUrl: $baseUrl, '
      'fromCache: $fromCache, '
      'movieShareLink: $movieShareLink, '
      'userId: $userId'
      'profileId: $profileId'
      '}';
}
