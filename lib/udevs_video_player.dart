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
        "Auto": "https://flus.st.uz/2005/video.m3u8?token=6e884123d1cd18a1df43814dcf8bda029663543a-491358046--"
      },
      "resolutions": {
        "Auto": "https://flus.st.uz/2005/video.m3u8?token=6e884123d1cd18a1df43814dcf8bda029663543a-491358046--"
      },
      "qualityText": "Качество",
      "speedText": "Скорость",
      "lastPosition": 0,
      "title": "НТВ",
      "isSerial": false,
      "episodeButtonText": "track_episode",
      "nextButtonText": "track_episode",
      "seasons": [

      ],
      "isLive": true,
      "tvProgramsText": "Телеканалы",
      "programsInfoList": [
        {
          "day": "Today",
          "tvPrograms": [
            {
              "scheduledTime": "00:00",
              "programTitle": "Сегодня ",
              "isAvailable": true
            },
            {
              "scheduledTime": "01:00",
              "programTitle": "Тверская ",
              "isAvailable": true
            },
            {
              "scheduledTime": "03:10",
              "programTitle": "Балабол ",
              "isAvailable": true
            },
            {
              "scheduledTime": "04:35",
              "programTitle": "Сегодня ",
              "isAvailable": true
            },
            {
              "scheduledTime": "05:00",
              "programTitle": "Балабол ",
              "isAvailable": true
            },
            {
              "scheduledTime": "05:40",
              "programTitle": "Поздняков ",
              "isAvailable": true
            },
            {
              "scheduledTime": "05:55",
              "programTitle": "Мы и наука. Наука и мы ",
              "isAvailable": true
            },
            {
              "scheduledTime": "07:00",
              "programTitle": "Зверобой ",
              "isAvailable": true
            },
            {
              "scheduledTime": "09:55",
              "programTitle": "Улицы разбитых фонарей ",
              "isAvailable": true
            },
            {
              "scheduledTime": "11:30",
              "programTitle": "Утро. Самое лучшее ",
              "isAvailable": true
            },
            {
              "scheduledTime": "13:00",
              "programTitle": "Сегодня ",
              "isAvailable": true
            },
            {
              "scheduledTime": "13:25",
              "programTitle": "Мои университеты. Будущее за настоящим ",
              "isAvailable": true
            },
            {
              "scheduledTime": "14:25",
              "programTitle": "Морские дьяволы ",
              "isAvailable": true
            },
            {
              "scheduledTime": "15:00",
              "programTitle": "Сегодня ",
              "isAvailable": true
            },
            {
              "scheduledTime": "15:35",
              "programTitle": "Морские дьяволы ",
              "isAvailable": true
            },
            {
              "scheduledTime": "16:00",
              "programTitle": "Морские дьяволы. Северные рубежи ",
              "isAvailable": true
            },
            {
              "scheduledTime": "18:00",
              "programTitle": "Сегодня ",
              "isAvailable": false
            },
            {
              "scheduledTime": "18:25",
              "programTitle": "ЧП ",
              "isAvailable": false
            },
            {
              "scheduledTime": "19:00",
              "programTitle": "Место встречи ",
              "isAvailable": false
            },
            {
              "scheduledTime": "21:00",
              "programTitle": "Сегодня ",
              "isAvailable": false
            },
            {
              "scheduledTime": "21:45",
              "programTitle": "ДНК ",
              "isAvailable": false
            },
            {
              "scheduledTime": "22:55",
              "programTitle": "Жди меня ",
              "isAvailable": false
            }
          ]
        },
        {
          "day": "Tomorrow",
          "tvPrograms": [
            {
              "scheduledTime": "00:00",
              "programTitle": "Сегодня ",
              "isAvailable": false
            },
            {
              "scheduledTime": "01:00",
              "programTitle": "Тверская ",
              "isAvailable": false
            },
            {
              "scheduledTime": "03:10",
              "programTitle": "Балабол ",
              "isAvailable": false
            },
            {
              "scheduledTime": "05:00",
              "programTitle": "Своя правда ",
              "isAvailable": false
            },
            {
              "scheduledTime": "06:45",
              "programTitle": "Захар Прилепин. Уроки русского ",
              "isAvailable": false
            },
            {
              "scheduledTime": "07:10",
              "programTitle": "Квартирный вопрос ",
              "isAvailable": false
            },
            {
              "scheduledTime": "08:05",
              "programTitle": "Зверобой ",
              "isAvailable": false
            },
            {
              "scheduledTime": "10:05",
              "programTitle": "Спето в СССР ",
              "isAvailable": false
            },
            {
              "scheduledTime": "10:50",
              "programTitle": "Инспектор Купер ",
              "isAvailable": false
            },
            {
              "scheduledTime": "12:30",
              "programTitle": "Смотр ",
              "isAvailable": false
            },
            {
              "scheduledTime": "13:00",
              "programTitle": "Сегодня ",
              "isAvailable": false
            },
            {
              "scheduledTime": "13:20",
              "programTitle": "Поедем, поедим! ",
              "isAvailable": false
            },
            {
              "scheduledTime": "14:20",
              "programTitle": "Едим Дома ",
              "isAvailable": false
            },
            {
              "scheduledTime": "15:00",
              "programTitle": "Сегодня ",
              "isAvailable": false
            },
            {
              "scheduledTime": "15:20",
              "programTitle": "Главная дорога ",
              "isAvailable": false
            },
            {
              "scheduledTime": "16:00",
              "programTitle": "Живая еда с Сергеем Малоземовым ",
              "isAvailable": false
            },
            {
              "scheduledTime": "17:00",
              "programTitle": "Квартирный вопрос ",
              "isAvailable": false
            },
            {
              "scheduledTime": "18:00",
              "programTitle": "Секрет на миллион (Светлана Мастеркова) ",
              "isAvailable": false
            },
            {
              "scheduledTime": "20:00",
              "programTitle": "Своя игра ",
              "isAvailable": false
            },
            {
              "scheduledTime": "21:00",
              "programTitle": "Сегодня ",
              "isAvailable": false
            },
            {
              "scheduledTime": "21:20",
              "programTitle": "ЧП. Расследование ",
              "isAvailable": false
            },
            {
              "scheduledTime": "22:00",
              "programTitle": "Следствие вели... ",
              "isAvailable": false
            }
          ]
        }
      ],
      "showController": true,
      "playVideoFromAsset": false,
      "assetPath": "",
      "seasonIndex": 0,
      "episodeIndex": 0,
      "isMegogo": false,
      "isPremier": false,
      "videoId": "",
      "sessionId": "6359030c69f8757e33f21056",
      "megogoAccessToken": "MToxMTc4NDM5Njc2OjE2NjY3ODEzNzU6OmJlY2E2ZjA1NTg5YzE4YzMwMTNiNTNhNTNlNDgxODcy",
      "authorization": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2NDcyNTUzNzcsImlzcyI6InVzZXIiLCJyb2xlIjoiY3VzdG9tZXIiLCJzdWIiOiI1MzYyOWEwZS1lN2ExLTQ4YmQtYjZjMS05MDFiODIxNDc3OTgifQ.k2wBnwN_CEQ1m3Hhfj7xN2-HN7vNd0HQE0lxTvp7mhw",
      "autoText": "Автонастройка",
      "baseUrl": "https://api.spec.sharqtv.udevs.io/v1/",
      "isStory": false,
      "story": [

      ],
      "storyButtonText": "Смотреть фильм",
      "closeText": "Закрыть",
      "seasonText": "сезон",
      "storyIndex": 0
    });
    return UdevsVideoPlayerPlatform.instance.playVideo(
      playerConfigJsonString: jsonStringConfig,
    );
  }

  Future<dynamic> closeVideo() {
    return UdevsVideoPlayerPlatform.instance.closeVideo();
  }
}
