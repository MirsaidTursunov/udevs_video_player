import 'package:udevs_video_player/models/advertisement_response.dart';
import 'package:udevs_video_player/models/programs_info.dart';
import 'package:udevs_video_player/models/tv_categories.dart';

class LivePlayerConfiguration {
  const LivePlayerConfiguration({
    required this.videoUrl,
    required this.qualityText,
    required this.speedText,
    required this.title,
    required this.tvProgramsText,
    required this.programsInfoList,
    required this.showController,
    required this.sessionId,
    required this.authorization,
    required this.autoText,
    required this.baseUrl,
    required this.ip,
    required this.selectChannelIndex,
    this.selectTvCategoryIndex = 0,
    required this.tvCategories,
    required this.userId,
    required this.age,
    required this.gender,
    required this.region,
    this.advertisement,
    required this.skipText,
  });

  final String videoUrl;
  final String qualityText;
  final String speedText;
  final AdvertisementResponse? advertisement;
  final String title;
  final String tvProgramsText;
  final List<ProgramsInfo> programsInfoList;
  final bool showController;
  final String sessionId;
  final String authorization;
  final String autoText;
  final String baseUrl;
  final List<TvCategories> tvCategories;
  final String ip;
  final int selectChannelIndex;
  final int selectTvCategoryIndex;
  final String skipText;

  final String userId;
  final int age;
  final String gender;
  final String region;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['videoUrl'] = videoUrl;
    map['qualityText'] = qualityText;
    map['speedText'] = speedText;
    map['title'] = title;
    map['advertisement'] = advertisement?.toJson();
    map['tvProgramsText'] = tvProgramsText;
    map['programsInfoList'] = programsInfoList.map((v) => v.toJson()).toList();
    map['showController'] = showController;
    map['sessionId'] = sessionId;
    map['authorization'] = authorization;
    map['autoText'] = autoText;
    map['baseUrl'] = baseUrl;
    map['ip'] = ip;
    map['selectChannelIndex'] = selectChannelIndex;
    map['selectTvCategoryIndex'] = selectTvCategoryIndex;
    map['userId'] = userId;
    map['age'] = age;
    map['gender'] = gender;
    map['region'] = region;
    map['tvCategories'] = tvCategories.map((v) => v.toJson()).toList();
    map['skipText'] = skipText;
    return map;
  }

  @override
  String toString() => 'PlayerConfiguration{'
      'videoUrl: $videoUrl, '
      'qualityText: $qualityText, '
      'speedText: $speedText, '
      'title: $title, '
      'tvProgramsText: $tvProgramsText, '
      'programsInfoList: $programsInfoList, '
      'showController: $showController, '
      'sessionId: $sessionId, '
      'authorization: $authorization, '
      'autoText: $autoText '
      'baseUrl: $baseUrl, '
      'channels: $tvCategories, '
      'ip: $ip'
      'selectChannelIndex: $selectChannelIndex'
      'userId: $userId'
      'age: $age'
      'gender: $gender'
      'region: $region'
      'advertisement: $advertisement'
      'skipText: $skipText'
      '}';
}
