import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String sender;
  final String text;
  final DateTime timestamp;

  const ChatMessage({
    Key? key,
    required this.sender,
    required this.text,
    required this.timestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$sender • ${_formatTimestamp(timestamp)}',
          style: TextStyle(color: Colors.grey),
        ),
        SizedBox(height: 4.0),
        Text(text),
        Divider(),
      ],
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    return 'formatted_timestamp';
  }
}
