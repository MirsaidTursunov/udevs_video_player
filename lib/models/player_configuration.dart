import 'dart:core';

import 'package:udevs_video_player/models/programs_info.dart';
import 'package:udevs_video_player/models/season.dart';

class PlayerConfiguration {
  Map<String, String> initialResolution;
  Map<String, String> resolutions;
  String qualityText;
  String speedText;
  int lastPosition;
  String title;
  bool isSerial;
  List<Season> seasons;
  bool isLive;
  List<ProgramsInfo> programsInfoList;
  bool showController;
  bool playVideoFromAsset;
  String assetPath;
  int seasonIndex;
  int episodeIndex;

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['initialResolution'] = initialResolution;
    map['resolutions'] = resolutions;
    map['qualityText'] = qualityText;
    map['speedText'] = speedText;
    map['lastPosition'] = lastPosition;
    map['title'] = title;
    map['isSerial'] = isSerial;
    map['seasons'] = seasons.map((v) => v.toJson()).toList();
    map['isLive'] = isLive;
    map['programsInfoList'] = programsInfoList.map((v) => v.toJson()).toList();
    map['showController'] = showController;
    map['playVideoFromAsset'] = playVideoFromAsset;
    map['assetPath'] = assetPath;
    map['seasonIndex'] = seasonIndex;
    map['episodeIndex'] = episodeIndex;
    return map;
  }

  @override
  String toString() {
    return 'PlayerConfiguration{initialResolution: $initialResolution, resolutions: $resolutions, qualityText: $qualityText, speedText: $speedText, lastPosition: $lastPosition, title: $title, isSerial: $isSerial, seasons: $seasons, isLive: $isLive, programsInfoList: $programsInfoList, showController: $showController, playVideoFromAsset: $playVideoFromAsset, assetPath: $assetPath, seasonIndex: $seasonIndex, episodeIndex: $episodeIndex}';
  }

  PlayerConfiguration({
    required this.initialResolution,
    required this.resolutions,
    required this.qualityText,
    required this.speedText,
    required this.lastPosition,
    required this.title,
    required this.isSerial,
    required this.seasons,
    required this.isLive,
    required this.programsInfoList,
    required this.showController,
    required this.playVideoFromAsset,
    required this.assetPath,
    required this.seasonIndex,
    required this.episodeIndex,
  });
}
