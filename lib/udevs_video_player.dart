import 'dart:convert';

import 'package:udevs_video_player/models/player_configuration.dart';

import 'udevs_video_player_platform_interface.dart';

export 'package:udevs_video_player/models/movie.dart';
export 'package:udevs_video_player/models/player_configuration.dart';
export 'package:udevs_video_player/models/programs_info.dart';
export 'package:udevs_video_player/models/season.dart';
export 'package:udevs_video_player/models/tv_program.dart';

class UdevsVideoPlayer {
  Future<String?> playVideo({
    required PlayerConfiguration playerConfig,
  }) {
    final String jsonStringConfig = jsonEncode(playerConfig.toJson());
    return UdevsVideoPlayerPlatform.instance.playVideo(
      playerConfigJsonString: jsonStringConfig,
    );
  }
}
