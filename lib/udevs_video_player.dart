import 'dart:async';
import 'dart:convert';

import 'package:udevs_video_player/models/download_configuration.dart';
import 'package:udevs_video_player/models/media_item_download.dart';
import 'package:udevs_video_player/models/player_configuration.dart';

import 'models/live_player_configuration.dart';
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
    return UdevsVideoPlayerPlatform.instance.playVideo(
      playerConfigJsonString: jsonStringConfig,
    );
  }

  Future<int?> playLiveVideo({required LivePlayerConfiguration playerConfig}) {
    final String jsonStringConfig = jsonEncode(playerConfig.toJson());
    return UdevsVideoPlayerPlatform.instance.playLiveVideo(
      livePlayerConfigJsonString: jsonStringConfig,
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
