import 'dart:core';

import 'package:udevs_video_player/models/programs_info.dart';
import 'package:udevs_video_player/models/season.dart';

import 'tv_categories.dart';

export 'programs_info.dart';
export 'season.dart';
export 'tv_categories.dart';
export 'tv_channel.dart';

class PlayerConfiguration {
  const PlayerConfiguration({
    required this.initialResolution,
    required this.resolutions,
    required this.qualityText,
    required this.speedText,
    required this.lastPosition,
    required this.title,
    required this.isSerial,
    required this.episodeButtonText,
    required this.nextButtonText,
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
    required this.profileId,
    required this.noneText,
    required this.subtitleText,
    required this.audioText,
    required this.defaultText,
    this.seasons = const [],
    this.isLive = false,
    this.tvProgramsText = 'Tv Programs',
    this.programsInfoList = const [],
    this.ip = '',
    this.selectChannelIndex = 0,
    this.selectTvCategoryIndex = 0,
    this.tvCategories = const [],
    this.sendMovieTrack = true,
  });

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
  final bool isLive;
  final String tvProgramsText;
  final List<ProgramsInfo> programsInfoList;
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
  final List<TvCategories> tvCategories;
  final String ip;
  final int selectChannelIndex;
  final int selectTvCategoryIndex;
  final String userId;
  final String profileId;
  final String noneText;
  final String subtitleText;
  final String audioText;
  final String defaultText;
  final bool sendMovieTrack;

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
    map['isLive'] = isLive;
    map['tvProgramsText'] = tvProgramsText;
    map['programsInfoList'] = programsInfoList.map((v) => v.toJson()).toList();
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
    map['ip'] = ip;
    map['selectChannelIndex'] = selectChannelIndex;
    map['selectTvCategoryIndex'] = selectTvCategoryIndex;
    map['profileId'] = profileId;
    map['userId'] = userId;
    map['tvCategories'] = tvCategories.map((v) => v.toJson()).toList();
    map['noneText'] = noneText;
    map['subtitleText'] = subtitleText;
    map['audioText'] = audioText;
    map['defaultText'] = defaultText;
    map['sendMovieTrack'] = sendMovieTrack;
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
      'isLive: $isLive, '
      'tvProgramsText: $tvProgramsText, '
      'programsInfoList: $programsInfoList, '
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
      'channels: $tvCategories, '
      'ip: $ip'
      'selectChannelIndex: $selectChannelIndex'
      'userId: $userId'
      'profileId: $profileId'
      'noneText: $noneText'
      'subtitleText: $subtitleText'
      'audioText: $audioText'
      'defaultText: $defaultText'
      'sendMovieTrack: $sendMovieTrack'
      '}';
}
