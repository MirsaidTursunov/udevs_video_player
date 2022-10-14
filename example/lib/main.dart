import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:udevs_video_player/udevs_video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _udevsVideoPlayerPlugin = UdevsVideoPlayer();

  playVideo() async {
    List<Season> seasons = [];
    List<Movie> movies1 = [];
    movies1.add(Movie(
      id: '22109',
      title: 'Женщина-Халк: Адвокат',
      description:
          'После переливания крови двоюродная сестра Брюса Бэннера юристка Дженнифер Уолтерс получает способность во время стресса перевоплощаться в сверхсильное существо. Дженнифер предстоит научиться управлять этим даром и применять его во благо при этом продолжать работать в недавно созданном Отделе по правам сверхлюдей.',
      image:
          'https://cdn.uzd.udevs.io/uzdigital/images/ec80c248-ddb8-4b68-98b1-0d59e9a1acdd.jpg',
      duration: 2122,
      resolutions: {
        'Автонастройка':
            'https://cdn.uzd.udevs.io/uzdigital/videos/772a7a12977cd08a10b6f6843ae80563/master.m3u8',
        '1080p':
            'https://cdn.uzd.udevs.io/uzdigital/videos/772a7a12977cd08a10b6f6843ae80563/1080p/index.m3u8',
        '720p':
            'https://cdn.uzd.udevs.io/uzdigital/videos/772a7a12977cd08a10b6f6843ae80563/720p/index.m3u8',
        '480p':
            'https://cdn.uzd.udevs.io/uzdigital/videos/772a7a12977cd08a10b6f6843ae80563/480p/index.m3u8',
        '360p':
            'https://cdn.uzd.udevs.io/uzdigital/videos/772a7a12977cd08a10b6f6843ae80563/360p/index.m3u8',
        '240p':
            'https://cdn.uzd.udevs.io/uzdigital/videos/772a7a12977cd08a10b6f6843ae80563/240p/index.m3u8',
      },
    ));
    movies1.add(Movie(
      id: '22110',
      title: 'Женщина-Халк: Адвокат',
      description:
          'После переливания крови двоюродная сестра Брюса Бэннера юристка Дженнифер Уолтерс получает способность во время стресса перевоплощаться в сверхсильное существо. Дженнифер предстоит научиться управлять этим даром и применять его во благо при этом продолжать работать в недавно созданном Отделе по правам сверхлюдей.',
      image:
          'https://cdn.uzd.udevs.io/uzdigital/images/ec80c248-ddb8-4b68-98b1-0d59e9a1acdd.jpg',
      duration: 1669,
      resolutions: {
        'Автонастройка':
            'https://cdn.uzd.udevs.io/uzdigital/videos/a298d71ece9105727c7c2e3bc219ef86/master.m3u8',
        '1080p':
            'https://cdn.uzd.udevs.io/uzdigital/videos/a298d71ece9105727c7c2e3bc219ef86/1080p/index.m3u8',
        '720p':
            'https://cdn.uzd.udevs.io/uzdigital/videos/a298d71ece9105727c7c2e3bc219ef86/720p/index.m3u8',
        '480p':
            'https://cdn.uzd.udevs.io/uzdigital/videos/a298d71ece9105727c7c2e3bc219ef86/480p/index.m3u8',
        '360p':
            'https://cdn.uzd.udevs.io/uzdigital/videos/a298d71ece9105727c7c2e3bc219ef86/360p/index.m3u8',
        '240p':
            'https://cdn.uzd.udevs.io/uzdigital/videos/a298d71ece9105727c7c2e3bc219ef86/240p/index.m3u8',
      },
    ));
    seasons.add(Season(title: '1 Season', movies: movies1));
    try {
      var s = await _udevsVideoPlayerPlugin.playVideo(
              playerConfig: PlayerConfiguration(
            isStory: true,
            story: [
              {
                "id": 1526909,
                "width": 1920,
                "height": 1080,
                "duration": 10,
                "tags": [],
                "url":
                    "https://www.pexels.com/video/seal-on-the-beach-1526909/",
                "image":
                    "https://images.pexels.com/videos/1526909/free-video-1526909.jpg?auto=compress&cs=tinysrgb&fit=crop&h=630&w=1200",
                "user": {
                  "id": 574687,
                  "name": "Ruvim Miksanskiy",
                  "url": "https://www.pexels.com/@digitech"
                },
                "video_files": [
                  {
                    "id": 61368,
                    "quality": "hd",
                    "file_type": "video/mp4",
                    "width": 1920,
                    "height": 1080,
                    "link":
                        "https://player.vimeo.com/external/296210754.sd.mp4?s=9db41d71fa61a2cc19757f656fc5c5c5ef9f69ec&profile_id=165&oauth2_token_id=57447761"
                  },
                  {
                    "id": 61369,
                    "quality": "sd",
                    "file_type": "video/mp4",
                    "width": 960,
                    "height": 540,
                    "link":
                        "https://player.vimeo.com/external/299968768.sd.mp4?s=b0bf33e4823817a366f1a8672e9a913e7b70c8b0&profile_id=164&oauth2_token_id=57447761"
                  },
                  {
                    "id": 61370,
                    "quality": "hd",
                    "file_type": "video/mp4",
                    "width": 1280,
                    "height": 720,
                    "link":
                        "https://player.vimeo.com/external/289258217.sd.mp4?s=50b11b521df767740fa56e4743159474f540afa2&profile_id=164&oauth2_token_id=57447761"
                  },
                  {
                    "id": 61371,
                    "quality": "sd",
                    "file_type": "video/mp4",
                    "width": 640,
                    "height": 360,
                    "link":
                        "https://player.vimeo.com/external/189545487.sd.mp4?s=8cd2af1ec08f7ce121a5a6a09c78c05237943524&profile_id=165&oauth2_token_id=57447761"
                  },
                  {
                    "id": 61372,
                    "quality": "hls",
                    "file_type": "video/mp4",
                    "width": 0,
                    "height": 0,
                    "link":
                        "https://player.vimeo.com/external/297927791.sd.mp4?s=5ceeec8c83fcb634312c157cc101b8bd19969b61&profile_id=165&oauth2_token_id=57447761"
                  }
                ]
              },
              {
                "id": 1409899,
                "width": 3840,
                "height": 2160,
                "duration": 21,
                "full_res": null,
                "tags": [],
                "url":
                    "https://www.pexels.com/video/waves-rushing-and-splashing-to-the-shore-1409899/",
                "image":
                    "https://images.pexels.com/videos/1409899/free-video-1409899.jpg?auto=compress&cs=tinysrgb&fit=crop&h=630&w=1200",
                "user": {
                  "id": 439094,
                  "name": "Michal Marek",
                  "url": "https://www.pexels.com/@michalmarek"
                },
                "video_files": [
                  {
                    "id": 61368,
                    "quality": "hd",
                    "file_type": "video/mp4",
                    "width": 1920,
                    "height": 1080,
                    "link":
                        "https://player.vimeo.com/external/296210754.sd.mp4?s=9db41d71fa61a2cc19757f656fc5c5c5ef9f69ec&profile_id=165&oauth2_token_id=57447761"
                  },
                  {
                    "id": 61369,
                    "quality": "sd",
                    "file_type": "video/mp4",
                    "width": 960,
                    "height": 540,
                    "link":
                        "https://player.vimeo.com/external/299968768.sd.mp4?s=b0bf33e4823817a366f1a8672e9a913e7b70c8b0&profile_id=164&oauth2_token_id=57447761"
                  },
                  {
                    "id": 61370,
                    "quality": "hd",
                    "file_type": "video/mp4",
                    "width": 1280,
                    "height": 720,
                    "link":
                        "https://player.vimeo.com/external/289258217.sd.mp4?s=50b11b521df767740fa56e4743159474f540afa2&profile_id=164&oauth2_token_id=57447761"
                  },
                  {
                    "id": 61371,
                    "quality": "sd",
                    "file_type": "video/mp4",
                    "width": 640,
                    "height": 360,
                    "link":
                        "https://player.vimeo.com/external/189545487.sd.mp4?s=8cd2af1ec08f7ce121a5a6a09c78c05237943524&profile_id=165&oauth2_token_id=57447761"
                  },
                  {
                    "id": 61372,
                    "quality": "hls",
                    "file_type": "video/mp4",
                    "width": 0,
                    "height": 0,
                    "link":
                        "https://player.vimeo.com/external/297927791.sd.mp4?s=5ceeec8c83fcb634312c157cc101b8bd19969b61&profile_id=165&oauth2_token_id=57447761"
                  }
                ]
              },
              {
                "id": 857251,
                "width": 1920,
                "height": 1280,
                "duration": 14,
                "tags": [],
                "url":
                    "https://www.pexels.com/video/beautiful-timelapse-of-the-night-sky-with-reflections-in-a-lake-857251/",
                "image":
                    "https://images.pexels.com/videos/857251/free-video-857251.jpg?auto=compress&cs=tinysrgb&fit=crop&h=630&w=1200",
                "user": {
                  "id": 121938,
                  "name": "eberhard grossgasteiger",
                  "url": "https://www.pexels.com/@eberhardgross"
                },
                "video_files": [
                  {
                    "id": 61368,
                    "quality": "hd",
                    "file_type": "video/mp4",
                    "width": 1920,
                    "height": 1080,
                    "link":
                        "https://player.vimeo.com/external/296210754.sd.mp4?s=9db41d71fa61a2cc19757f656fc5c5c5ef9f69ec&profile_id=165&oauth2_token_id=57447761"
                  },
                  {
                    "id": 61369,
                    "quality": "sd",
                    "file_type": "video/mp4",
                    "width": 960,
                    "height": 540,
                    "link":
                        "https://player.vimeo.com/external/299968768.sd.mp4?s=b0bf33e4823817a366f1a8672e9a913e7b70c8b0&profile_id=164&oauth2_token_id=57447761"
                  },
                  {
                    "id": 61370,
                    "quality": "hd",
                    "file_type": "video/mp4",
                    "width": 1280,
                    "height": 720,
                    "link":
                        "https://player.vimeo.com/external/289258217.sd.mp4?s=50b11b521df767740fa56e4743159474f540afa2&profile_id=164&oauth2_token_id=57447761"
                  },
                  {
                    "id": 61371,
                    "quality": "sd",
                    "file_type": "video/mp4",
                    "width": 640,
                    "height": 360,
                    "link":
                        "https://player.vimeo.com/external/189545487.sd.mp4?s=8cd2af1ec08f7ce121a5a6a09c78c05237943524&profile_id=165&oauth2_token_id=57447761"
                  },
                  {
                    "id": 61372,
                    "quality": "hls",
                    "file_type": "video/mp4",
                    "width": 0,
                    "height": 0,
                    "link":
                        "https://player.vimeo.com/external/297927791.sd.mp4?s=5ceeec8c83fcb634312c157cc101b8bd19969b61&profile_id=165&oauth2_token_id=57447761"
                  }
                ]
              },
              {
                "id": 856973,
                "width": 4096,
                "height": 2304,
                "duration": 14,
                "full_res": 0,
                "tags": [],
                "url":
                    "https://www.pexels.com/video/time-lapse-video-sunset-856973/",
                "image":
                    "https://images.pexels.com/videos/856973/free-video-856973.jpg?auto=compress&cs=tinysrgb&fit=crop&h=630&w=1200",
                "avg_color": 0,
                "user": {
                  "id": 2659,
                  "name": "Pixabay",
                  "url": "https://www.pexels.com/@pixabay"
                },
                "video_files": [
                  {
                    "id": 61368,
                    "quality": "hd",
                    "file_type": "video/mp4",
                    "width": 1920,
                    "height": 1080,
                    "link":
                        "https://player.vimeo.com/external/296210754.sd.mp4?s=9db41d71fa61a2cc19757f656fc5c5c5ef9f69ec&profile_id=165&oauth2_token_id=57447761"
                  },
                  {
                    "id": 61369,
                    "quality": "sd",
                    "file_type": "video/mp4",
                    "width": 960,
                    "height": 540,
                    "link":
                        "https://player.vimeo.com/external/299968768.sd.mp4?s=b0bf33e4823817a366f1a8672e9a913e7b70c8b0&profile_id=164&oauth2_token_id=57447761"
                  },
                  {
                    "id": 61370,
                    "quality": "hd",
                    "file_type": "video/mp4",
                    "width": 1280,
                    "height": 720,
                    "link":
                        "https://player.vimeo.com/external/289258217.sd.mp4?s=50b11b521df767740fa56e4743159474f540afa2&profile_id=164&oauth2_token_id=57447761"
                  },
                  {
                    "id": 61371,
                    "quality": "sd",
                    "file_type": "video/mp4",
                    "width": 640,
                    "height": 360,
                    "link":
                        "https://player.vimeo.com/external/189545487.sd.mp4?s=8cd2af1ec08f7ce121a5a6a09c78c05237943524&profile_id=165&oauth2_token_id=57447761"
                  },
                  {
                    "id": 61372,
                    "quality": "hls",
                    "file_type": "video/mp4",
                    "width": 0,
                    "height": 0,
                    "link":
                        "https://player.vimeo.com/external/297927791.sd.mp4?s=5ceeec8c83fcb634312c157cc101b8bd19969b61&profile_id=165&oauth2_token_id=57447761"
                  }
                ]
              },
              {
                "id": 857195,
                "width": 1280,
                "height": 720,
                "duration": 7,
                "tags": [],
                "url":
                    "https://www.pexels.com/video/time-lapse-video-of-night-sky-857195/",
                "image":
                    "https://images.pexels.com/videos/857195/free-video-857195.jpg?auto=compress&cs=tinysrgb&fit=crop&h=630&w=1200",
                "user": {
                  "id": 290933,
                  "name": "Vimeo",
                  "url": "https://www.pexels.com/@vimeo"
                },
                "video_files": [
                  {
                    "id": 61368,
                    "quality": "hd",
                    "file_type": "video/mp4",
                    "width": 1920,
                    "height": 1080,
                    "link":
                        "https://player.vimeo.com/external/296210754.sd.mp4?s=9db41d71fa61a2cc19757f656fc5c5c5ef9f69ec&profile_id=165&oauth2_token_id=57447761"
                  },
                  {
                    "id": 61369,
                    "quality": "sd",
                    "file_type": "video/mp4",
                    "width": 960,
                    "height": 540,
                    "link":
                        "https://player.vimeo.com/external/299968768.sd.mp4?s=b0bf33e4823817a366f1a8672e9a913e7b70c8b0&profile_id=164&oauth2_token_id=57447761"
                  },
                  {
                    "id": 61370,
                    "quality": "hd",
                    "file_type": "video/mp4",
                    "width": 1280,
                    "height": 720,
                    "link":
                        "https://player.vimeo.com/external/289258217.sd.mp4?s=50b11b521df767740fa56e4743159474f540afa2&profile_id=164&oauth2_token_id=57447761"
                  },
                  {
                    "id": 61371,
                    "quality": "sd",
                    "file_type": "video/mp4",
                    "width": 640,
                    "height": 360,
                    "link":
                        "https://player.vimeo.com/external/189545487.sd.mp4?s=8cd2af1ec08f7ce121a5a6a09c78c05237943524&profile_id=165&oauth2_token_id=57447761"
                  },
                  {
                    "id": 61372,
                    "quality": "hls",
                    "file_type": "video/mp4",
                    "width": 0,
                    "height": 0,
                    "link":
                        "https://player.vimeo.com/external/297927791.sd.mp4?s=5ceeec8c83fcb634312c157cc101b8bd19969b61&profile_id=165&oauth2_token_id=57447761"
                  }
                ]
              }
            ],
            baseUrl: "https://api.spec.uzd.udevs.io/v1/",
            initialResolution: {
              "Автонастройка":
                  "https://cdn.uzd.udevs.io/uzdigital/videos/772a7a12977cd08a10b6f6843ae80563/master.m3u8"
            },
            resolutions: {
              "Автонастройка":
                  "https://cdn.uzd.udevs.io/uzdigital/videos/772a7a12977cd08a10b6f6843ae80563/master.m3u8",
              "1080p":
                  "https://cdn.uzd.udevs.io/uzdigital/videos/772a7a12977cd08a10b6f6843ae80563/1080p/index.m3u8",
              "720p":
                  "https://cdn.uzd.udevs.io/uzdigital/videos/772a7a12977cd08a10b6f6843ae80563/720p/index.m3u8",
              "480p":
                  "https://cdn.uzd.udevs.io/uzdigital/videos/772a7a12977cd08a10b6f6843ae80563/480p/index.m3u8",
              "360p":
                  "https://cdn.uzd.udevs.io/uzdigital/videos/772a7a12977cd08a10b6f6843ae80563/360p/index.m3u8",
              "240p":
                  "https://cdn.uzd.udevs.io/uzdigital/videos/772a7a12977cd08a10b6f6843ae80563/240p/index.m3u8"
            },
            qualityText: 'Качество',
            speedText: 'Скорость',
            lastPosition: 0,
            title: "S1 E1  \"Женщина-Халк: Адвокат\" ",
            isSerial: true,
            episodeButtonText: 'Эпизоды',
            nextButtonText: 'След.эпизод',
            seasons: seasons,
            isLive: false,
            tvProgramsText: 'Телеканалы',
            programsInfoList: [],
            showController: true,
            playVideoFromAsset: false,
            assetPath: '',
            seasonIndex: 0,
            episodeIndex: 0,
            isMegogo: false,
            isPremier: true,
            videoId: '5178',
            sessionId: '633fad58c2c2e7a4241ab508',
            megogoAccessToken:
                'MToxMTYyNDQ1NDA2OjE2NjUxMTc1NTY6OjY3ZTI2MzVkYzY0Mzk2N2UwMjZhOGVjNWQ5MDA3OGFm',
            authorization:
                'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2NTg1MDEzNDMsImlzcyI6InVzZXIiLCJwaWQiOjEzMDcsInJvbGUiOiJjdXN0b21lciIsInN1YiI6IjYyMDQzMmZmLTc3ZWItNDc0Mi05MmFhLTZmOGU4NDcyMDI0ZCJ9.6SvUCBT0gb6tIRy1PL-C7WS7xHpJXc1PCZky6aH6HtA',
            autoText: 'Автонастройка',
          )) ??
          'nothing';
      if (kDebugMode) {
        print('result: $s');
      }
    } on PlatformException {
      debugPrint('Failed to get platform version.');
    }
  }

  playTV() async {
    List<ProgramsInfo> programsInfoList = [];
    List<TvProgram> tvPrograms = [];
    tvPrograms.add(TvProgram(
        scheduledTime: '09:00',
        programTitle: 'Забытое и погребенное, 1 сезон, 3 эп. Суррей.'));
    tvPrograms.add(TvProgram(
        scheduledTime: '09:00',
        programTitle: 'Забытое и погребенное, 1 сезон, 3 эп. Суррей.'));
    tvPrograms.add(TvProgram(
        scheduledTime: '09:00',
        programTitle: 'Забытое и погребенное, 1 сезон, 3 эп. Суррей.'));
    tvPrograms.add(TvProgram(
        scheduledTime: '09:00',
        programTitle: 'Забытое и погребенное, 1 сезон, 3 эп. Суррей.'));
    tvPrograms.add(TvProgram(
        scheduledTime: '09:00',
        programTitle: 'Забытое и погребенное, 1 сезон, 3 эп. Суррей.'));
    tvPrograms.add(TvProgram(
        scheduledTime: '09:00',
        programTitle: 'Забытое и погребенное, 1 сезон, 3 эп. Суррей.'));
    tvPrograms.add(TvProgram(
        scheduledTime: '09:00',
        programTitle: 'Забытое и погребенное, 1 сезон, 3 эп. Суррей.'));
    tvPrograms.add(TvProgram(
        scheduledTime: '09:00',
        programTitle: 'Забытое и погребенное, 1 сезон, 3 эп. Суррей.'));
    tvPrograms.add(TvProgram(
        scheduledTime: '09:00',
        programTitle: 'Забытое и погребенное, 1 сезон, 3 эп. Суррей.'));
    tvPrograms.add(TvProgram(
        scheduledTime: '09:00',
        programTitle: 'Забытое и погребенное, 1 сезон, 3 эп. Суррей.'));
    programsInfoList
        .add(ProgramsInfo(day: 'Yesterday', tvPrograms: tvPrograms));
    programsInfoList.add(ProgramsInfo(day: 'Today', tvPrograms: tvPrograms));
    programsInfoList.add(ProgramsInfo(day: 'Tomorrow', tvPrograms: tvPrograms));
    try {
      var s = await _udevsVideoPlayerPlugin.playVideo(
              playerConfig: PlayerConfiguration(
            isStory: false,
            story: [],
            baseUrl: "https://api.spec.uzd.udevs.io/v1/",
            initialResolution: {
              'Auto':
                  'https://flus.st.uz/3017/video.m3u8?token=da6e83609a647029700b8f7cf246e0efc5ee1692-2887490519--'
            },
            resolutions: {
              'Auto':
                  'https://flus.st.uz/3017/video.m3u8?token=da6e83609a647029700b8f7cf246e0efc5ee1692-2887490519--',
              '1080p':
                  'https://flus.st.uz/3017/video.m3u8?token=da6e83609a647029700b8f7cf246e0efc5ee1692-2887490519--',
              '720p':
                  'https://flus.st.uz/3017/video.m3u8?token=da6e83609a647029700b8f7cf246e0efc5ee1692-2887490519--',
              '480p':
                  'https://flus.st.uz/3017/video.m3u8?token=da6e83609a647029700b8f7cf246e0efc5ee1692-2887490519--',
              '360p':
                  'https://flus.st.uz/3017/video.m3u8?token=da6e83609a647029700b8f7cf246e0efc5ee1692-2887490519--',
              '240p':
                  'https://flus.st.uz/3017/video.m3u8?token=da6e83609a647029700b8f7cf246e0efc5ee1692-2887490519--',
            },
            qualityText: 'Quality',
            speedText: 'Speed',
            lastPosition: 1000,
            title: 'Женщина-Халк: Адвокат',
            isSerial: false,
            episodeButtonText: 'Episodes',
            nextButtonText: 'Next',
            seasons: [],
            isLive: true,
            tvProgramsText: 'Programs',
            programsInfoList: programsInfoList,
            showController: true,
            playVideoFromAsset: false,
            assetPath: 'assets/splash.mp4',
            seasonIndex: 0,
            episodeIndex: 0,
            isMegogo: false,
            isPremier: false,
            videoId: '',
            sessionId: '',
            megogoAccessToken: '',
            authorization: '',
            autoText: 'Автонастройка',
          )) ??
          'nothing';
      if (kDebugMode) {
        print('result: $s');
      }
    } on PlatformException {
      debugPrint('Failed to get platform version.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: playVideo,
                child: const Text('Play Video'),
              ),
              ElevatedButton(
                onPressed: playTV,
                child: const Text('Play TV'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
