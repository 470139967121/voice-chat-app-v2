import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/models/room_model.dart';
import 'features/room/screens/room_screen_new.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice Chat Room',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.yellow,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voice Rooms')),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          final room = RoomModel(
            id: 'room_$index',
            name: 'Voice Room $index',
            description: 'A place to chat via voice records',
            hostId: 'host_$index',
            participants: [],
            moderators: [],
            createdAt: DateTime.now(),
          );
          return ListTile(
            title: Text(room.name),
            subtitle: Text(room.description),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RoomScreenNew(room: room),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
