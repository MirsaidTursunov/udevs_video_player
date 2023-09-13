import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:udevs_video_player/udevs_video_player.dart';
import 'package:udevs_video_player_example/second_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plugin example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _udevsVideoPlayerPlugin = UdevsVideoPlayer();

  download1() async {
    try {
      var s = await _udevsVideoPlayerPlugin.downloadVideo(
              downloadConfig: DownloadConfiguration(
            title: 'She-Hulk 2',
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

  download2() async {
    try {
      var s = await _udevsVideoPlayerPlugin.downloadVideo(
              downloadConfig: DownloadConfiguration(
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

  pauseDownload() async {
    try {
      var s = await _udevsVideoPlayerPlugin.pauseDownload(
              downloadConfig: DownloadConfiguration(
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

  resumeDownload() async {
    try {
      var s = await _udevsVideoPlayerPlugin.resumeDownload(
              downloadConfig: DownloadConfiguration(
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

  removeDownload() async {
    try {
      var s = await _udevsVideoPlayerPlugin.removeDownload(
              downloadConfig: DownloadConfiguration(
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
              downloadConfig: DownloadConfiguration(
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
          downloadConfig: DownloadConfiguration(
        title: 'She-Hulk',
        url:
            'https://cdn.uzd.udevs.io/uzdigital/videos/772a7a12977cd08a10b6f6843ae80563/240p/index.m3u8',
      ));
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

  void playVideo() async {
    try {
      var s = await _udevsVideoPlayerPlugin.playVideo(
              playerConfig: PlayerConfiguration(
            selectChannelIndex: 0,
            ip: "",
            baseUrl: "https://api.spec.uzd.udevs.io/v1/",
            initialResolution: {
              "240p":
                  "https://cdn.uzd.udevs.io/uzdigital/videos/772a7a12977cd08a10b6f6843ae80563/240p/index.m3u8"
            },
            resolutions: {},
            qualityText: 'Качество',
            speedText: 'Скорость',
            lastPosition: 0,
            title: "S1 E1  \"Женщина-Халк: Адвокат\" ",
            isSerial: true,
            episodeButtonText: 'Эпизоды',
            nextButtonText: 'След.эпизод',
            seasons: [],
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
            videoId: '',
            sessionId: '',
            megogoAccessToken: '',
            authorization: '',
            autoText: 'Автонастройка',
            fromCache: true,
            channels: [],
          )) ??
          'nothing';
      if (kDebugMode) {
        print('result: $s');
      }
    } on PlatformException {
      debugPrint('Failed to get platform version.');
    }
  }

  void playVideoDRM() async {
    try {
      var s = await _udevsVideoPlayerPlugin.playVideo(
              playerConfig: PlayerConfiguration(
            isDRM: true,
            widevineLicenseUrl:
                'https://a2e69b4a.drm-widevine-licensing.axprod.net/AcquireLicense',
            videoUrl: Platform.isAndroid
                ? 'https://s3-eu-central-1.amazonaws.com/million-prod/million-movies/aloqa_movie4/dash/manifest.mpd'
                : 'https://s3-eu-central-1.amazonaws.com/million-prod/million-movies/aloqa_movie4/hls/manifest.m3u8',
            fpsCertificateUrl: 'https://vtb.axinom.com/FPScert/fairplay.cer',
            licenseToken:
                'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ2ZXJzaW9uIjoxLCJjb21fa2V5X2lkIjoiNjU3YjVhZDctOTg0My00NWI2LWE3YTctYjA3NTAxM2VlYTZiIiwibWVzc2FnZSI6eyJ0eXBlIjoiZW50aXRsZW1lbnRfbWVzc2FnZSIsInZlcnNpb24iOjIsImxpY2Vuc2UiOnsic3RhcnRfZGF0ZXRpbWUiOiIyMDIzLTA5LTExVDEwOjQxOjA0LjU4NVoiLCJleHBpcmF0aW9uX2RhdGV0aW1lIjoiMjAyMy0wOS0xM1QxMDo0MTowNC41ODVaIiwiYWxsb3dfcGVyc2lzdGVuY2UiOnRydWV9LCJjb250ZW50X2tleXNfc291cmNlIjp7ImlubGluZSI6W3siaWQiOiJhNjdhNzZmMC0zYzI2LTQ5NjQtYTJkYi0xNDYzMzUwN2EyMTgiLCJ1c2FnZV9wb2xpY3kiOiJQb2xpY3kgQSJ9XX0sImNvbnRlbnRfa2V5X3VzYWdlX3BvbGljaWVzIjpbeyJuYW1lIjoiUG9saWN5IEEiLCJwbGF5cmVhZHkiOnsibWluX2RldmljZV9zZWN1cml0eV9sZXZlbCI6MTUwLCJwbGF5X2VuYWJsZXJzIjpbIjc4NjYyN0Q4LUMyQTYtNDRCRS04Rjg4LTA4QUUyNTVCMDFBNyJdfX1dfSwiYmVnaW5fZGF0ZSI6IjIwMjMtMDktMTFUMTA6NDE6MDQuNTg1WiIsImV4cGlyYXRpb25fZGF0ZSI6IjIwMjMtMDktMTNUMTA6NDE6MDQuNTg1WiJ9.53DUOjP5CMzK4t8sSrTcXxYgqkLH8Wp0AKArkxhgtoo',
            licenseServiceUrl:
                'https://a2e69b4a.drm-fairplay-licensing.axprod.net/AcquireLicense',
            selectChannelIndex: 0,
            ip: "",
            baseUrl: "https://api.spec.uzd.udevs.io/v1/",
            initialResolution: {
              "240p":
                  "https://cdn.uzd.udevs.io/uzdigital/videos/772a7a12977cd08a10b6f6843ae80563/240p/index.m3u8"
            },
            resolutions: {},
            qualityText: 'Качество',
            speedText: 'Скорость',
            lastPosition: 0,
            title: "S1 E1  \"Женщина-Халк: Адвокат\" ",
            isSerial: true,
            episodeButtonText: 'Эпизоды',
            nextButtonText: 'След.эпизод',
            seasons: [],
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
            videoId: '',
            sessionId: '',
            megogoAccessToken: '',
            authorization: '',
            autoText: 'Автонастройка',
            fromCache: true,
            channels: [],
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
    return Scaffold(
      appBar: AppBar(title: const Text('Plugin example app')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          ElevatedButton(
            onPressed: playVideo,
            child: const Text('Play Video'),
          ),
          ElevatedButton(
            onPressed: playVideoDRM,
            child: const Text('Play Video DRM'),
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
                MaterialPageRoute(
                  builder: (context) => const SecondPage(),
                ),
              );
            },
            child: const Text('Got to next page'),
          ),
          ElevatedButton(
            onPressed: () async {
              var state = await getStateDownload();
              print('download state: $state');
            },
            child: const Text('Get state'),
          ),
          StreamBuilder(
            stream: currentProgressDownloadAsStream(),
            builder: (context, snapshot) {
              var data = snapshot.data as MediaItemDownload?;
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
              var data = snapshot.data as bool?;
              return Text((data ?? false) ? 'Downloaded' : 'Not downloaded');
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _udevsVideoPlayerPlugin.dispose();
    super.dispose();
  }
}
