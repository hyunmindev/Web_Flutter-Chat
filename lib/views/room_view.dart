import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../api/create_chat.dart';

class RoomView extends StatefulWidget {
  final Map? room;

  const RoomView({required this.room});

  @override
  _RoomViewState createState() => _RoomViewState();
}

class _RoomViewState extends State<RoomView> {
  TextEditingController _textEditingController = TextEditingController();

  var focusNode = FocusNode();
  String chatText = '';

  @override
  void initState() {
    super.initState();
  }

  void handleSubmit() {
    setState(() {
      chatText = _textEditingController.text;
    });
    createChat(widget.room?['id'], {
      'content': chatText,
    });
    setState(() {
      _textEditingController.clear();
    });
    focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            '${widget.room?['title']}',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Text(
            '${widget.room?['host']}',
            style: TextStyle(fontSize: 12, color: Colors.white70),
          )
        ]),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatListView(
              roomID: widget.room?['id'],
            ),
          ),
          Container(
            margin: EdgeInsets.all(16),
            child: Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) {
                      handleSubmit();
                    },
                    autofocus: true,
                    focusNode: focusNode,
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                FloatingActionButton(
                    onPressed: () {
                      handleSubmit();
                    },
                    backgroundColor: Colors.blueGrey,
                    child: Icon(
                      Icons.add_circle_outline,
                      color: Colors.white70,
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatListView extends StatefulWidget {
  final String roomID;

  const ChatListView({required this.roomID});

  @override
  _ChatListViewState createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  late Stream<QuerySnapshot> _usersStream;

  @override
  void initState() {
    super.initState();
    _usersStream = FirebaseFirestore.instance
        .collection('ROOM')
        .doc(widget.roomID)
        .collection('CHAT')
        .orderBy('time')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return Text("Done");
        }
        return new ListView(
          reverse: true,
          children:
              snapshot.data!.docs.reversed.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return new Card(
              margin: EdgeInsets.all(8),
              child: Container(
                margin: EdgeInsets.all(16),
                child: Text(data['content']),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class ChatListTile extends StatelessWidget {
  final Map chat;

  const ChatListTile({required this.chat});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              chat['content'],
              style: TextStyle(
                fontSize: 36,
              ),
            ),
            // Text(chat['time'].toString()),
          ],
        ),
      ),
    );
  }
}
