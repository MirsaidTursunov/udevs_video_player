import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:udevs_video_player/udevs_video_player_method_channel.dart';

void main() {
  final MethodChannelUdevsVideoPlayer platform = MethodChannelUdevsVideoPlayer();
  const MethodChannel channel = MethodChannel('udevs_video_player');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((methodCall) async => '42');
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('playVideo', () async {
    expect(
        await platform.playVideo(playerConfigJsonString: ''),
        '42');
  });
}
