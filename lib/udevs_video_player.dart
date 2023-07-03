import 'dart:async';
import 'dart:convert';

import 'package:udevs_video_player/models/download_configuration.dart';
import 'package:udevs_video_player/models/media_item_download.dart';
import 'package:udevs_video_player/models/player_configuration.dart';

import 'udevs_video_player_platform_interface.dart';
export 'package:udevs_video_player/models/player_configuration.dart';
export 'package:udevs_video_player/models/movie.dart';
export 'package:udevs_video_player/models/season.dart';
export 'package:udevs_video_player/models/tv_program.dart';
export 'package:udevs_video_player/models/programs_info.dart';
export 'package:udevs_video_player/models/download_configuration.dart';
export 'package:udevs_video_player/models/media_item_download.dart';

class UdevsVideoPlayer {
  UdevsVideoPlayer._();

  static final UdevsVideoPlayer _instance = UdevsVideoPlayer._();

  factory UdevsVideoPlayer() => _instance;

  Future<int?> playVideo({required PlayerConfiguration playerConfig}) {
    // String jsonStringConfig = jsonEncode(playerConfig.toJson());
    String jsonStringConfig = jsonEncode({"initialResolution":{"Auto":"https://st1.uzdigital.tv/Sport-UZ/video.m3u8?token=65fb045f6eea62b4726239c96db4bcc2ab980c3e-4f73664479656e696861586f5a616764-1688371364-1688360564&remote=10.0.0.13"},"resolutions":{"Auto":"https://st1.uzdigital.tv/Sport-UZ/video.m3u8?token=65fb045f6eea62b4726239c96db4bcc2ab980c3e-4f73664479656e696861586f5a616764-1688371364-1688360564&remote=10.0.0.13","1080p":"http://st1.uzdigital.tv/Sport-UZ/tracks-v1a1a2/mono.m3u8?remote=10.0.0.13&token=65fb045f6eea62b4726239c96db4bcc2ab980c3e-4f73664479656e696861586f5a616764-1688371364-1688360564&remote=10.0.0.13"},"qualityText":"Sifat","speedText":"Tezlik","lastPosition":0,"title":"Sport Uz","isSerial":false,"episodeButtonText":"","nextButtonText":"","seasons":[],"isLive":true,"tvProgramsText":"TV dasturlar","programsInfoList":[{"day":"Kecha","tvPrograms":[]},{"day":"Bugun","tvPrograms":[]},{"day":"Ertaga","tvPrograms":[]}],"showController":true,"playVideoFromAsset":false,"assetPath":"","seasonIndex":0,"episodeIndex":0,"isMegogo":false,"isPremier":false,"videoId":"","sessionId":"6481b27b3d4314b1f8161d40","megogoAccessToken":"","authorization":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2ODE4OTQ4MTEsImlzcyI6InVzZXIiLCJwaWQiOjI0MDM5LCJyb2xlIjoiY3VzdG9tZXIiLCJzdWIiOiI3N2Q4MDRjYS02N2MzLTRkM2YtYTVkMS1lZDBjMmU5MmNiY2YifQ.o9xFwnyIF4GT4BOYI7MgY_lITW5QPLD3FxR0Vr-oeT8","autoText":"Avto","baseUrl":"https://test.spectator.api.milliontv.uz/v1/","fromCache":false,"channels":[{"id":"0e335c03-e8a6-4960-b4e7-a3f9b96e0312","image":"https://cdn.api.milliontv.uz/million-movies/images/da033011830d4d3eaa94fc42c7b7a12a.jpg","resolutions":{}},{"id":"47825ed6-673c-474a-a571-19cdbb65d7c2","image":"https://cdn.api.milliontv.uz/million-movies/images/54e11d3547894f90a664db293692294f.jpg","resolutions":{}},{"id":"838e2437-9b60-47a4-a7a9-5cda7839d6e2","image":"https://cdn.api.milliontv.uz/million-movies/images/c1121590c00f4fba97f1844d48b07746.jpg","resolutions":{}},{"id":"d5d3d512-5f07-4257-995a-6135af28e2b2","image":"https://cdn.api.milliontv.uz/million-movies/images/58082f29007c4ac69f14671d4483047a.jpg","resolutions":{}},{"id":"2e7181b6-9d7b-43b3-acc6-962ee950ae18","image":"https://cdn.api.milliontv.uz/million-movies/images/bf61d527a5b54ef6b8101b54b19a6de5.jpg","resolutions":{}},{"id":"fb65daee-d128-4aef-80ca-f3434a085ce3","image":"https://cdn.api.milliontv.uz/million-movies/images/d66e34219d154e108985ef8b4dfc9e76.jpg","resolutions":{}},{"id":"8163848d-4981-45a5-8b50-e2f7168dfc6b","image":"https://cdn.api.milliontv.uz/million-movies/images/e8c6bdf0787141b79c6918e4f8b3f2cd.jpg","resolutions":{}},{"id":"cd5bf200-4ae2-456f-9283-0a1066a5eac0","image":"https://cdn.api.milliontv.uz/million-movies/images/4aa2111babb64a909df8bb76af014ec3.jpg","resolutions":{}},{"id":"ecc2ade4-52c0-41a8-afef-b8a9c375ed0f","image":"https://cdn.api.milliontv.uz/million-movies/images/62e9f426964a47d288a290cc5d7e3aa1.jpg","resolutions":{}},{"id":"241733b4-f2c1-434b-aeb2-e00cc9a13e67","image":"https://cdn.api.milliontv.uz/million-movies/images/86acf74c792545189f1248abb8489719.jpg","resolutions":{}},{"id":"64971452-b7a3-4d58-aa54-97bdcce925d0","image":"https://cdn.api.milliontv.uz/million-movies/images/5d9e45064f4d4d65831df6f14f815441.jpg","resolutions":{}},{"id":"de844bb3-06ea-48ad-96a6-d590234012e5","image":"https://cdn.api.milliontv.uz/million-movies/images/49fbf585d99440ab9936b0c8f3d80871.jpg","resolutions":{}},{"id":"22e7dcf0-5098-440f-ba48-f8f810019c19","image":"https://cdn.api.milliontv.uz/million-movies/images/1df544192e674d03a7a168398c33661c.jpg","resolutions":{}},{"id":"5d19b689-1f31-4175-bf6d-a04b2dc2e8cd","image":"https://cdn.api.milliontv.uz/million-movies/images/141e139bb267457397f60f9cce122951.jpg","resolutions":{}}], 'ip':"89.236.205.221"});
    return UdevsVideoPlayerPlatform.instance.playVideo(
      playerConfigJsonString: jsonStringConfig,
    );
  }

  Future<dynamic> downloadVideo({
    required DownloadConfiguration downloadConfig,
  }) {
    String jsonStringConfig = jsonEncode(downloadConfig.toJson());
    return UdevsVideoPlayerPlatform.instance.downloadVideo(
      downloadConfigJsonString: jsonStringConfig,
    );
  }

  Future<dynamic> pauseDownload({
    required DownloadConfiguration downloadConfig,
  }) {
    String jsonStringConfig = jsonEncode(downloadConfig.toJson());
    return UdevsVideoPlayerPlatform.instance.pauseDownload(
      downloadConfigJsonString: jsonStringConfig,
    );
  }

  Future<dynamic> resumeDownload({
    required DownloadConfiguration downloadConfig,
  }) {
    String jsonStringConfig = jsonEncode(downloadConfig.toJson());
    return UdevsVideoPlayerPlatform.instance.resumeDownload(
      downloadConfigJsonString: jsonStringConfig,
    );
  }

  Future<bool> isDownloadVideo({
    required DownloadConfiguration downloadConfig,
  }) {
    String jsonStringConfig = jsonEncode(downloadConfig.toJson());
    return UdevsVideoPlayerPlatform.instance.isDownloadVideo(
      downloadConfigJsonString: jsonStringConfig,
    );
  }

  Future<int?> getCurrentProgressDownload({
    required DownloadConfiguration downloadConfig,
  }) {
    String jsonStringConfig = jsonEncode(downloadConfig.toJson());
    return UdevsVideoPlayerPlatform.instance.getCurrentProgressDownload(
      downloadConfigJsonString: jsonStringConfig,
    );
  }

  Stream<MediaItemDownload> get currentProgressDownloadAsStream =>
      UdevsVideoPlayerPlatform.instance.currentProgressDownloadAsStream();

  Future<int?> getStateDownload({
    required DownloadConfiguration downloadConfig,
  }) {
    String jsonStringConfig = jsonEncode(downloadConfig.toJson());
    return UdevsVideoPlayerPlatform.instance.getStateDownload(
      downloadConfigJsonString: jsonStringConfig,
    );
  }

  Future<int?> getBytesDownloaded({
    required DownloadConfiguration downloadConfig,
  }) {
    String jsonStringConfig = jsonEncode(downloadConfig.toJson());
    return UdevsVideoPlayerPlatform.instance.getBytesDownloaded(
      downloadConfigJsonString: jsonStringConfig,
    );
  }

  Future<int?> getContentBytesDownload({
    required DownloadConfiguration downloadConfig,
  }) {
    String jsonStringConfig = jsonEncode(downloadConfig.toJson());
    return UdevsVideoPlayerPlatform.instance.getContentBytesDownload(
      downloadConfigJsonString: jsonStringConfig,
    );
  }

  Future<dynamic> removeDownload({
    required DownloadConfiguration downloadConfig,
  }) {
    String jsonStringConfig = jsonEncode(downloadConfig.toJson());
    return UdevsVideoPlayerPlatform.instance.removeDownload(
      downloadConfigJsonString: jsonStringConfig,
    );
  }

  void dispose() => UdevsVideoPlayerPlatform.instance.dispose();
}
