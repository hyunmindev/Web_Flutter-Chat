import 'package:flutter/material.dart';
import '../api/read_users.dart';

class HomeView extends StatelessWidget {
  final Function(Map) handleRoomTapped;

  const HomeView({required this.handleRoomTapped});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: RoomListView(
        handleRoomTapped: (room) {
          handleRoomTapped(room);
        },
      ),
      drawer: Drawer(),
    );
  }
}

class RoomListView extends StatefulWidget {
  final Function(Map) handleRoomTapped;

  RoomListView({required this.handleRoomTapped});

  @override
  _RoomListViewState createState() => _RoomListViewState();
}

class _RoomListViewState extends State<RoomListView> {
  List<Map> rooms = [];

  @override
  void initState() {
    super.initState();
    readUsers().then((querySnapshot) {
      querySnapshot?.docs.forEach((doc) {
        setState(() {
          rooms.add({
            'id': doc.id,
            'title': doc['title'],
            'host': doc['host'],
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(10),
      itemCount: rooms.length,
      itemBuilder: (BuildContext context, int index) {
        return RoomListTile(
            handleRoomTapped: (room) {
              widget.handleRoomTapped(room);
            },
            room: rooms[index]);
      },
      separatorBuilder: (context, index) {
        return const Divider();
      },
    );
  }
}

class RoomListTile extends StatelessWidget {
  final Function(Map) handleRoomTapped;
  final Map room;

  const RoomListTile({required this.handleRoomTapped, required this.room});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        handleRoomTapped(room);
      },
      title: Text('${room['title']}'),
      subtitle: Text('${room['host']}'),
      leading: CircleAvatar(
        backgroundColor: Colors.white10,
      ),
    );
  }
}
