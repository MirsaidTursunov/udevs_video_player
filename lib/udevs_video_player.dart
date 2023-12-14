import 'dart:async';
import 'dart:convert';

import 'package:udevs_video_player/models/download_configuration.dart';
import 'package:udevs_video_player/models/media_item_download.dart';
import 'package:udevs_video_player/models/player_configuration.dart';

import 'udevs_video_player_platform_interface.dart';

export 'package:udevs_video_player/models/download_configuration.dart';
export 'package:udevs_video_player/models/media_item_download.dart';
export 'package:udevs_video_player/models/movie.dart';
export 'package:udevs_video_player/models/player_configuration.dart';
export 'package:udevs_video_player/models/programs_info.dart';
export 'package:udevs_video_player/models/season.dart';
export 'package:udevs_video_player/models/tv_program.dart';

class UdevsVideoPlayer {
  factory UdevsVideoPlayer() => _instance;

  UdevsVideoPlayer._();

  static final UdevsVideoPlayer _instance = UdevsVideoPlayer._();

  Future<int?> playVideo({required PlayerConfiguration playerConfig}) {
    final String jsonStringConfig = jsonEncode(playerConfig.toJson());
    // final String jsonStringConfig = jsonEncode({"initialResolution":{"moretv":"https://st21.allmovies.uz/proxy/3/map/hls/MTExOjE3MTk2ODMxNDg6MQ--/master.m3u8?t=GbOHKTGuEq1mF6SKBVQVTQ&e=1702551198"},"resolutions":{},"qualityText":"Качество","speedText":"Скорость","lastPosition":0,"title":"Сердцеедки","isSerial":false,"episodeButtonText":"Эпизоды","nextButtonText":"След.эпизод","seasons":[],"isLive":false,"tvProgramsText":"Телеканалы","programsInfoList":[],"showController":true,"playVideoFromAsset":false,"assetPath":"","seasonIndex":0,"episodeIndex":0,"isMegogo":false,"isMoreTv":true,"isPremier":false,"videoId":"111","sessionId":"657a8a35716925ee9c6ea04f","megogoAccessToken":"","authorization":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2ODY1NTk5MDIsImlzcyI6InVzZXIiLCJwaWQiOjc2MDY2LCJyb2xlIjoiY3VzdG9tZXIiLCJzdWIiOiI4YzUyNmFiZC0yZDBhLTQ1YzEtYjUyNy04MTRmOTliNWYwNDAifQ.ffXIBxI693pcaZmMrXNWEa_HrvYO_waN77FzBLbryUI","autoText":"Автонастройка","baseUrl":"https://api.spec.uzd.udevs.io/v1/","fromCache":false,"movieShareLink":"https://uzdplus.uz/movie/111?type=moretv","ip":"","selectChannelIndex":0,"selectTvCategoryIndex":0,"tvCategories":[]});
    // final String jsonStringConfig = jsonEncode({"initialResolution":{"moretv":"https://st1.allmovies.uz/map/hls/NDEyNjc6MTQxNzEzNzM0Mzox/master.m3u8?t=VfqChmUlpXyB4H5oVt-CXQ&e=1702554580"},"resolutions":{},"qualityText":"Качество","speedText":"Скорость","lastPosition":0,"title":"Как я ездил в Москву","isSerial":true,"episodeButtonText":"Эпизоды","nextButtonText":"След.эпизод","seasons":[{"title":"1 Сезон","movies":[{"id":"41267","title":"","description":"","image":"https://i.allmovies.uz/i/84445/eyJ3IjozNDAsImgiOjE5MiwiYyI6dHJ1ZX0/image.jpg?t=plEh0coCQroOA4Iteps8Ag","duration":1465,"resolutions":{"sd":""}},{"id":"41269","title":"","description":"","image":"https://i.allmovies.uz/i/84444/eyJ3IjozNDAsImgiOjE5MiwiYyI6dHJ1ZX0/image.jpg?t=e0FSPI1Ljmfn6ZkzqQokCw","duration":1416,"resolutions":{"sd":""}},{"id":"41270","title":"","description":"","image":"https://i.allmovies.uz/i/84443/eyJ3IjozNDAsImgiOjE5MiwiYyI6dHJ1ZX0/image.jpg?t=XI-gJWFkDGokA577D0-HGw","duration":1457,"resolutions":{"sd":""}},{"id":"41271","title":"","description":"","image":"https://i.allmovies.uz/i/84442/eyJ3IjozNDAsImgiOjE5MiwiYyI6dHJ1ZX0/image.jpg?t=4Px_J-uSJgTaYptUF6-8Og","duration":1436,"resolutions":{"sd":""}},{"id":"41272","title":"","description":"","image":"https://i.allmovies.uz/i/84441/eyJ3IjozNDAsImgiOjE5MiwiYyI6dHJ1ZX0/image.jpg?t=0d5BO88eXAC7_z_ZAubKYw","duration":1434,"resolutions":{"sd":""}},{"id":"41273","title":"","description":"","image":"https://i.allmovies.uz/i/84440/eyJ3IjozNDAsImgiOjE5MiwiYyI6dHJ1ZX0/image.jpg?t=FsnhsBolmQIFYNIWkS6koQ","duration":1418,"resolutions":{"sd":""}},{"id":"41274","title":"","description":"","image":"https://i.allmovies.uz/i/84439/eyJ3IjozNDAsImgiOjE5MiwiYyI6dHJ1ZX0/image.jpg?t=3GxSO-rwW4JmzjDKkmbc_Q","duration":1421,"resolutions":{"sd":""}},{"id":"41275","title":"","description":"","image":"https://i.allmovies.uz/i/84438/eyJ3IjozNDAsImgiOjE5MiwiYyI6dHJ1ZX0/image.jpg?t=hL6WF8hwlaYDPPoDSsOdfA","duration":1405,"resolutions":{"sd":""}},{"id":"41276","title":"","description":"","image":"https://i.allmovies.uz/i/84437/eyJ3IjozNDAsImgiOjE5MiwiYyI6dHJ1ZX0/image.jpg?t=eCJCw-tWur1EWw09kysGFw","duration":1409,"resolutions":{"sd":""}},{"id":"41257","title":"","description":"","image":"https://i.allmovies.uz/i/84436/eyJ3IjozNDAsImgiOjE5MiwiYyI6dHJ1ZX0/image.jpg?t=1QS5PYIq2MkgAbc0NwkB1A","duration":1430,"resolutions":{"sd":""}},{"id":"41258","title":"","description":"","image":"https://i.allmovies.uz/i/84435/eyJ3IjozNDAsImgiOjE5MiwiYyI6dHJ1ZX0/image.jpg?t=iW5wWJbDye3KjmxpEXiZ3g","duration":1404,"resolutions":{"sd":""}},{"id":"41259","title":"","description":"","image":"https://i.allmovies.uz/i/84434/eyJ3IjozNDAsImgiOjE5MiwiYyI6dHJ1ZX0/image.jpg?t=Ad1WCuknPT1OYmgvbwGJ3g","duration":1487,"resolutions":{"sd":""}},{"id":"41260","title":"","description":"","image":"https://i.allmovies.uz/i/84433/eyJ3IjozNDAsImgiOjE5MiwiYyI6dHJ1ZX0/image.jpg?t=Hv2IoaX-PhdToRsf2J7SFg","duration":1473,"resolutions":{"sd":""}},{"id":"41261","title":"","description":"","image":"https://i.allmovies.uz/i/84432/eyJ3IjozNDAsImgiOjE5MiwiYyI6dHJ1ZX0/image.jpg?t=UYp-5BnwVVnz_rIrTn3fhA","duration":1411,"resolutions":{"sd":""}},{"id":"41262","title":"","description":"","image":"https://i.allmovies.uz/i/84431/eyJ3IjozNDAsImgiOjE5MiwiYyI6dHJ1ZX0/image.jpg?t=qBAmiAdFIS4rRzQBL9IrWQ","duration":1396,"resolutions":{"sd":""}},{"id":"41263","title":"","description":"","image":"https://i.allmovies.uz/i/84430/eyJ3IjozNDAsImgiOjE5MiwiYyI6dHJ1ZX0/image.jpg?t=oFobvxFB2LFkmsNMZOl4jg","duration":1473,"resolutions":{"sd":""}},{"id":"41264","title":"","description":"","image":"https://i.allmovies.uz/i/84429/eyJ3IjozNDAsImgiOjE5MiwiYyI6dHJ1ZX0/image.jpg?t=Ag1DS7jEm-exIBnH7kKOeQ","duration":1486,"resolutions":{"sd":""}},{"id":"41265","title":"","description":"","image":"https://i.allmovies.uz/i/84428/eyJ3IjozNDAsImgiOjE5MiwiYyI6dHJ1ZX0/image.jpg?t=e4Rl9qOd4AAsIMh3WRoHGA","duration":1433,"resolutions":{"sd":""}},{"id":"41266","title":"","description":"","image":"https://i.allmovies.uz/i/84427/eyJ3IjozNDAsImgiOjE5MiwiYyI6dHJ1ZX0/image.jpg?t=v2V0zVJKWFti5cCPzzvGcA","duration":1479,"resolutions":{"sd":""}},{"id":"41268","title":"","description":"","image":"https://i.allmovies.uz/i/84426/eyJ3IjozNDAsImgiOjE5MiwiYyI6dHJ1ZX0/image.jpg?t=MRWteXOUj51rK1nS1qp6_Q","duration":1449,"resolutions":{"sd":""}},{"id":"41267","title":"","description":"","image":"https://i.allmovies.uz/i/84445/eyJ3IjozNDAsImgiOjE5MiwiYyI6dHJ1ZX0/image.jpg?t=plEh0coCQroOA4Iteps8Ag","duration":1465,"resolutions":{"sd":""}},{"id":"41269","title":"","description":"","image":"https://i.allmovies.uz/i/84444/eyJ3IjozNDAsImgiOjE5MiwiYyI6dHJ1ZX0/image.jpg?t=e0FSPI1Ljmfn6ZkzqQokCw","duration":1416,"resolutions":{"sd":""}},{"id":"41270","title":"","description":"","image":"https://i.allmovies.uz/i/84443/eyJ3IjozNDAsImgiOjE5MiwiYyI6dHJ1ZX0/image.jpg?t=XI-gJWFkDGokA577D0-HGw","duration":1457,"resolutions":{"sd":""}},{"id":"41271","title":"","description":"","image":"https://i.allmovies.uz/i/84442/eyJ3IjozNDAsImgiOjE5MiwiYyI6dHJ1ZX0/image.jpg?t=4Px_J-uSJgTaYptUF6-8Og","duration":1436,"resolutions":{"sd":""}},{"id":"41272","title":"","description":"","image":"https://i.allmovies.uz/i/84441/eyJ3IjozNDAsImgiOjE5MiwiYyI6dHJ1ZX0/image.jpg?t=0d5BO88eXAC7_z_ZAubKYw","duration":1434,"resolutions":{"sd":""}},{"id":"41273","title":"","description":"","image":"https://i.allmovies.uz/i/84440/eyJ3IjozNDAsImgiOjE5MiwiYyI6dHJ1ZX0/image.jpg?t=FsnhsBolmQIFYNIWkS6koQ","duration":1418,"resolutions":{"sd":""}},{"id":"41274","title":"","description":"","image":"https://i.allmovies.uz/i/84439/eyJ3IjozNDAsImgiOjE5MiwiYyI6dHJ1ZX0/image.jpg?t=3GxSO-rwW4JmzjDKkmbc_Q","duration":1421,"resolutions":{"sd":""}},{"id":"41275","title":"","description":"","image":"https://i.allmovies.uz/i/84438/eyJ3IjozNDAsImgiOjE5MiwiYyI6dHJ1ZX0/image.jpg?t=hL6WF8hwlaYDPPoDSsOdfA","duration":1405,"resolutions":{"sd":""}},{"id":"41276","title":"","description":"","image":"https://i.allmovies.uz/i/84437/eyJ3IjozNDAsImgiOjE5MiwiYyI6dHJ1ZX0/image.jpg?t=eCJCw-tWur1EWw09kysGFw","duration":1409,"resolutions":{"sd":""}},{"id":"41257","title":"","description":"","image":"https://i.allmovies.uz/i/84436/eyJ3IjozNDAsImgiOjE5MiwiYyI6dHJ1ZX0/image.jpg?t=1QS5PYIq2MkgAbc0NwkB1A","duration":1430,"resolutions":{"sd":""}},{"id":"41258","title":"","description":"","image":"https://i.allmovies.uz/i/84435/eyJ3IjozNDAsImgiOjE5MiwiYyI6dHJ1ZX0/image.jpg?t=iW5wWJbDye3KjmxpEXiZ3g","duration":1404,"resolutions":{"sd":""}},{"id":"41259","title":"","description":"","image":"https://i.allmovies.uz/i/84434/eyJ3IjozNDAsImgiOjE5MiwiYyI6dHJ1ZX0/image.jpg?t=Ad1WCuknPT1OYmgvbwGJ3g","duration":1487,"resolutions":{"sd":""}},{"id":"41260","title":"","description":"","image":"https://i.allmovies.uz/i/84433/eyJ3IjozNDAsImgiOjE5MiwiYyI6dHJ1ZX0/image.jpg?t=Hv2IoaX-PhdToRsf2J7SFg","duration":1473,"resolutions":{"sd":""}},{"id":"41261","title":"","description":"","image":"https://i.allmovies.uz/i/84432/eyJ3IjozNDAsImgiOjE5MiwiYyI6dHJ1ZX0/image.jpg?t=UYp-5BnwVVnz_rIrTn3fhA","duration":1411,"resolutions":{"sd":""}},{"id":"41262","title":"","description":"","image":"https://i.allmovies.uz/i/84431/eyJ3IjozNDAsImgiOjE5MiwiYyI6dHJ1ZX0/image.jpg?t=qBAmiAdFIS4rRzQBL9IrWQ","duration":1396,"resolutions":{"sd":""}},{"id":"41263","title":"","description":"","image":"https://i.allmovies.uz/i/84430/eyJ3IjozNDAsImgiOjE5MiwiYyI6dHJ1ZX0/image.jpg?t=oFobvxFB2LFkmsNMZOl4jg","duration":1473,"resolutions":{"sd":""}},{"id":"41264","title":"","description":"","image":"https://i.allmovies.uz/i/84429/eyJ3IjozNDAsImgiOjE5MiwiYyI6dHJ1ZX0/image.jpg?t=Ag1DS7jEm-exIBnH7kKOeQ","duration":1486,"resolutions":{"sd":""}},{"id":"41265","title":"","description":"","image":"https://i.allmovies.uz/i/84428/eyJ3IjozNDAsImgiOjE5MiwiYyI6dHJ1ZX0/image.jpg?t=e4Rl9qOd4AAsIMh3WRoHGA","duration":1433,"resolutions":{"sd":""}},{"id":"41266","title":"","description":"","image":"https://i.allmovies.uz/i/84427/eyJ3IjozNDAsImgiOjE5MiwiYyI6dHJ1ZX0/image.jpg?t=v2V0zVJKWFti5cCPzzvGcA","duration":1479,"resolutions":{"sd":""}},{"id":"41268","title":"","description":"","image":"https://i.allmovies.uz/i/84426/eyJ3IjozNDAsImgiOjE5MiwiYyI6dHJ1ZX0/image.jpg?t=MRWteXOUj51rK1nS1qp6_Q","duration":1449,"resolutions":{"sd":""}}]}],"isLive":false,"tvProgramsText":"Телеканалы","programsInfoList":[],"showController":true,"playVideoFromAsset":false,"assetPath":"","seasonIndex":0,"episodeIndex":0,"isMegogo":false,"isMoreTv":true,"isPremier":false,"videoId":"2773","sessionId":"657a8a35716925ee9c6ea04f","megogoAccessToken":"","authorization":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2ODY1NTk5MDIsImlzcyI6InVzZXIiLCJwaWQiOjc2MDY2LCJyb2xlIjoiY3VzdG9tZXIiLCJzdWIiOiI4YzUyNmFiZC0yZDBhLTQ1YzEtYjUyNy04MTRmOTliNWYwNDAifQ.ffXIBxI693pcaZmMrXNWEa_HrvYO_waN77FzBLbryUI","autoText":"Автонастройка","baseUrl":"https://api.spec.uzd.udevs.io/v1/","fromCache":false,"movieShareLink":"https://uzdplus.uz/movie/2773?type=moretv","ip":"","selectChannelIndex":0,"selectTvCategoryIndex":0,"tvCategories":[]});
    // final String jsonStringConfig = jsonEncode({"initialResolution":{"Автонастройка":"https://vb4.uma.media/1702537136/1ZUue55zJxx0LLpB3hFBtA/vod/vod:premierpartners/c269725cb1504376b80487926bd5a0a1.m3u8?streams=c7304609-1d2a-4039-87fe-a34e3b45cd8f:w:1920:h:1072:vb:4499968:ab:192000:d:2436640:vc:avc1.640029:ac:mp4a.40.2,c4a4c7a6-33d5-4961-994e-eb8e70f1f5a1:w:1280:h:720:vb:3000000:ab:128000:d:2436640:vc:avc1.640029:ac:mp4a.40.2,9a69a474-bd44-49b5-a57f-0412a53461e2:w:848:h:480:vb:1499968:ab:128000:d:2436640:vc:avc1.4d401f:ac:mp4a.40.2,640eee37-b88a-4a7b-bf5d-5ce576cb7716:w:640:h:368:vb:1299968:ab:64000:d:2436640:vc:avc1.42c01f:ac:mp4a.40.2"},"resolutions":{"Автонастройка":"https://vb4.uma.media/1702537136/1ZUue55zJxx0LLpB3hFBtA/vod/vod:premierpartners/c269725cb1504376b80487926bd5a0a1.m3u8?streams=c7304609-1d2a-4039-87fe-a34e3b45cd8f:w:1920:h:1072:vb:4499968:ab:192000:d:2436640:vc:avc1.640029:ac:mp4a.40.2,c4a4c7a6-33d5-4961-994e-eb8e70f1f5a1:w:1280:h:720:vb:3000000:ab:128000:d:2436640:vc:avc1.640029:ac:mp4a.40.2,9a69a474-bd44-49b5-a57f-0412a53461e2:w:848:h:480:vb:1499968:ab:128000:d:2436640:vc:avc1.4d401f:ac:mp4a.40.2,640eee37-b88a-4a7b-bf5d-5ce576cb7716:w:640:h:368:vb:1299968:ab:64000:d:2436640:vc:avc1.42c01f:ac:mp4a.40.2","1080p":"https://video-1-101.uma.media/hls-vod/vod:premierpartners/d_iGf9vuPm3FB2rEKOlecA/1702547937/87/0x5000c500b3655781/c73046091d2a403987fea34e3b45cd8f.mp4/index-v1-a1.m3u8?i=1920x1072_4499","720p":"https://video-1-101.uma.media/hls-vod/vod:premierpartners/rhOtQA_bMhy5-WGa5zDjPA/1702547937/65/0x5000c500b35aa934/c4a4c7a633d54961994eeb8e70f1f5a1.mp4/index-v1-a1.m3u8?i=1280x720_3000","480p":"https://video-1-101.uma.media/hls-vod/vod:premierpartners/YiFygmNxS5aFcfaYV2aZlQ/1702547937/75/0x5000c500b36439b4/9a69a474bd4449b5a57f0412a53461e2.mp4/index-v1-a1.m3u8?i=848x480_1499","368p":"https://video-1-101.uma.media/hls-vod/vod:premierpartners/yl4fj2X9HQpGJVXizHMCWQ/1702547937/69/0x5000c500b29af4bf/640eee37b88a4a7bbf5d5ce576cb7716.mp4/index-v1-a1.m3u8?i=640x368_1299"},"qualityText":"Качество","speedText":"Скорость","lastPosition":0,"title":"S1 E1  \"1 серия\" ","isSerial":true,"episodeButtonText":"Эпизоды","nextButtonText":"След.эпизод","seasons":[{"title":"1 Сезон","movies":[{"id":"43825","title":"1 серия","description":"После трагической гибели жены Антон решает заморозить ее мозг, чтобы дать ей шанс воскреснуть в будущем. В этом ему помогает компания «КриоРус», созданная Данилой и Валерией. Но спустя три года надежда Антона на будущее воскрешение его жены рушится.","image":"http://media.qfilm.platform24.tv/img/vod_episode/0a/cf/0acfb73e28b760219866727231f99b0e.jpeg","duration":0,"resolutions":{}},{"id":"43826","title":"2 серия","description":"Создание первой криофирмы за пределами США – это заслуга Данилы и Валерии. История их любви и создания компании «КриоРус» тесно переплетены. Когда их союз распадается, будущее компании оказывается под угрозой.","image":"http://media.qfilm.platform24.tv/img/vod_episode/e0/d3/e0d37213b3a87871962e0224a66e1399.jpeg","duration":0,"resolutions":{}}]}],"isLive":false,"tvProgramsText":"Телеканалы","programsInfoList":[],"showController":true,"playVideoFromAsset":false,"assetPath":"","seasonIndex":0,"episodeIndex":0,"isMegogo":false,"isMoreTv":false,"isPremier":true,"videoId":"8405","sessionId":"657a8a35716925ee9c6ea04f","megogoAccessToken":"","authorization":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2ODY1NTk5MDIsImlzcyI6InVzZXIiLCJwaWQiOjc2MDY2LCJyb2xlIjoiY3VzdG9tZXIiLCJzdWIiOiI4YzUyNmFiZC0yZDBhLTQ1YzEtYjUyNy04MTRmOTliNWYwNDAifQ.ffXIBxI693pcaZmMrXNWEa_HrvYO_waN77FzBLbryUI","autoText":"Автонастройка","baseUrl":"https://api.spec.uzd.udevs.io/v1/","fromCache":false,"movieShareLink":"https://uzdplus.uz/movie/8405?type=premier","ip":"","selectChannelIndex":0,"selectTvCategoryIndex":0,"tvCategories":[]});
    return UdevsVideoPlayerPlatform.instance.playVideo(
      playerConfigJsonString: jsonStringConfig,
    );
  }

  Future<dynamic> downloadVideo({
    required DownloadConfiguration downloadConfig,
  }) {
    final String jsonStringConfig = jsonEncode(downloadConfig.toJson());
    return UdevsVideoPlayerPlatform.instance.downloadVideo(
      downloadConfigJsonString: jsonStringConfig,
    );
  }

  Future<dynamic> pauseDownload({
    required DownloadConfiguration downloadConfig,
  }) {
    final String jsonStringConfig = jsonEncode(downloadConfig.toJson());
    return UdevsVideoPlayerPlatform.instance.pauseDownload(
      downloadConfigJsonString: jsonStringConfig,
    );
  }

  Future<dynamic> resumeDownload({
    required DownloadConfiguration downloadConfig,
  }) {
    final String jsonStringConfig = jsonEncode(downloadConfig.toJson());
    return UdevsVideoPlayerPlatform.instance.resumeDownload(
      downloadConfigJsonString: jsonStringConfig,
    );
  }

  Future<bool> isDownloadVideo({
    required DownloadConfiguration downloadConfig,
  }) {
    final String jsonStringConfig = jsonEncode(downloadConfig.toJson());
    return UdevsVideoPlayerPlatform.instance.isDownloadVideo(
      downloadConfigJsonString: jsonStringConfig,
    );
  }

  Future<int?> getCurrentProgressDownload({
    required DownloadConfiguration downloadConfig,
  }) {
    final String jsonStringConfig = jsonEncode(downloadConfig.toJson());
    return UdevsVideoPlayerPlatform.instance.getCurrentProgressDownload(
      downloadConfigJsonString: jsonStringConfig,
    );
  }

  Stream<MediaItemDownload> get currentProgressDownloadAsStream =>
      UdevsVideoPlayerPlatform.instance.currentProgressDownloadAsStream();

  Future<int?> getStateDownload({
    required DownloadConfiguration downloadConfig,
  }) {
    final String jsonStringConfig = jsonEncode(downloadConfig.toJson());
    return UdevsVideoPlayerPlatform.instance.getStateDownload(
      downloadConfigJsonString: jsonStringConfig,
    );
  }

  Future<int?> getBytesDownloaded({
    required DownloadConfiguration downloadConfig,
  }) {
    final String jsonStringConfig = jsonEncode(downloadConfig.toJson());
    return UdevsVideoPlayerPlatform.instance.getBytesDownloaded(
      downloadConfigJsonString: jsonStringConfig,
    );
  }

  Future<int?> getContentBytesDownload({
    required DownloadConfiguration downloadConfig,
  }) {
    final String jsonStringConfig = jsonEncode(downloadConfig.toJson());
    return UdevsVideoPlayerPlatform.instance.getContentBytesDownload(
      downloadConfigJsonString: jsonStringConfig,
    );
  }

  Future<dynamic> removeDownload({
    required DownloadConfiguration downloadConfig,
  }) {
    final String jsonStringConfig = jsonEncode(downloadConfig.toJson());
    return UdevsVideoPlayerPlatform.instance.removeDownload(
      downloadConfigJsonString: jsonStringConfig,
    );
  }

  void dispose() => UdevsVideoPlayerPlatform.instance.dispose();
}
