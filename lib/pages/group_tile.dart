import 'package:flutter/material.dart';
import 'package:lms/widget/preview_screen.dart';

class GroupTile extends StatelessWidget {
  final String userName;
  final String courseId;
  final String courseName;
  final String overview;

  GroupTile({this.userName, this.courseId, this.courseName, this.overview});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PreviewScreen(
                        courseId: courseId,
                        courseName: courseName,
                        username: userName,
                        overview: overview,
                      )));
        },
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(5.0),
            child: ListTile(
              leading: CircleAvatar(
                radius: 30.0,
                backgroundColor: Colors.blueAccent,
                child: Text(courseName.substring(0, 1).toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white)),
              ),
              title: Text(courseName,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle:
                  Text("Join the course", style: TextStyle(fontSize: 13.0)),
            ),
          ),
        ),
      ),
    );
  }
}
