import 'package:flutter/material.dart';
import 'package:lms/screens/preview.dart';

class PreviewTile extends StatelessWidget {
  final String userName;
  final String courseId;
  final String courseName;

  PreviewTile({this.userName, this.courseId, this.courseName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Preview(
                      courseId: courseId,
                      courseName: courseName,
                    )));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30.0,
            backgroundColor: Colors.blueAccent,
            child: Text(courseName.substring(0, 1).toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white)),
          ),
          title:
              Text(courseName, style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text("Join the course as $userName",
              style: TextStyle(fontSize: 13.0)),
        ),
      ),
    );
  }
}
