import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:udevs_video_player/models/movie_track.dart';
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
    // Future.delayed(const Duration(seconds: 15), () {
    //   _udevsVideoPlayerPlugin.closeVideo();
    // });
    List<Season> seasons = [];
    List<Movie> movies1 = [];
    List<Story> story = [];
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
    story.add(
      Story(
        id: "6343dbbf190cf6f120114de7",
        title: "test2",
        slug: "test2",
        quality: "auto",
        fileName:
            'https://cdn.sharqtv.udevs.io/sharqtv/videos/d4b2982e213c9c201de32589183d929a/master.m3u8',
        duration: 139,
        isWatched: false,
        isAmediateka: false,
      ),
    );
    story.add(
      Story(
        id: "6343db82190cf6f120114971",
        title: "test",
        slug: "test-Gqt8Ye69v",
        quality: "auto",
        fileName:
            "https://cdn.sharqtv.udevs.io/sharqtv/videos/9bcb4e58ff4241173d105ae1feac8f37/master.m3u8",
        duration: 139,
        isWatched: false,
        isAmediateka: false,
      ),
    );
    story.add(
      Story(
        id: "6343da92190cf6f1201131b9",
        title: "Game Of Thrones",
        slug: "game-of-thrones-u3lUc0ND6",
        quality: "auto",
        fileName:
            "https://cdn.sharqtv.udevs.io/sharqtv/videos/835670534eb8c561b112389f55885415/master.m3u8",
        duration: 208,
        isWatched: false,
        isAmediateka: false,
      ),
    );
    story.add(
      Story(
        id: "633be08b1999749a268caac2",
        title: "minions",
        slug: "minions",
        quality: "auto",
        fileName:
            "https://cdn.sharqtv.udevs.io/sharqtv/videos/c4ad656b0e0d344ccf6597e39344b9ab/master.m3u8",
        duration: 660,
        isWatched: false,
        isAmediateka: false,
      ),
    );
    seasons.add(Season(title: '1 Season', movies: movies1));
    try {
      var s = await _udevsVideoPlayerPlugin.playVideo(
              playerConfig: PlayerConfiguration(
            type: PlayerType.serial,
            movieTrack: MovieTrack(
              episodeKey: '',
              element: '',
              seasonKey: '',
              isMegogo: false,
              movieKey: '',
              seconds: 0,
              userId: '',
            ),
            platform: "",
            story: story,
            storyIndex: 0,
            seasonText: "Season",
            closeText: "Close",
            storyButtonText: "",
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
            title:
                "S1 E1  \"Женщина-Халк: Адвокат\" \"Женщина-Халк: Адвокат\" \"Женщина-Халк: Адвокат\" ",
            episodeButtonText: 'Эпизоды',
            nextButtonText: 'След.эпизод',
            seasons: seasons,
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
            userId: '',
          )) ??
          'nothing';
      if (s == 'nothing') {
        print('nothing');
      } else {
        Map<String, dynamic> t = jsonDecode(s);
        print(t);
      }
      if (kDebugMode) {
        print('result123: $s 1');
      }
    } on PlatformException {
      debugPrint('Failed to get platform version.');
    }
  }

  playStory() async {
    List<Season> seasons = [];
    List<Movie> movies1 = [];
    List<Story> story = [];
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
    story.add(
      Story(
        id: "6343dbbf190cf6f120114de7",
        title: "test2",
        slug: "test2",
        quality: "auto",
        fileName:
            'https://cdn.sharqtv.udevs.io/sharqtv/videos/d4b2982e213c9c201de32589183d929a/master.m3u8',
        duration: 139,
        isWatched: false,
        isAmediateka: false,
      ),
    );
    story.add(
      Story(
        id: "6343db82190cf6f120114971",
        title: "test",
        slug: "test-Gqt8Ye69v",
        quality: "auto",
        fileName:
            "https://cdn.sharqtv.udevs.io/sharqtv/videos/9bcb4e58ff4241173d105ae1feac8f37/master.m3u8",
        duration: 139,
        isWatched: false,
        isAmediateka: false,
      ),
    );
    story.add(
      Story(
        id: "6343da92190cf6f1201131b9",
        title: "Game Of Thrones",
        slug: "game-of-thrones-u3lUc0ND6",
        quality: "auto",
        fileName:
            "https://cdn.sharqtv.udevs.io/sharqtv/videos/835670534eb8c561b112389f55885415/master.m3u8",
        duration: 208,
        isWatched: false,
        isAmediateka: false,
      ),
    );
    story.add(
      Story(
        id: "633be08b1999749a268caac2",
        title: "minions",
        slug: "minions",
        quality: "auto",
        fileName:
            "https://cdn.sharqtv.udevs.io/sharqtv/videos/c4ad656b0e0d344ccf6597e39344b9ab/master.m3u8",
        duration: 660,
        isWatched: false,
        isAmediateka: false,
      ),
    );
    seasons.add(Season(title: '1 Season', movies: movies1));
    try {
      var s = await _udevsVideoPlayerPlugin.playVideo(
              playerConfig: PlayerConfiguration(
            type: PlayerType.story,
            platform: "",
            seasonText: "Season",
            story: story,
            storyIndex: 1,
            closeText: 'Close',
            movieTrack: MovieTrack(
              episodeKey: '',
              element: '',
              seasonKey: '',
              isMegogo: false,
              movieKey: '',
              seconds: 0,
              userId: '',
            ),
            storyButtonText: "Смотреть фильм",
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
            episodeButtonText: 'Эпизоды',
            nextButtonText: 'След.эпизод',
            seasons: seasons,
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
            userId: '',
          )) ??
          'nothing';
      if (s == 'nothing') {
        print('nothing');
      } else {
        Map<String, dynamic> t = jsonDecode(s);
        print(t);
      }
      if (kDebugMode) {
        print('result123: $s 1');
      }
    } on PlatformException {
      debugPrint('Failed to get platform version.');
    }
  }

  playTV() async {
    List<ProgramsInfo> programsInfoList = [];
    List<TvProgram> tvPrograms = [];
    tvPrograms.add(TvProgram(
        isAvailable: true,
        scheduledTime: '09:00',
        programTitle: 'Забытое и погребенное, 1 сезон, 3 эп. Суррей.'));
    tvPrograms.add(TvProgram(
        isAvailable: true,
        scheduledTime: '09:00',
        programTitle: 'Забытое и погребенное, 1 сезон, 3 эп. Суррей.'));
    tvPrograms.add(TvProgram(
        isAvailable: true,
        scheduledTime: '09:00',
        programTitle: 'Забытое и погребенное, 1 сезон, 3 эп. Суррей.'));
    tvPrograms.add(TvProgram(
        isAvailable: true,
        scheduledTime: '09:00',
        programTitle: 'Забытое и погребенное, 1 сезон, 3 эп. Суррей.'));
    tvPrograms.add(TvProgram(
        isAvailable: true,
        scheduledTime: '09:00',
        programTitle: 'Забытое и погребенное, 1 сезон, 3 эп. Суррей.'));
    tvPrograms.add(TvProgram(
        isAvailable: true,
        scheduledTime: '09:00',
        programTitle: 'Забытое и погребенное, 1 сезон, 3 эп. Суррей.'));
    tvPrograms.add(TvProgram(
        isAvailable: true,
        scheduledTime: '09:00',
        programTitle: 'Забытое и погребенное, 1 сезон, 3 эп. Суррей.'));
    tvPrograms.add(TvProgram(
        isAvailable: true,
        scheduledTime: '09:00',
        programTitle: 'Забытое и погребенное, 1 сезон, 3 эп. Суррей.'));
    tvPrograms.add(TvProgram(
        isAvailable: true,
        scheduledTime: '09:00',
        programTitle: 'Забытое и погребенное, 1 сезон, 3 эп. Суррей.'));
    tvPrograms.add(TvProgram(
        isAvailable: true,
        scheduledTime: '09:00',
        programTitle: 'Забытое и погребенное, 1 сезон, 3 эп. Суррей.'));
    programsInfoList.add(ProgramsInfo(day: 'Today', tvPrograms: tvPrograms));
    programsInfoList.add(ProgramsInfo(day: 'Tomorrow', tvPrograms: tvPrograms));
    try {
      var s = await _udevsVideoPlayerPlugin.playVideo(
              playerConfig: PlayerConfiguration(
            type: PlayerType.tv,
            movieTrack: MovieTrack(
              episodeKey: '',
              element: '',
              seasonKey: '',
              isMegogo: false,
              movieKey: '',
              seconds: 0,
              userId: '',
            ),
            platform: "",
            storyIndex: 0,
            story: [],
            seasonText: 'Сезон',
            closeText: "",
            storyButtonText: "",
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
            episodeButtonText: 'Episodes',
            nextButtonText: 'Next',
            seasons: [],
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
            userId: '',
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
              ElevatedButton(
                onPressed: playStory,
                child: const Text('Play Story'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
