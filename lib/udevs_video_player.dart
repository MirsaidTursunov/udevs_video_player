import 'dart:convert';

import 'package:udevs_video_player/models/player_configuration.dart';

import 'udevs_video_player_platform_interface.dart';
export 'package:udevs_video_player/models/player_configuration.dart';
export 'package:udevs_video_player/models/movie.dart';
export 'package:udevs_video_player/models/story.dart';
export 'package:udevs_video_player/models/movie_track.dart';
export 'package:udevs_video_player/models/season.dart';
export 'package:udevs_video_player/models/tv_program.dart';
export 'package:udevs_video_player/models/programs_info.dart';

class UdevsVideoPlayer {
  Future<String?> playVideo({
    required PlayerConfiguration playerConfig,
  }) {
    String jsonStringConfig = jsonEncode({"initialResolution":{"auto":"https://cdn.sharqtv.udevs.io/sharqtv/videos/154cb044f06502d36ae4f9d7c23d1e72/master.m3u8","360p":"https://cdn.sharqtv.udevs.io/sharqtv/videos/154cb044f06502d36ae4f9d7c23d1e72/360p/index.m3u8","240p":"https://cdn.sharqtv.udevs.io/sharqtv/videos/154cb044f06502d36ae4f9d7c23d1e72/240p/index.m3u8"},"resolutions":{"auto":"https://cdn.sharqtv.udevs.io/sharqtv/videos/154cb044f06502d36ae4f9d7c23d1e72/master.m3u8","360p":"https://cdn.sharqtv.udevs.io/sharqtv/videos/154cb044f06502d36ae4f9d7c23d1e72/360p/index.m3u8","240p":"https://cdn.sharqtv.udevs.io/sharqtv/videos/154cb044f06502d36ae4f9d7c23d1e72/240p/index.m3u8"},"qualityText":"Качество","speedText":"Скорость","type":"story","lastPosition":0,"title":"","platform":"7e9217c5-a6b4-490a-9e90-dad564f39361","episodeButtonText":"Эпизоды","nextButtonText":"След.эпизод","seasons":[],"tvProgramsText":"Телеканалы","programsInfoList":[],"showController":true,"playVideoFromAsset":false,"assetPath":"","seasonIndex":0,"episodeIndex":0,"isMegogo":false,"isPremier":false,"videoId":"","sessionId":"","megogoAccessToken":"","authorization":"","autoText":"Автонастройка","baseUrl":"https://api.spec.sharqtv.udevs.io/v1/","story":[{"id":"637725940800c103f7b40102","title":"Dovranbek Turdiev","quality":"auto","duration":89,"slug":"dovranbek-turdiev","story_link":"teacher-azam-movies","fileName":"https://cdn.sharqtv.udevs.io/sharqtv/videos/c996660373c7da0de412465dd7375703/master.m3u8","is_watched":false,"is_amediateka":false},{"id":"63746dd80800c103f7b1c2b0","title":"test","quality":"auto","duration":182,"slug":"test-5NcOW7_v4","story_link":"test2","fileName":"https://cdn.sharqtv.udevs.io/sharqtv/videos/38f2bf70fe91a1b7e4996cde207ccc1b/master.m3u8","is_watched":false,"is_amediateka":false},{"id":"63621ceb0800c103f7986907","title":"Teacher Azam","quality":"auto","duration":6,"slug":"teacher-azam","story_link":"teacher-azam-movies","fileName":"https://cdn.sharqtv.udevs.io/sharqtv/videos/154cb044f06502d36ae4f9d7c23d1e72/master.m3u8","is_watched":false,"is_amediateka":false},{"id":"63592a6a36b03d2e94c91e1d","title":"Fast & Furious Presents: Hobbs & Shaw","quality":"auto","duration":217,"slug":"fast-and-furious-presents-hobbs-and-shaw-x1cufWzK9","story_link":"matrica","fileName":"https://cdn.sharqtv.udevs.io/sharqtv/videos/6df3c168e016fe6e9ea7d95ace63c5da/master.m3u8","is_watched":false,"is_amediateka":true},{"id":"63592a0936b03d2e94c9192b","title":"Игра престолов","quality":"auto","duration":208,"slug":"igra-prestolov","story_link":"test2","fileName":"https://cdn.sharqtv.udevs.io/sharqtv/videos/bcded0bdc32d75421b1748c22d034814/master.m3u8","is_watched":false,"is_amediateka":false},{"id":"635929a736b03d2e94c908d9","title":"Зелёный фонарь","quality":"auto","duration":150,"slug":"zelyonyi-fonar-_lUxxSITm","story_link":"zelyonyi-fonar","fileName":"https://cdn.sharqtv.udevs.io/sharqtv/videos/b58397f1aaf844670213cf839013170f/master.m3u8","is_watched":false,"is_amediateka":false}],"storyButtonText":"Смотреть фильм","closeText":"Закрыть","seasonText":"сезон","storyIndex":2,"movieTrack":{"episode_key":"","is_megogo":false,"movie_key":"","season_key":"","seconds":0,"user_id":" ","element":""},"userId":" "});
    return UdevsVideoPlayerPlatform.instance.playVideo(
      playerConfigJsonString: jsonStringConfig,
    );
  }

  Future<dynamic> closeVideo() {
    return UdevsVideoPlayerPlatform.instance.closeVideo();
  }
}
