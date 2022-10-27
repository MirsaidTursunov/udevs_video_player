import 'dart:convert';

import 'package:udevs_video_player/models/player_configuration.dart';

import 'udevs_video_player_platform_interface.dart';
export 'package:udevs_video_player/models/player_configuration.dart';
export 'package:udevs_video_player/models/movie.dart';
export 'package:udevs_video_player/models/story.dart';
export 'package:udevs_video_player/models/season.dart';
export 'package:udevs_video_player/models/tv_program.dart';
export 'package:udevs_video_player/models/programs_info.dart';

class UdevsVideoPlayer {
  Future<String?> playVideo({
    required PlayerConfiguration playerConfig,
  }) {
    String jsonStringConfig = jsonEncode({
      "initialResolution": {
        "480p": "https://meta.vcdn.biz/64aaf058408ea59eb6151fa74166ccff_mgg/vod/hls/b/1500/u_sid/0/o/99350911/rsid/580e7780-afef-4453-9f68-8050ca15573a/u_uid/1178439676/u_vod/3/u_device/sharqtv_uz/u_devicekey/_sharqtv_uz_web/u_did/MToxMTc4NDM5Njc2OjE2NjY4NTU0MTA6OjM3NzExYWQwNDZhYTZmMmEyOWZlOGQyOTZiZmU4NTI5/a/0/type.amlst/playlist.m3u8"
      },
      "resolutions": {
        "Автонастройка": "https://meta.vcdn.biz/d5c18aefcead2fa8c3c344c00ed86930_mgg/vod/hls/b/450_900_1350_1500_2000_5000/u_sid/0/o/99350911/rsid/6e848eff-359e-41c1-aeab-b0053083c053/u_uid/1178439676/u_vod/3/u_device/sharqtv_uz/u_devicekey/_sharqtv_uz_web/u_did/MToxMTc4NDM5Njc2OjE2NjY4NTU0MTA6OjM3NzExYWQwNDZhYTZmMmEyOWZlOGQyOTZiZmU4NTI5/a/0/type.amlst/playlist.m3u8",
        "240p": "https://meta.vcdn.biz/52cb1f275d998b734c7492bef381006c_mgg/vod/hls/b/450/u_sid/0/o/99350911/rsid/1b94ad8f-cc61-46e7-8ec6-b18ec915eb7f/u_uid/1178439676/u_vod/3/u_device/sharqtv_uz/u_devicekey/_sharqtv_uz_web/u_did/MToxMTc4NDM5Njc2OjE2NjY4NTU0MTA6OjM3NzExYWQwNDZhYTZmMmEyOWZlOGQyOTZiZmU4NTI5/a/0/type.amlst/playlist.m3u8",
        "320p": "https://meta.vcdn.biz/b560d349d2ceb66580491e8c76dd61d3_mgg/vod/hls/b/900/u_sid/0/o/99350911/rsid/7cd13e4e-bb40-4dc7-ae09-9380cf242a7d/u_uid/1178439676/u_vod/3/u_device/sharqtv_uz/u_devicekey/_sharqtv_uz_web/u_did/MToxMTc4NDM5Njc2OjE2NjY4NTU0MTA6OjM3NzExYWQwNDZhYTZmMmEyOWZlOGQyOTZiZmU4NTI5/a/0/type.amlst/playlist.m3u8",
        "360p": "https://meta.vcdn.biz/564dc5ffa9459b9205864689b4f5f464_mgg/vod/hls/b/1350/u_sid/0/o/99350911/rsid/a09bd685-c3ba-4b8f-bd5b-3ad66ab76ce9/u_uid/1178439676/u_vod/3/u_device/sharqtv_uz/u_devicekey/_sharqtv_uz_web/u_did/MToxMTc4NDM5Njc2OjE2NjY4NTU0MTA6OjM3NzExYWQwNDZhYTZmMmEyOWZlOGQyOTZiZmU4NTI5/a/0/type.amlst/playlist.m3u8",
        "480p": "https://meta.vcdn.biz/64aaf058408ea59eb6151fa74166ccff_mgg/vod/hls/b/1500/u_sid/0/o/99350911/rsid/580e7780-afef-4453-9f68-8050ca15573a/u_uid/1178439676/u_vod/3/u_device/sharqtv_uz/u_devicekey/_sharqtv_uz_web/u_did/MToxMTc4NDM5Njc2OjE2NjY4NTU0MTA6OjM3NzExYWQwNDZhYTZmMmEyOWZlOGQyOTZiZmU4NTI5/a/0/type.amlst/playlist.m3u8",
        "720p": "https://meta.vcdn.biz/5bd877e1b4d2df5f2706dff38122b222_mgg/vod/hls/b/2000/u_sid/0/o/99350911/rsid/4c1fc8da-2096-46b2-828f-92428108ce41/u_uid/1178439676/u_vod/3/u_device/sharqtv_uz/u_devicekey/_sharqtv_uz_web/u_did/MToxMTc4NDM5Njc2OjE2NjY4NTU0MTA6OjM3NzExYWQwNDZhYTZmMmEyOWZlOGQyOTZiZmU4NTI5/a/0/type.amlst/playlist.m3u8",
        "1080p": "https://meta.vcdn.biz/7546bc688fd8631c99dabf04d8055bd9_mgg/vod/hls/b/5000/u_sid/0/o/99350911/rsid/a8a9ad8e-d29a-4144-a9ae-8ee50cf13eea/u_uid/1178439676/u_vod/3/u_device/sharqtv_uz/u_devicekey/_sharqtv_uz_web/u_did/MToxMTc4NDM5Njc2OjE2NjY4NTU0MTA6OjM3NzExYWQwNDZhYTZmMmEyOWZlOGQyOTZiZmU4NTI5/a/0/type.amlst/playlist.m3u8"
      },
      "qualityText": "Качество",
      "speedText": "Скорость",
      "lastPosition": 0,
      "title": "S1 E1 Серия 1",
      "isSerial": true,
      "episodeButtonText": "Эпизоды",
      "nextButtonText": "След.эпизод",
      "seasons": [
        {
          "title": "1 Сезон",
          "movies": [
            {
              "id": "9733365",
              "title": "Серия 1",
              "description": "",
              "image": "",
              "duration": 0,
              "resolutions": {

              }
            },
            {
              "id": "9733375",
              "title": "Серия 2",
              "description": "",
              "image": "",
              "duration": 0,
              "resolutions": {

              }
            },
            {
              "id": "9733385",
              "title": "Серия 3",
              "description": "",
              "image": "",
              "duration": 0,
              "resolutions": {

              }
            },
            {
              "id": "9733395",
              "title": "Серия 4",
              "description": "",
              "image": "",
              "duration": 0,
              "resolutions": {

              }
            },
            {
              "id": "9733415",
              "title": "Серия 5",
              "description": "",
              "image": "",
              "duration": 0,
              "resolutions": {

              }
            },
            {
              "id": "9733425",
              "title": "Серия 6",
              "description": "",
              "image": "",
              "duration": 0,
              "resolutions": {

              }
            },
            {
              "id": "9733435",
              "title": "Серия 7",
              "description": "",
              "image": "",
              "duration": 0,
              "resolutions": {

              }
            },
            {
              "id": "9733445",
              "title": "Серия 8",
              "description": "",
              "image": "",
              "duration": 0,
              "resolutions": {

              }
            },
            {
              "id": "9733455",
              "title": "Серия 9",
              "description": "",
              "image": "",
              "duration": 0,
              "resolutions": {

              }
            },
            {
              "id": "9733465",
              "title": "Серия 10",
              "description": "",
              "image": "",
              "duration": 0,
              "resolutions": {

              }
            }
          ]
        },
        {
          "title": "2 Сезон",
          "movies": [
            {
              "id": "9733365",
              "title": "Серия 1",
              "description": "",
              "image": "",
              "duration": 0,
              "resolutions": {

              }
            },
            {
              "id": "9733375",
              "title": "Серия 2",
              "description": "",
              "image": "",
              "duration": 0,
              "resolutions": {

              }
            },
            {
              "id": "9733385",
              "title": "Серия3",
              "description": "",
              "image": "",
              "duration": 0,
              "resolutions": {

              }
            },
            {
              "id": "9733395",
              "title": "Серия 4",
              "description": "",
              "image": "",
              "duration": 0,
              "resolutions": {

              }
            },
            {
              "id": "9733415",
              "title": "Серия 5",
              "description": "",
              "image": "",
              "duration": 0,
              "resolutions": {

              }
            },
            {
              "id": "9733425",
              "title": "Серия 6",
              "description": "",
              "image": "",
              "duration": 0,
              "resolutions": {

              }
            },
            {
              "id": "9733435",
              "title": "Серия 7",
              "description": "",
              "image": "",
              "duration": 0,
              "resolutions": {

              }
            },
            {
              "id": "9733445",
              "title": "Серия 8",
              "description": "",
              "image": "",
              "duration": 0,
              "resolutions": {

              }
            },
            {
              "id": "9733455",
              "title": "Серия 9",
              "description": "",
              "image": "",
              "duration": 0,
              "resolutions": {

              }
            },
            {
              "id": "9733465",
              "title": "Серия 10",
              "description": "",
              "image": "",
              "duration": 0,
              "resolutions": {

              }
            }
          ]
        },
        {
          "title": "3 Сезон",
          "movies": [
            {
              "id": "9733365",
              "title": "Серия 1",
              "description": "",
              "image": "",
              "duration": 0,
              "resolutions": {

              }
            },
            {
              "id": "9733375",
              "title": "Серия 2",
              "description": "",
              "image": "",
              "duration": 0,
              "resolutions": {

              }
            },
            {
              "id": "9733385",
              "title": "Серия 3",
              "description": "",
              "image": "",
              "duration": 0,
              "resolutions": {

              }
            },
            {
              "id": "9733395",
              "title": "Серия 4",
              "description": "",
              "image": "",
              "duration": 0,
              "resolutions": {

              }
            },
            {
              "id": "9733415",
              "title": "Серия 5",
              "description": "",
              "image": "",
              "duration": 0,
              "resolutions": {

              }
            },
            {
              "id": "9733425",
              "title": "Серия 6",
              "description": "",
              "image": "",
              "duration": 0,
              "resolutions": {

              }
            },
            {
              "id": "9733435",
              "title": "Серия 7",
              "description": "",
              "image": "",
              "duration": 0,
              "resolutions": {

              }
            },
            {
              "id": "9733445",
              "title": "Серия 8",
              "description": "",
              "image": "",
              "duration": 0,
              "resolutions": {

              }
            },
            {
              "id": "9733455",
              "title": "Серия 9",
              "description": "",
              "image": "",
              "duration": 0,
              "resolutions": {

              }
            },
            {
              "id": "9733465",
              "title": "Серия 10",
              "description": "",
              "image": "",
              "duration": 0,
              "resolutions": {

              }
            }
          ]
        },
        {
          "title": "4 Сезон",
          "movies": [
            {
              "id": "9733365",
              "title": "Серия 1",
              "description": "",
              "image": "",
              "duration": 0,
              "resolutions": {

              }
            },
            {
              "id": "9733375",
              "title": "Серия 2",
              "description": "",
              "image": "",
              "duration": 0,
              "resolutions": {

              }
            },
            {
              "id": "9733385",
              "title": "Серия 3",
              "description": "",
              "image": "",
              "duration": 0,
              "resolutions": {

              }
            },
            {
              "id": "9733395",
              "title": "Серия 4",
              "description": "",
              "image": "",
              "duration": 0,
              "resolutions": {

              }
            },
            {
              "id": "9733415",
              "title": "Серия 5",
              "description": "",
              "image": "",
              "duration": 0,
              "resolutions": {

              }
            },
            {
              "id": "9733425",
              "title": "Серия 6",
              "description": "",
              "image": "",
              "duration": 0,
              "resolutions": {

              }
            },
            {
              "id": "9733435",
              "title": "Серия 7",
              "description": "",
              "image": "",
              "duration": 0,
              "resolutions": {

              }
            },
            {
              "id": "9733445",
              "title": "Серия 8",
              "description": "",
              "image": "",
              "duration": 0,
              "resolutions": {

              }
            },
            {
              "id": "9733455",
              "title": "Серия 9",
              "description": "",
              "image": "",
              "duration": 0,
              "resolutions": {

              }
            },
            {
              "id": "9733465",
              "title": "Серия 10",
              "description": "",
              "image": "",
              "duration": 0,
              "resolutions": {

              }
            }
          ]
        }
      ],
      "isLive": false,
      "tvProgramsText": "Телеканалы",
      "programsInfoList": [

      ],
      "showController": true,
      "playVideoFromAsset": false,
      "assetPath": "",
      "seasonIndex": 0,
      "episodeIndex": 0,
      "isMegogo": true,
      "isPremier": false,
      "videoId": "9733295",
      "sessionId": "63591d5069f875660ef248c3",
      "megogoAccessToken": "MToxMTc4NDM5Njc2OjE2NjY4NTU0MTA6OjM3NzExYWQwNDZhYTZmMmEyOWZlOGQyOTZiZmU4NTI5",
      "authorization": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2NDcyNTUzNzcsImlzcyI6InVzZXIiLCJyb2xlIjoiY3VzdG9tZXIiLCJzdWIiOiI1MzYyOWEwZS1lN2ExLTQ4YmQtYjZjMS05MDFiODIxNDc3OTgifQ.k2wBnwN_CEQ1m3Hhfj7xN2-HN7vNd0HQE0lxTvp7mhw",
      "autoText": "Автонастройка",
      "baseUrl": "https://api.spec.sharqtv.udevs.io/v1/",
      "isStory": false,
      "story": [

      ],
      "storyButtonText": "Смотреть фильм",
      "closeText": "Закрыть",
      "seasonText": "сезон"
    });
    return UdevsVideoPlayerPlatform.instance.playVideo(
      playerConfigJsonString: jsonStringConfig,
    );
  }

  Future<dynamic> closeVideo() {
    return UdevsVideoPlayerPlatform.instance.closeVideo();
  }
}
