import 'package:flutter/material.dart';
import 'package:udevs_video_player/models/media_item_download.dart';
import 'package:udevs_video_player/udevs_video_player.dart';
import 'extensions.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  final _udevsVideoPlayerPlugin = UdevsVideoPlayer();

  Stream<MediaItemDownload> currentProgressDownloadAsStream() =>
      _udevsVideoPlayerPlugin.currentProgressDownloadAsStream;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Plugin example app')),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder(
              stream: currentProgressDownloadAsStream(),
              builder: (context, snapshot) {
                var data = snapshot.data as MediaItemDownload?;
                return Text(
                    data == null ? 'Not downloading' : '${data.percent}\n${data.state.toState()}');
              },
            )
          ],
        ),
      ),
    );
  }
}
