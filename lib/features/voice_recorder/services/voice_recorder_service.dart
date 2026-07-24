import 'dart:io';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class VoiceRecorderService {
  final AudioRecorder _recorder = AudioRecorder();
  String? _currentPath;

  Future<void> startRecording() async {
    if (await _recorder.hasPermission()) {
      final directory = await getTemporaryDirectory();
      _currentPath = p.join(directory.path, 'voice_record_${DateTime.now().millisecondsSinceEpoch}.m4a');
      
      const config = RecordConfig();
      await _recorder.start(config, path: _currentPath!);
    }
  }

  Future<String?> stopRecording() async {
    final path = await _recorder.stop();
    return path;
  }

  Future<void> dispose() async {
    await _recorder.dispose();
  }
}
