import 'package:flutter/material.dart';
import 'package:udevs_video_player/video_player_view.dart';

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({super.key});

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Video Player View')),
        body: VideoPlayerView(onMapViewCreated: _onMapViewCreated),
      );

  // load default assets
  void _onMapViewCreated(VideoPlayerViewController controller) {
    // controller.setAssets(
    //   assets: 'assets/splash.mp4',
    //   resizeMode: ResizeMode.fill,
    // );
    controller.setUrl(
      url:
          'https://test.cdn.uzdigital.tv/uzdigital/images/8cb238ae-bd88-4734-84f5-6bedc0f4c194.mp4',
    );
  }
}

/// 71 205 84 84
