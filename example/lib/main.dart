import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
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
              movieShareLink: 'https://uzd.udevs.io/movie/7963?type=premier',
              baseUrl: 'https://api.spec.uzd.udevs.io/v1/',
              initialResolution: {
                'moretv':
                    'https://st13.allmovies.uz/map/hls/MjYwNzQ1OjIzMjg5NjAyMDU6MQ--/master.m3u8?t=6XFMQdrAqff-puHvpFIplg&e=1702379926'
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
              isLive: false,
              tvProgramsText: 'Телеканалы',
              programsInfoList: [],
              showController: true,
              playVideoFromAsset: false,
              assetPath: '',
              seasonIndex: 0,
              episodeIndex: 0,
              isMegogo: false,
              isPremier: false,
              isMoreTv: true,
              videoId: '',
              sessionId: '',
              megogoAccessToken: '',
              authorization: '',
              autoText: 'Автонастройка',
              fromCache: true,
              selectChannelIndex: 0,
              ip: '',
              tvCategories: [],
              userId: '',
              profileId: '',
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

  Future<void> playVideoTV() async {
    try {
      final s = await _udevsVideoPlayerPlugin.playVideo(
            playerConfig: const PlayerConfiguration(
              movieShareLink: 'https://uzd.udevs.io/movie/7963?type=premier',
              baseUrl: 'https://api.spec.uzd.udevs.io/v1/',
              initialResolution: {
                'Автонастройка':
                    'https://st1.uzdigital.tv/Setanta2HD/video.m3u8?token=9072c3e6edc711801c39b31f597cbc3cd4b18dae-77464b7a79797270637457655667714d-1704465688-1704454888&remote=94.232.24.122'
              },
              resolutions: {
                'Автонастройка':
                    'https://st1.uzdigital.tv/Setanta2HD/video.m3u8?token=9072c3e6edc711801c39b31f597cbc3cd4b18dae-77464b7a79797270637457655667714d-1704465688-1704454888&remote=94.232.24.122, 1080p: http://st1.uzdigital.tv/Setanta2HD/tracks-v1a1a2/mono.m3u8?remote=94.232.24.122&token=9072c3e6edc711801c39b31f597cbc3cd4b18dae-77464b7a79797270637457655667714d-1704465688-1704454888&remote=94.232.24.122',
                '576p':
                    'http://st1.uzdigital.tv/Setanta2HD/tracks-v2a1a2/mono.m3u8?remote=94.232.24.122&token=9072c3e6edc711801c39b31f597cbc3cd4b18dae-77464b7a79797270637457655667714d-1704465688-1704454888&remote=94.232.24.122',
              },
              qualityText: 'Качество',
              speedText: 'Скорость',
              lastPosition: 0,
              title: 'S1 E1  "Женщина-Халк: Адвокат" ',
              isSerial: true,
              episodeButtonText: 'Эпизоды',
              nextButtonText: 'След.эпизод',
              seasons: [],
              isLive: true,
              tvProgramsText: 'Телеканалы',
              programsInfoList: [],
              showController: true,
              playVideoFromAsset: false,
              assetPath: '',
              seasonIndex: 0,
              episodeIndex: 0,
              isMegogo: false,
              isPremier: false,
              isMoreTv: true,
              videoId: '',
              sessionId: '',
              megogoAccessToken: '',
              authorization: '',
              autoText: 'Автонастройка',
              fromCache: true,
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
                      paymentType: 'free',
                      hasAccess: true,
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
              profileId: '',
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
              onPressed: playVideoTV,
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
