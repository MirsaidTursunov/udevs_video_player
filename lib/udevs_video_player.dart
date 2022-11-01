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
        "480p": "https://meta.vcdn.biz/507d78a5bbc1a160b1928d9203b5a3b3_mgg/vod/hls/b/1500/u_sid/0/o/126664821/rsid/61d7c5b8-fe28-4540-b71e-7f6eb44c613e/u_uid/1178439676/u_vod/4/u_device/sharqtv_uz/u_devicekey/_sharqtv_uz_web/u_did/MToxMTc4NDM5Njc2OjE2NjcyOTExMTk6OjAyOGVhZjY3NDY0NmRjY2EzYWY1ZjlmN2VlZDMwMTgy/a/0/type.amlst/playlist.m3u8"
      },
      "resolutions": {
        "Автонастройка": "https://meta.vcdn.biz/c47db79fbe68cd7b87014b7c9e5d4e25_mgg/vod/hls/b/450_900_1350_1500_2000_5000/u_sid/0/o/126664821/rsid/7b9bac3d-28d1-4032-9d3f-1a4df465ef62/u_uid/1178439676/u_vod/4/u_device/sharqtv_uz/u_devicekey/_sharqtv_uz_web/u_did/MToxMTc4NDM5Njc2OjE2NjcyOTExMTk6OjAyOGVhZjY3NDY0NmRjY2EzYWY1ZjlmN2VlZDMwMTgy/a/0/type.amlst/playlist.m3u8",
        "240p": "https://meta.vcdn.biz/7dc33f33129edca87379af318c5d9313_mgg/vod/hls/b/450/u_sid/0/o/126664821/rsid/a627db59-1072-4439-a5ad-5f01e19f618b/u_uid/1178439676/u_vod/4/u_device/sharqtv_uz/u_devicekey/_sharqtv_uz_web/u_did/MToxMTc4NDM5Njc2OjE2NjcyOTExMTk6OjAyOGVhZjY3NDY0NmRjY2EzYWY1ZjlmN2VlZDMwMTgy/a/0/type.amlst/playlist.m3u8",
        "320p": "https://meta.vcdn.biz/75f4e8f346db15263eb51d4e65225685_mgg/vod/hls/b/900/u_sid/0/o/126664821/rsid/d7e7b44c-58e0-4634-be53-35582abf25a3/u_uid/1178439676/u_vod/4/u_device/sharqtv_uz/u_devicekey/_sharqtv_uz_web/u_did/MToxMTc4NDM5Njc2OjE2NjcyOTExMTk6OjAyOGVhZjY3NDY0NmRjY2EzYWY1ZjlmN2VlZDMwMTgy/a/0/type.amlst/playlist.m3u8",
        "360p": "https://meta.vcdn.biz/40c82d195f91a7fac487a8651633a2a1_mgg/vod/hls/b/1350/u_sid/0/o/126664821/rsid/1625a893-d2fd-4571-bbd9-9c1d74349029/u_uid/1178439676/u_vod/4/u_device/sharqtv_uz/u_devicekey/_sharqtv_uz_web/u_did/MToxMTc4NDM5Njc2OjE2NjcyOTExMTk6OjAyOGVhZjY3NDY0NmRjY2EzYWY1ZjlmN2VlZDMwMTgy/a/0/type.amlst/playlist.m3u8",
        "480p": "https://meta.vcdn.biz/507d78a5bbc1a160b1928d9203b5a3b3_mgg/vod/hls/b/1500/u_sid/0/o/126664821/rsid/61d7c5b8-fe28-4540-b71e-7f6eb44c613e/u_uid/1178439676/u_vod/4/u_device/sharqtv_uz/u_devicekey/_sharqtv_uz_web/u_did/MToxMTc4NDM5Njc2OjE2NjcyOTExMTk6OjAyOGVhZjY3NDY0NmRjY2EzYWY1ZjlmN2VlZDMwMTgy/a/0/type.amlst/playlist.m3u8",
        "720p": "https://meta.vcdn.biz/9ed43a9c182210dc8e3c5a6d599007e4_mgg/vod/hls/b/2000/u_sid/0/o/126664821/rsid/93f1e934-3f3a-477a-bc3e-bfe6d43f773c/u_uid/1178439676/u_vod/4/u_device/sharqtv_uz/u_devicekey/_sharqtv_uz_web/u_did/MToxMTc4NDM5Njc2OjE2NjcyOTExMTk6OjAyOGVhZjY3NDY0NmRjY2EzYWY1ZjlmN2VlZDMwMTgy/a/0/type.amlst/playlist.m3u8",
        "1080p": "https://meta.vcdn.biz/bcd054cb9ae91ff705d41fb89af0cbd2_mgg/vod/hls/b/5000/u_sid/0/o/126664821/rsid/bda69f16-10f0-4e35-a0ca-b1a206cdbf16/u_uid/1178439676/u_vod/4/u_device/sharqtv_uz/u_devicekey/_sharqtv_uz_web/u_did/MToxMTc4NDM5Njc2OjE2NjcyOTExMTk6OjAyOGVhZjY3NDY0NmRjY2EzYWY1ZjlmN2VlZDMwMTgy/a/0/type.amlst/playlist.m3u8"
      },
      "qualityText": "Качество",
      "speedText": "Скорость",
      "type": "serial",
      "lastPosition": 0,
      "title": "S1 E1 Серия 1",
      "platform": "7e9217c5-a6b4-490a-9e90-dad564f39361",
      "isSerial": true,
      "episodeButtonText": "Эпизоды",
      "nextButtonText": "След.эпизод",
      "seasons": [
        {
          "title": "1 Сезон",
          "movies": [
            {
              "id": "16024325",
              "title": "Серия 1",
              "description": "",
              "image": "http://s2.vcdn.biz/static/f/3645516431/image.jpg",
              "duration": 4227,
              "resolutions": {

              }
            },
            {
              "id": "16024335",
              "title": "Серия 2",
              "description": "",
              "image": "http://s3.vcdn.biz/static/f/3645470721/image.jpg",
              "duration": 4064,
              "resolutions": {

              }
            },
            {
              "id": "16024345",
              "title": "Серия 3",
              "description": "",
              "image": "http://s6.vcdn.biz/static/f/3645463731/image.jpg",
              "duration": 4234,
              "resolutions": {

              }
            },
            {
              "id": "16024355",
              "title": "Серия 4",
              "description": "",
              "image": "http://s4.vcdn.biz/static/f/3645480001/image.jpg",
              "duration": 4518,
              "resolutions": {

              }
            },
            {
              "id": "16024365",
              "title": "Серия 5",
              "description": "",
              "image": "http://s7.vcdn.biz/static/f/3645402001/image.jpg",
              "duration": 4058,
              "resolutions": {

              }
            },
            {
              "id": "16024375",
              "title": "Серия 6",
              "description": "",
              "image": "http://s4.vcdn.biz/static/f/3645409171/image.jpg",
              "duration": 4524,
              "resolutions": {

              }
            },
            {
              "id": "16024385",
              "title": "Серия 7",
              "description": "",
              "image": "http://s3.vcdn.biz/static/f/3645372081/image.jpg",
              "duration": 4043,
              "resolutions": {

              }
            },
            {
              "id": "16024395",
              "title": "Серия 8",
              "description": "",
              "image": "http://s6.vcdn.biz/static/f/3645345831/image.jpg",
              "duration": 4385,
              "resolutions": {

              }
            },
            {
              "id": "16024405",
              "title": "Серия 9",
              "description": "",
              "image": "http://s7.vcdn.biz/static/f/3645321631/image.jpg",
              "duration": 4011,
              "resolutions": {

              }
            },
            {
              "id": "16024415",
              "title": "Серия 10",
              "description": "",
              "image": "http://s3.vcdn.biz/static/f/3645330771/image.jpg",
              "duration": 4175,
              "resolutions": {

              }
            },
            {
              "id": "16024425",
              "title": "Серия 11",
              "description": "",
              "image": "http://s8.vcdn.biz/static/f/3645277091/image.jpg",
              "duration": 4055,
              "resolutions": {

              }
            },
            {
              "id": "16024435",
              "title": "Серия 12",
              "description": "",
              "image": "http://s8.vcdn.biz/static/f/3659711561/image.jpg",
              "duration": 3665,
              "resolutions": {

              }
            },
            {
              "id": "16024445",
              "title": "Серия 13",
              "description": "",
              "image": "http://s2.vcdn.biz/static/f/3645266501/image.jpg",
              "duration": 4036,
              "resolutions": {

              }
            },
            {
              "id": "16024455",
              "title": "Серия 14",
              "description": "",
              "image": "http://s2.vcdn.biz/static/f/3645198911/image.jpg",
              "duration": 4059,
              "resolutions": {

              }
            },
            {
              "id": "16024465",
              "title": "Серия 15",
              "description": "",
              "image": "http://s9.vcdn.biz/static/f/3645181881/image.jpg",
              "duration": 3714,
              "resolutions": {

              }
            },
            {
              "id": "16024475",
              "title": "Серия 16",
              "description": "",
              "image": "http://s2.vcdn.biz/static/f/3645187121/image.jpg",
              "duration": 3864,
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
      "videoId": "16009995",
      "sessionId": "6360d7c269f87575c3f654d1",
      "megogoAccessToken": "MToxMTc4NDM5Njc2OjE2NjcyOTExMTk6OjAyOGVhZjY3NDY0NmRjY2EzYWY1ZjlmN2VlZDMwMTgy",
      "authorization": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2NDcyNTUzNzcsImlzcyI6InVzZXIiLCJyb2xlIjoiY3VzdG9tZXIiLCJzdWIiOiI1MzYyOWEwZS1lN2ExLTQ4YmQtYjZjMS05MDFiODIxNDc3OTgifQ.k2wBnwN_CEQ1m3Hhfj7xN2-HN7vNd0HQE0lxTvp7mhw",
      "autoText": "Автонастройка",
      "baseUrl": "https://api.spec.sharqtv.udevs.io/v1/",
      "isStory": false,
      "story": [

      ],
      "storyButtonText": "Смотреть фильм",
      "closeText": "Закрыть",
      "seasonText": "сезон",
      "storyIndex": 0,
      "movieTrack": {
        "episode_key": "1",
        "is_megogo": true,
        "movie_key": "16009995",
        "season_key": "1",
        "seconds": 0,
        "user_id": "53629a0e-e7a1-48bd-b6c1-901b82147798",
        "element": "episode"
      }
    });
    return UdevsVideoPlayerPlatform.instance.playVideo(
      playerConfigJsonString: jsonStringConfig,
    );
  }

  Future<dynamic> closeVideo() {
    return UdevsVideoPlayerPlatform.instance.closeVideo();
  }
}
