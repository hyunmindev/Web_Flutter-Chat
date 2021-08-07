import 'package:flutter/material.dart';
import 'views/home_view.dart';
import 'views/room_view.dart';
import 'views/image_picker.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  Map? stackedRoom;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'firebase',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueGrey[900],
      ),
      home: Navigator(
        pages: [
          MaterialPage(
            child: HomeView(
              handleRoomTapped: (room) {
                setState(() {
                  stackedRoom = room;
                });
              },
            ),
          ),
          if (stackedRoom != null)
            MaterialPage(
              child: RoomView(
                room: stackedRoom,
              ),
            ),
        ],
        onPopPage: (route, result) {
          if (!route.didPop(result)) {
            return false;
          }
          setState(() {
            stackedRoom = null;
          });
          return true;
        },
      ),
    );
  }
}
