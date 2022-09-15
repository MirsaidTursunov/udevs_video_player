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
  String episodeButtonText;
  String nextButtonText;
  List<Season> seasons;
  bool isLive;
  String tvProgramsText;
  List<ProgramsInfo> programsInfoList;
  bool showController;
  Map<bool, String> playVideoAsset;

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
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
    map['playVideoAsset'] = playVideoAsset;
    return map;
  }

  PlayerConfiguration({
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
    required this.playVideoAsset,
  });
}
