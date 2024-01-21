import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:incog/profile_screen.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatPage extends StatelessWidget {
  final User user;
  final String assignedUsername;

  ChatPage({required this.user, required this.assignedUsername});
  TextEditingController _messageController = TextEditingController();

  Future<void> _getRandomUsername() async {
    final response = await http.get(
      Uri.parse(
          'https://random-user-by-api-ninjas.p.rapidapi.com/v1/randomuser'),
      headers: {
        'X-RapidAPI-Key': 'c25f076e58msh09208d2ca1d495ap1d5bf5jsna2ca651105cc',
        'X-RapidAPI-Host': 'random-user-by-api-ninjas.p.rapidapi.com',
      },
    );
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isNotEmpty) {
      await FirebaseFirestore.instance.collection('messages_${user.uid}').add({
        'text': _messageController.text,
        'sender': assignedUsername, // Use assigned username
        'timestamp': FieldValue.serverTimestamp(),
      });
      _messageController.clear();
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final formatter = DateFormat('HH:mm:ss'); // Customize the format as needed
    return formatter.format(timestamp);
  }

  Future<void> _deleteAllMessages() async {
    QuerySnapshot messagesSnapshot = await FirebaseFirestore.instance
        .collection('messages_${user.uid}')
        .get();

    for (QueryDocumentSnapshot messageDoc in messagesSnapshot.docs) {
      await messageDoc.reference.delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Room'),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete_messages') {
                _deleteAllMessages();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'delete_messages',
                  child: Text('Delete All Messages'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.black, Colors.tealAccent],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('messages_${user.uid}')
                    .orderBy('timestamp')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  var messages = snapshot.data!.docs;
                  List<Widget> messageWidgets = [];

                  for (var message in messages) {
                    var messageText = message['text'];
                    var messageSender = message['sender'] ??
                        'Anonymous'; // Use display name or default to 'Anonymous'
                    var messageTimestamp = message['timestamp'];

                    // Inside the StreamBuilder where you display messages
                    var messageWidget = ListTile(
                      title: Text(messageSender,
                          style: TextStyle(
                              color: Colors.white)), // Display username
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            messageText,
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.white),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            messageTimestamp != null
                                ? _formatTimestamp(messageTimestamp.toDate())
                                : 'Timestamp not available',
                            style:
                                TextStyle(fontSize: 10.0, color: Colors.grey),
                          ),
                        ],
                      ),
                    );

                    messageWidgets.add(messageWidget);
                  }

                  return ListView(
                    children: messageWidgets,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.tealAccent,
              ),
              child: Text('Incog'),
            ),
            ListTile(
              title: Text('Profile'),
              onTap: () {
                // Implement navigation to the profile screen
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(),
                    ));
              },
            ),
            ListTile(
              title: Text('Log Out'),
              onTap: () {
                // Implement navigation to the log in screen
                FirebaseAuth.instance.signOut();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
