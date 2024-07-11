import 'package:udevs_video_player/models/advertisement_response.dart';
import 'package:udevs_video_player/models/programs_info.dart';
import 'package:udevs_video_player/models/tv_categories.dart';

class LivePlayerConfiguration {
  const LivePlayerConfiguration({
    required this.initialResolution,
    required this.resolutions,
    required this.qualityText,
    required this.speedText,
    // required this.lastPosition,
    required this.title,
    // required this.isSerial,
    // required this.episodeButtonText,
    // required this.nextButtonText,
    // required this.seasons,
    // required this.isLive,
    required this.tvProgramsText,
    required this.programsInfoList,
    required this.showController,
    // required this.playVideoFromAsset,
    // required this.assetPath,
    // required this.seasonIndex,
    // required this.episodeIndex,
    // required this.isMegogo,
    // required this.isMoreTv,
    // required this.isPremier,
    // required this.videoId,
    // required this.sessionId,
    // required this.megogoAccessToken,
    required this.authorization,
    required this.autoText,
    required this.baseUrl,
    // required this.fromCache,
    // required this.movieShareLink,
    required this.ip,
    required this.selectChannelIndex,
    this.selectTvCategoryIndex = 0,
    required this.tvCategories,
    required this.userId,
    required this.age,
    required this.gender,
    required this.region,
    // required this.profileId,
    this.advertisement,
    required this.skipText,
  });

  final Map<String, String> initialResolution;
  final Map<String, String> resolutions;
  final String qualityText;
  final String speedText;
  final AdvertisementResponse? advertisement;

  // final int lastPosition;
  final String title;

  // final bool isSerial;
  // final String episodeButtonText;
  // final String nextButtonText;
  // final List<Season> seasons;
  // final bool isLive;
  final String tvProgramsText;
  final List<ProgramsInfo> programsInfoList;
  final bool showController;

  // final bool playVideoFromAsset;
  // final String assetPath;
  // final int seasonIndex;
  // final int episodeIndex;
  // final bool isMegogo;
  // final bool isPremier;
  // final bool isMoreTv;
  // final String videoId;
  // final String sessionId;

  // final String megogoAccessToken;
  final String authorization;
  final String autoText;
  final String baseUrl;

  // final String movieShareLink;
  // final bool fromCache;
  final List<TvCategories> tvCategories;
  final String ip;
  final int selectChannelIndex;
  final int selectTvCategoryIndex;
  final String skipText;

  final String userId;
  final int age;
  final String gender;
  final String region;

  // final String profileId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['initialResolution'] = initialResolution;
    map['resolutions'] = resolutions;
    map['qualityText'] = qualityText;
    map['speedText'] = speedText;
    // map['lastPosition'] = lastPosition;
    map['title'] = title;
    map['advertisement'] = advertisement?.toJson();
    // map['isSerial'] = isSerial;
    // map['episodeButtonText'] = episodeButtonText;
    // map['nextButtonText'] = nextButtonText;
    // map['seasons'] = seasons.map((v) => v.toJson()).toList();
    // map['isLive'] = isLive;
    map['tvProgramsText'] = tvProgramsText;
    map['programsInfoList'] = programsInfoList.map((v) => v.toJson()).toList();
    map['showController'] = showController;
    // map['playVideoFromAsset'] = playVideoFromAsset;
    // map['assetPath'] = assetPath;
    // map['seasonIndex'] = seasonIndex;
    // map['episodeIndex'] = episodeIndex;
    // map['isMegogo'] = isMegogo;
    // map['isMoreTv'] = isMoreTv;
    // map['isPremier'] = isPremier;
    // map['videoId'] = videoId;
    // map['sessionId'] = sessionId;
    // map['megogoAccessToken'] = megogoAccessToken;
    map['authorization'] = authorization;
    map['autoText'] = autoText;
    map['baseUrl'] = baseUrl;
    // map['fromCache'] = fromCache;
    // map['movieShareLink'] = movieShareLink;
    map['ip'] = ip;
    map['selectChannelIndex'] = selectChannelIndex;
    map['selectTvCategoryIndex'] = selectTvCategoryIndex;
    // map['profileId'] = profileId;
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
      'initialResolution: $initialResolution, '
      'resolutions: $resolutions, '
      'qualityText: $qualityText, '
      'speedText: $speedText, '
      // 'lastPosition: $lastPosition, '
      'title: $title, '
      // 'isSerial: $isSerial, '
      // 'episodeButtonText: $episodeButtonText, '
      // 'nextButtonText: $nextButtonText, '
      // 'seasons: $seasons, '
      // 'isLive: $isLive, '
      'tvProgramsText: $tvProgramsText, '
      'programsInfoList: $programsInfoList, '
      'showController: $showController, '
      // 'playVideoFromAsset: $playVideoFromAsset, '
      // 'assetPath: $assetPath, '
      // 'seasonIndex: $seasonIndex, '
      // 'episodeIndex: $episodeIndex, '
      // 'isMegogo: $isMegogo, '
      // 'isMoreTv: $isMoreTv, '
      // 'isPremier: $isPremier, '
      // 'videoId: $videoId, '
      // 'sessionId: $sessionId, '
      // 'megogoAccessToken: $megogoAccessToken, '
      'authorization: $authorization, '
      'autoText: $autoText '
      'baseUrl: $baseUrl, '
      // 'fromCache: $fromCache, '
      // 'movieShareLink: $movieShareLink, '
      'channels: $tvCategories, '
      'ip: $ip'
      'selectChannelIndex: $selectChannelIndex'
      'userId: $userId'
      'age: $age'
      'gender: $gender'
      'region: $region'
      // 'profileId: $profileId'
      'advertisement: $advertisement'
      'skipText: $skipText'
      '}';
}
