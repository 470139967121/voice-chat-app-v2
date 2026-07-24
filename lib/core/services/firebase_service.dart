import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/room_model.dart';
import '../models/voice_message_model.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  User? get currentUser => _auth.currentUser;

  Stream<List<RoomModel>> getRooms() {
    return _firestore.collection('rooms').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => RoomModel.fromMap(doc.data())).toList();
    });
  }

  Future<void> createRoom(RoomModel room) async {
    await _firestore.collection('rooms').doc(room.id).set(room.toMap());
  }

  Future<String> uploadVoiceMessage(String filePath, String roomId) async {
    final file = File(filePath);
    final ref = _storage.ref().child('voice_messages/$roomId/${DateTime.now().millisecondsSinceEpoch}.m4a');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  Future<String> uploadFile(String path, File file) async {
    final ref = _storage.ref().child(path);
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  Future<void> sendVoiceMessage(VoiceMessageModel message) async {
    await _firestore.collection('rooms').doc(message.roomId).collection('messages').doc(message.id).set(message.toMap());
  }

  Future<void> sendNotification(String roomId, Map<String, dynamic> data) async {
    await _firestore.collection('rooms').doc(roomId).collection('notifications').add(data);
  }

  Stream<List<VoiceMessageModel>> getVoiceMessages(String roomId) {
    return _firestore
        .collection('rooms')
        .doc(roomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => VoiceMessageModel.fromMap(doc.data())).toList();
    });
  }
}
