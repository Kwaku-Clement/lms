import 'package:flutter/material.dart';

class DiscussionTile extends StatelessWidget {
  final String message;
  final String sender;

  DiscussionTile({
    this.message,
    this.sender,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: ListTile(
          title: Text(message,
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 15.0, color: Colors.white)),
          subtitle: Text(sender.toUpperCase(),
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: -0.5)),
        ),
      ),
    );
  }
}
