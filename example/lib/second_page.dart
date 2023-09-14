import 'package:flutter/material.dart';
import 'package:udevs_video_player/udevs_video_player.dart';
import 'extensions.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  final _udevsVideoPlayerPlugin = UdevsVideoPlayer();

  Stream<MediaItemDownload> currentProgressDownloadAsStream() =>
      _udevsVideoPlayerPlugin.currentProgressDownloadAsStream;

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Plugin example app')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder(
              stream: currentProgressDownloadAsStream(),
              builder: (context, snapshot) {
                final data = snapshot.data;
                return Text(
                    data == null ? 'Not downloading' : '${data.percent}\n${data.state.toState()}');
              },
            )
          ],
        ),
      ),
    );
}
