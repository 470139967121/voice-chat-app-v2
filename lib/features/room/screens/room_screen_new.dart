import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/models/room_model.dart';
import '../../../core/models/voice_message_model.dart';
import '../../../core/services/firebase_service.dart';
// import '../../voice_recorder/services/voice_recorder_service.dart';
import '../../voice_recorder/services/voice_player_service.dart';

class RoomScreenNew extends StatefulWidget {
  final RoomModel room;

  const RoomScreenNew({super.key, required this.room});

  @override
  State<RoomScreenNew> createState() => _RoomScreenNewState();
}

class _RoomScreenNewState extends State<RoomScreenNew> {
  // final VoiceRecorderService _recorderService = VoiceRecorderService();
  final VoicePlayerService _playerService = VoicePlayerService();
  final FirebaseService _firebaseService = FirebaseService();
  bool _isRecording = false;
  List<VoiceMessageModel> _messageQueue = [];
  bool _isPlaying = false;
  String? _currentlyPlayingSenderId;

  @override
  void initState() {
    super.initState();
    _setupMessageListener();
  }

  void _setupMessageListener() {
    _firebaseService.getVoiceMessages(widget.room.id).listen((messages) {
      for (var msg in messages) {
        if (!_messageQueue.any((m) => m.id == msg.id)) {
          _messageQueue.add(msg);
        }
      }
      _playNextInQueue();
    });
  }

  Future<void> _playNextInQueue() async {
    if (_isPlaying || _messageQueue.isEmpty) return;

    setState(() {
      _isPlaying = true;
      _currentlyPlayingSenderId = _messageQueue.first.senderId;
    });
    
    final nextMsg = _messageQueue.first;

    await _playerService.playFromUrl(nextMsg.audioUrl);
    _playerService.onPlayerComplete(() {
      setState(() {
        _isPlaying = false;
        _currentlyPlayingSenderId = null;
        _messageQueue.removeAt(0);
      });
      _playNextInQueue();
    });
  }

  Future<void> _handleRecording() async {
    // Recording disabled for now to allow build
    /*
    if (_isRecording) {
      final path = await _recorderService.stopRecording();
      setState(() => _isRecording = false);
      if (path != null) {
        final url = await _firebaseService.uploadVoiceMessage(path, widget.room.id);
        final message = VoiceMessageModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          senderId: _firebaseService.currentUser?.uid ?? 'anon',
          senderName: 'User',
          senderAvatar: '',
          audioUrl: url,
          duration: 0,
          timestamp: DateTime.now(),
          roomId: widget.room.id,
        );
        await _firebaseService.sendVoiceMessage(message);
      }
    } else {
      await _recorderService.startRecording();
      setState(() => _isRecording = true);
    }
    */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.room.name),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                bool isSpeaking = _isPlaying && index == 0;
                return Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: isSpeaking 
                          ? Border.all(color: Colors.yellow, width: 4) 
                          : null,
                        boxShadow: isSpeaking ? [
                          BoxShadow(color: Colors.yellow.withOpacity(0.5), blurRadius: 10, spreadRadius: 5)
                        ] : null,
                      ),
                      child: const CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.person, color: Colors.white, size: 40),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('Seat', style: TextStyle(color: Colors.white)),
                  ],
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Column(
              children: [
                GestureDetector(
                  onLongPressStart: (_) => _handleRecording(),
                  onLongPressEnd: (_) => _handleRecording(),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: _isRecording ? Colors.red : Colors.yellow[700],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isRecording ? Icons.stop : Icons.mic,
                      size: 50,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _isRecording ? 'Recording...' : 'Hold to record voice',
                  style: TextStyle(
                    color: _isRecording ? Colors.red : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // _recorderService.dispose();
    _playerService.dispose();
    super.dispose();
  }
}
