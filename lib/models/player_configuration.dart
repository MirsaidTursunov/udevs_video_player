import 'dart:core';

import 'package:udevs_video_player/models/movie.dart';
import 'package:udevs_video_player/models/programs_info.dart';
import 'package:udevs_video_player/models/season.dart';

class PlayerConfiguration {
  PlayerConfiguration({
    this.isDRM = false,
    this.fpsCertificateUrl = '',
    this.licenseToken = '',
    this.licenseServiceUrl = '',
    this.videoUrl = '',
    required this.initialResolution,
    required this.resolutions,
    required this.qualityText,
    required this.speedText,
    required this.lastPosition,
    required this.title,
    required this.isSerial,
    required this.episodeButtonText,
    required this.nextButtonText,
    required this.seasons,
    required this.isLive,
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
    required this.fromCache,
    required this.channels,
    required this.ip,
    required this.selectChannelIndex,
  });

  Map<String, String> initialResolution;
  Map<String, String> resolutions;
  String qualityText;
  String speedText;
  int lastPosition;
  String title;
  bool isSerial;
  String episodeButtonText;
  String nextButtonText;
  List<Season> seasons;
  bool isLive;
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
  bool fromCache;
  List<Channel> channels;
  String ip;
  int selectChannelIndex;
  final String fpsCertificateUrl;
  final String licenseToken;
  final String licenseServiceUrl;
  final String videoUrl;
  final bool isDRM;

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
    map['isPremier'] = isPremier;
    map['videoId'] = videoId;
    map['sessionId'] = sessionId;
    map['megogoAccessToken'] = megogoAccessToken;
    map['authorization'] = authorization;
    map['autoText'] = autoText;
    map['baseUrl'] = baseUrl;
    map['fromCache'] = fromCache;
    map['channels'] = channels.map((v) => v.toJson()).toList();
    map['ip'] = ip;
    map['selectChannelIndex'] = selectChannelIndex;
    map['fpsCertificateUrl'] = fpsCertificateUrl;
    map['licenseToken'] = licenseToken;
    map['licenseServiceUrl'] = licenseServiceUrl;
    map['videoUrl'] = videoUrl;
    map['isDRM'] = isDRM;
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
      'isPremier: $isPremier, '
      'videoId: $videoId, '
      'sessionId: $sessionId, '
      'megogoAccessToken: $megogoAccessToken, '
      'authorization: $authorization, '
      'autoText: $autoText '
      'baseUrl: $baseUrl, '
      'fromCache: $fromCache'
      'channels: $channels'
      'ip: $ip'
      'selectChannelIndex: $selectChannelIndex'
      '}';
}
