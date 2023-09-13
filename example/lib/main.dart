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

  Future<void> playVideo() async {
    final List<Season> seasons = [];
    final List<Movie> movies1 = [
      Movie(
        id: '22109',
        title: 'Женщина-Халк: Адвокат',
        description:
            'После переливания крови двоюродная сестра Брюса Бэннера юристка Дженнифер Уолтерс получает способность во время стресса перевоплощаться в сверхсильное существо. Дженнифер предстоит научиться управлять этим даром и применять его во благо при этом продолжать работать в недавно созданном Отделе по правам сверхлюдей.',
        image:
            'https://cdn.uzd.udevs.io/uzdigital/images/ec80c248-ddb8-4b68-98b1-0d59e9a1acdd.jpg',
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
      ),
      Movie(
        id: '22110',
        title: 'Женщина-Халк: Адвокат',
        description:
            'После переливания крови двоюродная сестра Брюса Бэннера юристка Дженнифер Уолтерс получает способность во время стресса перевоплощаться в сверхсильное существо. Дженнифер предстоит научиться управлять этим даром и применять его во благо при этом продолжать работать в недавно созданном Отделе по правам сверхлюдей.',
        image:
            'https://cdn.uzd.udevs.io/uzdigital/images/ec80c248-ddb8-4b68-98b1-0d59e9a1acdd.jpg',
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
      ),
    ];
    seasons.add(Season(title: '1 Season', movies: movies1));
    try {
      final s = await _udevsVideoPlayerPlugin.playVideo(
              playerConfig: PlayerConfiguration(
            initialResolution: {
              'Автонастройка':
                  'https://cdn.xpertmedia.uz/data/videos/4632c42f040d75c9b45d62ff73af789e/master.m3u8'
            },
            resolutions: {
              'Автонастройка':
                  'https://cdn.xpertmedia.uz/data/videos/4632c42f040d75c9b45d62ff73af789e/master.m3u8',
              '720p':
                  'https://cdn.xpertmedia.uz/data/videos/4632c42f040d75c9b45d62ff73af789e/720p/index.m3u8',
              '480p':
                  'https://cdn.xpertmedia.uz/data/videos/4632c42f040d75c9b45d62ff73af789e/480p/index.m3u8',
              '360p':
                  'https://cdn.xpertmedia.uz/data/videos/4632c42f040d75c9b45d62ff73af789e/360p/index.m3u8',
              '240p':
                  'https://cdn.xpertmedia.uz/data/videos/4632c42f040d75c9b45d62ff73af789e/240p/index.m3u8',
            },
            qualityText: 'Качество',
            speedText: 'Скорость',
            programsText: 'Программы',
            lastPosition: 0,
            title: 'She-Hulk: Lawyer',
            isSerial: false,
            seasons: seasons,
            isYoutube: false,
            showController: true,
            seasonIndex: 0,
            episodeIndex: 0,
            episodeText: 'Episode',
            seasonText: 'Season',
            videoId: '5178',
            sessionId: '63410b44c2c2e7a4241b43a9',
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

  Future<void> playYoutube() async {
    try {
      final s = await _udevsVideoPlayerPlugin.playVideo(
              playerConfig: PlayerConfiguration(
            initialResolution: {
              'Автонастройка':
                  'https://cdn.xpertmedia.uz/data/videos/4632c42f040d75c9b45d62ff73af789e/master.m3u8'
            },
            resolutions: {
              'Автонастройка':
                  'https://cdn.xpertmedia.uz/data/videos/4632c42f040d75c9b45d62ff73af789e/master.m3u8',
              '720p':
                  'https://cdn.xpertmedia.uz/data/videos/4632c42f040d75c9b45d62ff73af789e/720p/index.m3u8',
              '480p':
                  'https://cdn.xpertmedia.uz/data/videos/4632c42f040d75c9b45d62ff73af789e/480p/index.m3u8',
              '360p':
                  'https://cdn.xpertmedia.uz/data/videos/4632c42f040d75c9b45d62ff73af789e/360p/index.m3u8',
              '240p':
                  'https://cdn.xpertmedia.uz/data/videos/4632c42f040d75c9b45d62ff73af789e/240p/index.m3u8',
            },
            qualityText: 'Качество',
            speedText: 'Скорость',
            programsText: 'Программы',
            lastPosition: 0,
            title: 'She-Hulk: Lawyer',
            isSerial: false,
            seasons: [],
            showController: true,
            seasonIndex: 0,
            episodeIndex: 0,
            episodeText: 'Episode',
            seasonText: 'Season',
            sessionId: '63410b44c2c2e7a4241b43a9',
            authorization:
                'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2NTg1MDEzNDMsImlzcyI6InVzZXIiLCJwaWQiOjEzMDcsInJvbGUiOiJjdXN0b21lciIsInN1YiI6IjYyMDQzMmZmLTc3ZWItNDc0Mi05MmFhLTZmOGU4NDcyMDI0ZCJ9.6SvUCBT0gb6tIRy1PL-C7WS7xHpJXc1PCZky6aH6HtA',
            autoText: 'Автонастройка',

            /// youtube
            isYoutube: true,
            videoId: 'ENt1IHininc',
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
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('Plugin example app')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: playVideo,
                  child: const Text('Play Video'),
                ),
                ElevatedButton(
                  onPressed: playYoutube,
                  child: const Text('Play Youtube'),
                ),
              ],
            ),
          ),
        ),
      );
}
