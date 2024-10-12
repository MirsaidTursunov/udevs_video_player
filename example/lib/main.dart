import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:udevs_video_player/models/live_player_configuration.dart';
import 'package:udevs_video_player/udevs_video_player.dart';
import 'package:udevs_video_player_example/second_page.dart';
import 'package:udevs_video_player_example/video_view_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Plugin example',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const MainPage(),
      );
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _udevsVideoPlayerPlugin = UdevsVideoPlayer();

  Future<void> download1() async {
    try {
      final s = await _udevsVideoPlayerPlugin.downloadVideo(
            downloadConfig: const DownloadConfiguration(
              title: 'She-Hulk 2',
              url:
                  'https://cdn.uzd.udevs.io/uzdigital/videos/772a7a12977cd08a10b6f6843ae80563/240p/index.m3u8',
            ),
          ) ??
          'nothing';
      if (kDebugMode) {
        print('result: $s');
      }
    } on PlatformException {
      debugPrint('Failed to get platform version.');
    }
  }

  Future<void> download2() async {
    try {
      final s = await _udevsVideoPlayerPlugin.downloadVideo(
              downloadConfig: const DownloadConfiguration(
            title: 'She-Hulk 2',
            url:
                'https://cdn.uzd.udevs.io/uzdigital/videos/a04c9257216b2f2085c88be31a13e5d7/240p/index.m3u8',
          )) ??
          'nothing';
      if (kDebugMode) {
        print('result: $s');
      }
    } on PlatformException {
      debugPrint('Failed to get platform version.');
    }
  }

  Future<void> pauseDownload() async {
    try {
      final s = await _udevsVideoPlayerPlugin.pauseDownload(
              downloadConfig: const DownloadConfiguration(
            title: 'She-Hulk',
            url:
                'https://cdn.uzd.udevs.io/uzdigital/videos/772a7a12977cd08a10b6f6843ae80563/240p/index.m3u8',
          )) ??
          'nothing';
      if (kDebugMode) {
        print('result: $s');
      }
    } on PlatformException {
      debugPrint('Failed to get platform version.');
    }
  }

  Future<void> resumeDownload() async {
    try {
      final s = await _udevsVideoPlayerPlugin.resumeDownload(
              downloadConfig: const DownloadConfiguration(
            title: 'She-Hulk',
            url:
                'https://cdn.uzd.udevs.io/uzdigital/videos/772a7a12977cd08a10b6f6843ae80563/240p/index.m3u8',
          )) ??
          'nothing';
      if (kDebugMode) {
        print('result: $s');
      }
    } on PlatformException {
      debugPrint('Failed to get platform version.');
    }
  }

  Future<void> removeDownload() async {
    try {
      final s = await _udevsVideoPlayerPlugin.removeDownload(
              downloadConfig: const DownloadConfiguration(
            title: 'She-Hulk',
            url:
                'https://cdn.uzd.udevs.io/uzdigital/videos/772a7a12977cd08a10b6f6843ae80563/240p/index.m3u8',
          )) ??
          'nothing';
      if (kDebugMode) {
        print('result: $s');
      }
    } on PlatformException {
      debugPrint('Failed to get platform version.');
    }
  }

  Future<int> getStateDownload() async {
    int state = -1;
    try {
      state = await _udevsVideoPlayerPlugin.getStateDownload(
              downloadConfig: const DownloadConfiguration(
            title: 'She-Hulk',
            url:
                'https://cdn.uzd.udevs.io/uzdigital/videos/772a7a12977cd08a10b6f6843ae80563/240p/index.m3u8',
          )) ??
          -1;
      if (kDebugMode) {
        print('result: $state');
      }
    } on PlatformException {
      debugPrint('Failed to get platform version.');
    }
    return state;
  }

  Future<bool> checkIsDownloaded() async {
    bool isDownloaded = false;
    try {
      isDownloaded = await _udevsVideoPlayerPlugin.isDownloadVideo(
        downloadConfig: const DownloadConfiguration(
          title: 'She-Hulk',
          url:
              'https://cdn.uzd.udevs.io/uzdigital/videos/772a7a12977cd08a10b6f6843ae80563/240p/index.m3u8',
        ),
      );
      if (kDebugMode) {
        print('result: $isDownloaded');
      }
    } on PlatformException {
      debugPrint('Failed to get platform version.');
    }
    return isDownloaded;
  }

  Stream<MediaItemDownload> currentProgressDownloadAsStream() =>
      _udevsVideoPlayerPlugin.currentProgressDownloadAsStream;

  Future<void> playVideo() async {
    try {
      final s = await _udevsVideoPlayerPlugin.playVideo(
            playerConfig: PlayerConfiguration(
              shareText: 'Check this out',
              defaultText: 'defaultText',
              audioText: 'audioText',
              noneText: 'noneText',
              subtitleText: 'subtitleText',
              movieShareLink: 'https://uzd.udevs.io/movie/7963?type=premier',
              baseUrl: 'https://api.spec.uzd.udevs.io/v1/',
              initialResolution: {
                'Автонастройка':
                    'https://cdn.uzd.udevs.io/uzdigital/videos/bbc795b69faf3c4d1063777f2b220144/master.m3u8'
              },
              resolutions: {
                // 'Auto':
                //     'https://st21.allmovies.uz/proxy/3/map/hls/MTExOjE3MTk2ODMxNDg6MQ--/master.m3u8?t=_jCzFAoIZScf5DiSeoVhIQ&e=1702319880',
                // '720p':
                //     'https://st21.allmovies.uz/proxy/3/map/hls/MTExOjE3MTk2ODMxNDg6MQ--/master.m3u8?t=_jCzFAoIZScf5DiSeoVhIQ&e=1702319880',
                // '1080p':
                //     'https://st21.allmovies.uz/proxy/3/map/hls/MTExOjE3MTk2ODMxNDg6MQ--/master.m3u8?t=_jCzFAoIZScf5DiSeoVhIQ&e=1702319880'
              },
              qualityText: 'Качество',
              speedText: 'Скорость',
              lastPosition: 0,
              title: 'S1 E1  "Женщина-Халк: Адвокат" ',
              isSerial: true,
              episodeButtonText: 'Эпизоды',
              nextButtonText: 'След.эпизод',
              seasons: [
                Season(title: 'Сезон 1', movies: [
                  Movie(
                    id: 260745.toString(),
                    title: 'title',
                    description: 'description  ',
                    image:
                        'https://i.allmovies.uz/i/544726/eyJ3IjozNDAsImgiOjE5MiwiYyI6dHJ1ZX0/image.jpg?t=BJiYKMZv4_WT8yio9YJK_Q',
                    duration: 2894,
                    resolutions: {},
                  ),
                  Movie(
                    id: 260750.toString(),
                    title: 'title',
                    description: 'description  ',
                    image:
                        'https://i.allmovies.uz/i/544726/eyJ3IjozNDAsImgiOjE5MiwiYyI6dHJ1ZX0/image.jpg?t=BJiYKMZv4_WT8yio9YJK_Q',
                    duration: 2894,
                    resolutions: {},
                  ),
                  Movie(
                    id: 260752.toString(),
                    title: 'title',
                    description: 'description  ',
                    image:
                        'https://i.allmovies.uz/i/544726/eyJ3IjozNDAsImgiOjE5MiwiYyI6dHJ1ZX0/image.jpg?t=BJiYKMZv4_WT8yio9YJK_Q',
                    duration: 2894,
                    resolutions: {},
                  ),
                  Movie(
                    id: 260754.toString(),
                    title: 'title',
                    description: 'description  ',
                    image:
                        'https://i.allmovies.uz/i/544726/eyJ3IjozNDAsImgiOjE5MiwiYyI6dHJ1ZX0/image.jpg?t=BJiYKMZv4_WT8yio9YJK_Q',
                    duration: 2894,
                    resolutions: {},
                  ),
                  Movie(
                    id: 260763.toString(),
                    title: 'title',
                    description: 'description  ',
                    image:
                        'https://i.allmovies.uz/i/544726/eyJ3IjozNDAsImgiOjE5MiwiYyI6dHJ1ZX0/image.jpg?t=BJiYKMZv4_WT8yio9YJK_Q',
                    duration: 2894,
                    resolutions: {},
                  ),
                ]),
                Season(title: 'Сезон 2', movies: [
                  Movie(
                    id: 260812.toString(),
                    title: 'title',
                    description: 'description  ',
                    image:
                        'https://i.allmovies.uz/i/544726/eyJ3IjozNDAsImgiOjE5MiwiYyI6dHJ1ZX0/image.jpg?t=BJiYKMZv4_WT8yio9YJK_Q',
                    duration: 2894,
                    resolutions: {},
                  ),
                  Movie(
                    id: 260813.toString(),
                    title: 'title',
                    description: 'description  ',
                    image:
                        'https://i.allmovies.uz/i/544726/eyJ3IjozNDAsImgiOjE5MiwiYyI6dHJ1ZX0/image.jpg?t=BJiYKMZv4_WT8yio9YJK_Q',
                    duration: 2894,
                    resolutions: {},
                  ),
                ])
              ],
              tvProgramsText: 'Телеканалы',
              programsInfoList: [],
              showController: true,
              playVideoFromAsset: false,
              assetPath: '',
              seasonIndex: 0,
              episodeIndex: 0,
              isMegogo: false,
              isPremier: false,
              isMoreTv: false,
              videoId: 'vremya-vernutsya',
              sessionId: '8c526abd-2d0a-45c1-b527-814f99b5f040',
              megogoAccessToken: '',
              authorization:
                  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2ODY1NTk5MDIsImlzcyI6InVzZXIiLCJwaWQiOjc2MDY2LCJyb2xlIjoiY3VzdG9tZXIiLCJzdWIiOiI4YzUyNmFiZC0yZDBhLTQ1YzEtYjUyNy04MTRmOTliNWYwNDAifQ.ffXIBxI693pcaZmMrXNWEa_HrvYO_waN77FzBLbryUI',
              autoText: 'Автонастройка',
              fromCache: true,
              userId: '8c526abd-2d0a-45c1-b527-814f99b5f040',
              profileId: 'de1ccf6f-cf57-4e46-b2c6-f7032e29b2e8',
            ),
          ) ??
          'nothing';
      if (kDebugMode) {
        print('result: $s');
      }
    } on PlatformException {
      debugPrint('Failed to get platform version.');
    }
  }

  Future<void> playLiveVideo() async {
    try {
      final s = await _udevsVideoPlayerPlugin.playLiveVideo(
            playerConfig: const LivePlayerConfiguration(
              videoUrl:
                  'https://cdn.uzd.udevs.io/uzdigital/videos/bbc795b69faf3c4d1063777f2b220144/master.m3u8',
              sessionId: '',
              skipText: 'Skip Ad',
              // advertisement: AdvertisementResponse(
              //   id: 'f07d0dab-8466-45b5-8b10-74e264af8e8e',
              //   bannerImage: BannerImage(
              //     mobileImage:
              //         'https://cdn.uzd.udevs.io/uzdigital-images-compressed/images/c30549a1-bda9-4f15-a7db-fe55ba816cf8.jpg',
              //     webImage:
              //         'https://cdn.uzd.udevs.io/uzdigital-images-compressed/images/49b46d84-f0f4-4bea-80df-69f10e51d15d.jpg',
              //     tvImage:
              //         'https://cdn.uzd.udevs.io/uzdigital-images-compressed/images/7ca0217a-b2ec-414e-aca8-849a8702a383.jpg',
              //   ),
              //   skipDuration: 5,
              //   link: 'https://t.me/uzdigital_tv_bot/app',
              //   video:
              //       'https://test.cdn.uzdigital.tv/uzdigital/images/8cb238ae-bd88-4734-84f5-6bedc0f4c194.mp4'
              // ),
              baseUrl: 'https://api.spec.uzd.udevs.io/v1/',
              qualityText: 'Качество',
              speedText: 'Скорость',
              title: 'S1 E1  "Женщина-Халк: Адвокат" ',
              tvProgramsText: 'Телеканалы',
              programsInfoList: [],
              showController: true,
              authorization: '',
              autoText: 'Автонастройка',
              // fromCache: true,
              selectChannelIndex: 0,
              ip: '',
              tvCategories: [
                TvCategories(
                  id: '',
                  title: 'Все',
                  tvChannels: [
                    TvChannel(
                      name: 'Setanta Sports 1',
                      id: 'c782939d-2ace-4075-96d1-c3eae0162370',
                      image:
                          'https://cdn.uzd.udevs.io/uzdigital/images/1738fe23-f629-4a69-ae16-617cf61fcf9d.png',
                      resolutions: {},
                      paymentType: 'svod',
                      hasAccess: false,
                    ),
                    TvChannel(
                      name: 'Setanta Sports 2',
                      id: '8fd99b87-936c-47f6-8874-dda03521d69a',
                      image:
                          'https://cdn.uzd.udevs.io/uzdigital/images/1738fe23-f629-4a69-ae16-617cf61fcf9d.png',
                      resolutions: {},
                      paymentType: 'svod',
                      hasAccess: true,
                    ),
                  ],
                ),
              ],
              userId: '',
              age: 20,
              gender: 'not_selected',
              region: 'not_selected',
              // profileId: '',
            ),
          ) ??
          'nothing';
      if (kDebugMode) {
        print('result: $s');
      }
    } on PlatformException {
      debugPrint('Failed to get platform version.');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: playVideo,
              child: const Text('Play Video'),
            ),
            ElevatedButton(
              onPressed: playLiveVideo,
              child: const Text('Play Video Tv'),
            ),
            ElevatedButton(
              onPressed: download1,
              child: const Text('Download1'),
            ),
            ElevatedButton(
              onPressed: download2,
              child: const Text('Download2'),
            ),
            ElevatedButton(
              onPressed: pauseDownload,
              child: const Text('Pause Download'),
            ),
            ElevatedButton(
              onPressed: resumeDownload,
              child: const Text('Resume Download'),
            ),
            ElevatedButton(
              onPressed: removeDownload,
              child: const Text('Remove Download'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => const SecondPage(),
                  ),
                );
              },
              child: const Text('Got to next page'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => const VideoPlayerPage(),
                  ),
                );
              },
              child: const Text('Got to video view page'),
            ),
            ElevatedButton(
              onPressed: () async {
                final state = await getStateDownload();
                if (kDebugMode) {
                  print('download state: $state');
                }
              },
              child: const Text('Get state'),
            ),
            StreamBuilder(
              stream: currentProgressDownloadAsStream(),
              builder: (context, snapshot) {
                final data = snapshot.data;
                return Column(
                  children: [
                    Text(
                      data == null
                          ? 'Not downloading'
                          : data.url !=
                                  'https://cdn.uzd.udevs.io/uzdigital/videos/772a7a12977cd08a10b6f6843ae80563/240p/index.m3u8'
                              ? 'Not downloading'
                              : data.percent.toString(),
                    ),
                    Text(
                      data == null
                          ? 'Not downloading'
                          : data.url !=
                                  'https://cdn.uzd.udevs.io/uzdigital/videos/a04c9257216b2f2085c88be31a13e5d7/240p/index.m3u8'
                              ? 'Not downloading'
                              : data.percent.toString(),
                    ),
                  ],
                );
              },
            ),
            FutureBuilder(
              future: checkIsDownloaded(),
              builder: (context, snapshot) {
                final data = snapshot.data;
                return Text((data ?? false) ? 'Downloaded' : 'Not downloaded');
              },
            ),
          ],
        ),
      );

  @override
  void dispose() {
    _udevsVideoPlayerPlugin.dispose();
    super.dispose();
  }
}
