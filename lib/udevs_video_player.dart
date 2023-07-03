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
    String jsonStringConfig = jsonEncode({"initialResolution":{"Auto":"https://st1.uzdigital.tv/FTVHD/video.m3u8?token=fd5f9695580706ba685288937bb6955a27aef124-7a7a7a5076634a5876644f427552694f-1688381720-1688370920&remote=10.0.0.13"},"resolutions":{"Auto":"https://st1.uzdigital.tv/FTVHD/video.m3u8?token=fd5f9695580706ba685288937bb6955a27aef124-7a7a7a5076634a5876644f427552694f-1688381720-1688370920&remote=10.0.0.13","1080p":"http://st1.uzdigital.tv/FTVHD/tracks-v1a1a2/mono.m3u8?remote=10.0.0.13&token=fd5f9695580706ba685288937bb6955a27aef124-7a7a7a5076634a5876644f427552694f-1688381720-1688370920&remote=10.0.0.13","576p":"http://st1.uzdigital.tv/FTVHD/tracks-v2a1a2/mono.m3u8?remote=10.0.0.13&token=fd5f9695580706ba685288937bb6955a27aef124-7a7a7a5076634a5876644f427552694f-1688381720-1688370920&remote=10.0.0.13"},"qualityText":"Sifat","speedText":"Tezlik","lastPosition":0,"title":"FTV5","isSerial":false,"episodeButtonText":"","nextButtonText":"","seasons":[],"isLive":true,"tvProgramsText":"TV dasturlar","programsInfoList":[{"day":"Kecha","tvPrograms":[]},{"day":"Bugun","tvPrograms":[]},{"day":"Ertaga","tvPrograms":[]}],"showController":true,"playVideoFromAsset":false,"assetPath":"","seasonIndex":0,"episodeIndex":0,"isMegogo":false,"isPremier":false,"videoId":"","sessionId":"6481b27b3d4314b1f8161d40","megogoAccessToken":"","authorization":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2ODE4OTQ4MTEsImlzcyI6InVzZXIiLCJwaWQiOjI0MDM5LCJyb2xlIjoiY3VzdG9tZXIiLCJzdWIiOiI3N2Q4MDRjYS02N2MzLTRkM2YtYTVkMS1lZDBjMmU5MmNiY2YifQ.o9xFwnyIF4GT4BOYI7MgY_lITW5QPLD3FxR0Vr-oeT8","autoText":"Avto","baseUrl":"https://test.spectator.api.milliontv.uz/v1/","fromCache":false,"channels":[{"id":"0e335c03-e8a6-4960-b4e7-a3f9b96e0312","image":"https://cdn.api.milliontv.uz/million-movies/images/da033011830d4d3eaa94fc42c7b7a12a.jpg","resolutions":{}},{"id":"47825ed6-673c-474a-a571-19cdbb65d7c2","image":"https://cdn.api.milliontv.uz/million-movies/images/54e11d3547894f90a664db293692294f.jpg","resolutions":{}},{"id":"838e2437-9b60-47a4-a7a9-5cda7839d6e2","image":"https://cdn.api.milliontv.uz/million-movies/images/c1121590c00f4fba97f1844d48b07746.jpg","resolutions":{}},{"id":"d5d3d512-5f07-4257-995a-6135af28e2b2","image":"https://cdn.api.milliontv.uz/million-movies/images/58082f29007c4ac69f14671d4483047a.jpg","resolutions":{}},{"id":"2e7181b6-9d7b-43b3-acc6-962ee950ae18","image":"https://cdn.api.milliontv.uz/million-movies/images/bf61d527a5b54ef6b8101b54b19a6de5.jpg","resolutions":{}},{"id":"fb65daee-d128-4aef-80ca-f3434a085ce3","image":"https://cdn.api.milliontv.uz/million-movies/images/d66e34219d154e108985ef8b4dfc9e76.jpg","resolutions":{}},{"id":"8163848d-4981-45a5-8b50-e2f7168dfc6b","image":"https://cdn.api.milliontv.uz/million-movies/images/e8c6bdf0787141b79c6918e4f8b3f2cd.jpg","resolutions":{}},{"id":"cd5bf200-4ae2-456f-9283-0a1066a5eac0","image":"https://cdn.api.milliontv.uz/million-movies/images/4aa2111babb64a909df8bb76af014ec3.jpg","resolutions":{}},{"id":"ecc2ade4-52c0-41a8-afef-b8a9c375ed0f","image":"https://cdn.api.milliontv.uz/million-movies/images/62e9f426964a47d288a290cc5d7e3aa1.jpg","resolutions":{}},{"id":"241733b4-f2c1-434b-aeb2-e00cc9a13e67","image":"https://cdn.api.milliontv.uz/million-movies/images/86acf74c792545189f1248abb8489719.jpg","resolutions":{}},{"id":"64971452-b7a3-4d58-aa54-97bdcce925d0","image":"https://cdn.api.milliontv.uz/million-movies/images/5d9e45064f4d4d65831df6f14f815441.jpg","resolutions":{}},{"id":"de844bb3-06ea-48ad-96a6-d590234012e5","image":"https://cdn.api.milliontv.uz/million-movies/images/49fbf585d99440ab9936b0c8f3d80871.jpg","resolutions":{}},{"id":"22e7dcf0-5098-440f-ba48-f8f810019c19","image":"https://cdn.api.milliontv.uz/million-movies/images/1df544192e674d03a7a168398c33661c.jpg","resolutions":{}},{"id":"5d19b689-1f31-4175-bf6d-a04b2dc2e8cd","image":"https://cdn.api.milliontv.uz/million-movies/images/141e139bb267457397f60f9cce122951.jpg","resolutions":{}}]});
    // String jsonStringConfig = jsonEncode({"initialResolution":{"Avto":"https://cdn.api.milliontv.uz/million-movies/videos/0fa552bf1244a2aa4bcfe08a4ba2a914/master.m3u8"},"resolutions":{"Avto":"https://cdn.api.milliontv.uz/million-movies/videos/0fa552bf1244a2aa4bcfe08a4ba2a914/master.m3u8","720p":"https://cdn.api.milliontv.uz/million-movies/videos/0fa552bf1244a2aa4bcfe08a4ba2a914/720p/index.m3u8","480p":"https://cdn.api.milliontv.uz/million-movies/videos/0fa552bf1244a2aa4bcfe08a4ba2a914/480p/index.m3u8","360p":"https://cdn.api.milliontv.uz/million-movies/videos/0fa552bf1244a2aa4bcfe08a4ba2a914/360p/index.m3u8","240p":"https://cdn.api.milliontv.uz/million-movies/videos/0fa552bf1244a2aa4bcfe08a4ba2a914/240p/index.m3u8"},"qualityText":"Sifat","speedText":"Tezlik","lastPosition":1267,"title":"S1 E1  \"Sensiz\" ","isSerial":true,"episodeButtonText":"Qismlar","nextButtonText":"Keyin.epizode","seasons":[{"title":"Fasl 1","movies":[{"id":"6478c8c940a51b531ec43e52","title":"Sensiz","description":"","image":"","duration":2436,"resolutions":{"Avto":"https://cdn.api.milliontv.uz/million-movies/videos/0fa552bf1244a2aa4bcfe08a4ba2a914/master.m3u8","720p":"https://cdn.api.milliontv.uz/million-movies/videos/0fa552bf1244a2aa4bcfe08a4ba2a914/720p/index.m3u8","480p":"https://cdn.api.milliontv.uz/million-movies/videos/0fa552bf1244a2aa4bcfe08a4ba2a914/480p/index.m3u8","360p":"https://cdn.api.milliontv.uz/million-movies/videos/0fa552bf1244a2aa4bcfe08a4ba2a914/360p/index.m3u8","240p":"https://cdn.api.milliontv.uz/million-movies/videos/0fa552bf1244a2aa4bcfe08a4ba2a914/240p/index.m3u8"}},{"id":"6478c93040a51bcd21c4443e","title":"Sensiz","description":"","image":"","duration":2419,"resolutions":{"Avto":"https://cdn.api.milliontv.uz/million-movies/videos/52620fb4b5d34523f48fce6570aaa9f7/master.m3u8","720p":"https://cdn.api.milliontv.uz/million-movies/videos/52620fb4b5d34523f48fce6570aaa9f7/720p/index.m3u8","480p":"https://cdn.api.milliontv.uz/million-movies/videos/52620fb4b5d34523f48fce6570aaa9f7/480p/index.m3u8","360p":"https://cdn.api.milliontv.uz/million-movies/videos/52620fb4b5d34523f48fce6570aaa9f7/360p/index.m3u8","240p":"https://cdn.api.milliontv.uz/million-movies/videos/52620fb4b5d34523f48fce6570aaa9f7/240p/index.m3u8"}},{"id":"6478c97f40a51b27b0c445ef","title":"Sensiz","description":"","image":"","duration":2415,"resolutions":{"Avto":"https://cdn.api.milliontv.uz/million-movies/videos/e3d5f55f92099e3f2857ac4e6a795188/master.m3u8","720p":"https://cdn.api.milliontv.uz/million-movies/videos/e3d5f55f92099e3f2857ac4e6a795188/720p/index.m3u8","480p":"https://cdn.api.milliontv.uz/million-movies/videos/e3d5f55f92099e3f2857ac4e6a795188/480p/index.m3u8","360p":"https://cdn.api.milliontv.uz/million-movies/videos/e3d5f55f92099e3f2857ac4e6a795188/360p/index.m3u8","240p":"https://cdn.api.milliontv.uz/million-movies/videos/e3d5f55f92099e3f2857ac4e6a795188/240p/index.m3u8"}},{"id":"647958b80d3674090e38afd0","title":"Sensiz","description":"","image":"","duration":2415,"resolutions":{"Avto":"https://cdn.api.milliontv.uz/million-movies/videos/a15188fea9f490c520c0e32b5ca23a26/master.m3u8","720p":"https://cdn.api.milliontv.uz/million-movies/videos/a15188fea9f490c520c0e32b5ca23a26/720p/index.m3u8","480p":"https://cdn.api.milliontv.uz/million-movies/videos/a15188fea9f490c520c0e32b5ca23a26/480p/index.m3u8","360p":"https://cdn.api.milliontv.uz/million-movies/videos/a15188fea9f490c520c0e32b5ca23a26/360p/index.m3u8","240p":"https://cdn.api.milliontv.uz/million-movies/videos/a15188fea9f490c520c0e32b5ca23a26/240p/index.m3u8"}},{"id":"647958e80d3674a49d38b634","title":"Sensiz","description":"","image":"","duration":2417,"resolutions":{"Avto":"https://cdn.api.milliontv.uz/million-movies/videos/a2e13aff0d5058212a4d66be4651289a/master.m3u8","720p":"https://cdn.api.milliontv.uz/million-movies/videos/a2e13aff0d5058212a4d66be4651289a/720p/index.m3u8","480p":"https://cdn.api.milliontv.uz/million-movies/videos/a2e13aff0d5058212a4d66be4651289a/480p/index.m3u8","360p":"https://cdn.api.milliontv.uz/million-movies/videos/a2e13aff0d5058212a4d66be4651289a/360p/index.m3u8","240p":"https://cdn.api.milliontv.uz/million-movies/ideos/a2e13aff0d5058212a4d66be4651289a/240p/index.m3u8"}},{"id":"647959270d367432cc38bb05","title":"Sensiz","description":"","image":"","duration":2415,"resolutions":{"Avto":"https://cdn.api.milliontv.uz/million-movies/videos/9e80731409cdb03068cb64728f654f54/master.m3u8","720p":"https://cdn.api.milliontv.uz/million-movies/videos/9e80731409cdb03068cb64728f654f54/720p/index.m3u8","480p":"https://cdn.api.milliontv.uz/million-movies/videos/9e80731409cdb03068cb64728f654f54/480p/index.m3u8","360p":"https://cdn.api.milliontv.uz/million-movies/videos/9e80731409cdb03068cb64728f654f54/360p/index.m3u8","240p":"https://cdn.api.milliontv.uz/million-movies/videos/9e80731409cdb03068cb64728f654f54/240p/index.m3u8"}},{"id":"6479595d0d36744f2838bcc1","title":"Sensiz","description":"","image":"","duration":2420,"resolutions":{"Avto":"https://cdn.api.milliontv.uz/million-movies/videos/a16a46712fa38eaac9167711d392bc19/master.m3u8","720p":"https://cdn.api.milliontv.uz/million-movies/videos/a16a46712fa38eaac9167711d392bc19/720p/index.m3u8","480p":"https://cdn.api.milliontv.uz/million-movies/videos/a16a46712fa38eaac9167711d392bc19/480p/index.m3u8","360p":"https://cdn.api.milliontv.uz/million-movies/videos/a16a46712fa38eaac9167711d392bc19/360p/index.m3u8","240p":"https://cdn.api.milliontv.uz/million-movies/videos/a16a46712fa38eaac9167711d392bc19/240p/index.m3u8"}},{"id":"647959930d36742b9838beed","title":"Sensiz","description":"","image":"","duration":2409,"resolutions":{"Avto":"https://cdn.api.milliontv.uz/million-movies/videos/3dde2dcaf381000df9cef78f37310e50/master.m3u8","720p":"https://cdn.api.milliontv.uz/million-movies/videos/3dde2dcaf381000df9cef78f37310e50/720p/index.m3u8","480p":"https://cdn.api.milliontv.uz/million-movies/videos/3dde2dcaf381000df9cef78f37310e50/480p/index.m3u8","360p":"https://cdn.api.milliontv.uz/million-movies/videos/3dde2dcaf381000df9cef78f37310e50/360p/index.m3u8","240p":"https://cdn.api.milliontv.uz/million-movies/videos/3dde2dcaf381000df9cef78f37310e50/240p/index.m3u8"}},{"id":"647959e50d3674725a38c358","title":"Sensiz","description":"","image":"","duration":2414,"resolutions":{"Avto":"https://cdn.api.milliontv.uz/million-movies/videos/7134c140f136d52fbe59b0a522e29b71/master.m3u8","720p":"https://cdn.api.milliontv.uz/million-movies/videos/7134c140f136d52fbe59b0a522e29b71/720p/index.m3u8","480p":"https://cdn.api.milliontv.uz/million-movies/videos/7134c140f136d52fbe59b0a522e29b71/480p/index.m3u8","360p":"https://cdn.api.milliontv.uz/million-movies/videos/7134c140f136d52fbe59b0a522e29b71/360p/index.m3u8","240p":"https://cdn.api.milliontv.uz/million-movies/videos/7134c140f136d52fbe59b0a522e29b71/240p/index.m3u8"}},{"id":"647959ee0d36749b6238c479","title":"Sensiz","description":"","image":"","duration":2413,"resolutions":{"Avto":"https://cdn.api.milliontv.uz/million-movies/videos/d3ad2f6c72c4bd289621a0a858fe5d0b/master.m3u8","720p":"https://cdn.api.milliontv.uz/million-movies/videos/d3ad2f6c72c4bd289621a0a858fe5d0b/720p/index.m3u8","480p":"https://cdn.api.milliontv.uz/million-movies/videos/d3ad2f6c72c4bd289621a0a858fe5d0b/480p/index.m3u8","360p":"https://cdn.api.milliontv.uz/million-movies/videos/d3ad2f6c72c4bd289621a0a858fe5d0b/360p/index.m3u8","240p":"https://cdn.api.milliontv.uz/million-movies/videos/d3ad2f6c72c4bd289621a0a858fe5d0b/240p/index.m3u8"}},{"id":"647959f70d36740e5c38c59e","title":"Sensiz","description":"","image":"","duration":2413,"resolutions":{"Avto":"https://cdn.api.milliontv.uz/million-movies/videos/9e051c633a1794644246345dabcc4ffe/master.m3u8","720p":"https://cdn.api.milliontv.uz/million-movies/videos/9e051c633a1794644246345dabcc4ffe/720p/index.m3u8","480p":"https://cdn.api.milliontv.uz/million-movies/videos/9e051c633a1794644246345dabcc4ffe/480p/index.m3u8","360p":"https://cdn.api.milliontv.uz/million-movies/videos/9e051c633a1794644246345dabcc4ffe/360p/index.m3u8","240p":"https://cdn.api.milliontv.uz/million-movies/videos/9e051c633a1794644246345dabcc4ffe/240p/index.m3u8"}}]}],"isLive":false,"tvProgramsText":"TVkanallar","programsInfoList":[],"showController":true,"playVideoFromAsset":false,"assetPath":"","seasonIndex":0,"episodeIndex":0,"isMegogo":false,"isPremier":false,"videoId":"","sessionId":"6481b27b3d4314b1f8161d40","megogoAccessToken":"","authorization":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2ODE4OTQ4MTEsImlzcyI6InVzZXIiLCJwaWQiOjI0MDM5LCJyb2xlIjoiY3VzdG9tZXIiLCJzdWIiOiI3N2Q4MDRjYS02N2MzLTRkM2YtYTVkMS1lZDBjMmU5MmNiY2YifQ.o9xFwnyIF4GT4BOYI7MgY_lITW5QPLD3FxR0Vr-oeT8","autoText":"Avto","baseUrl":"https://test.spectator.api.milliontv.uz/v1/","fromCache":false,"channels":[]});
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
