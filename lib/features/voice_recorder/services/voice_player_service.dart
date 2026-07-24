import 'package:audioplayers/audioplayers.dart';

class VoicePlayerService {
  final AudioPlayer _player = AudioPlayer();

  Future<void> playFromUrl(String url) async {
    await _player.play(UrlSource(url));
  }

  Future<void> playFromFile(String path) async {
    await _player.play(DeviceFileSource(path));
  }

  Future<void> stop() async {
    await _player.stop();
  }

  void onPlayerComplete(Function() callback) {
    _player.onPlayerComplete.listen((_) => callback());
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}
