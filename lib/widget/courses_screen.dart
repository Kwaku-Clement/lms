import 'package:flutter/material.dart';
import 'package:lms/calendar/calendar.dart';
import 'package:lms/screens/courses.dart';
import 'package:lms/widget/responsive.dart';

class CourseScreen extends StatelessWidget {
  final String courseId;
  final String courseName;
  final String username;
  final String overview;

  const CourseScreen(
      {Key key, this.courseId, this.courseName, this.username, this.overview})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    // It provide us the width and height
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        // Let's work on our mobile part
        mobile: Courses(
          courseId: courseId,
          courseName: courseName,
          username: username,
          overview: overview,
        ),
        tablet: Row(
          children: [
            Expanded(
              flex: 9,
              child: Courses(
                courseId: courseId,
                courseName: courseName,
                username: username,
                overview: overview,
              ),
            ),
            Expanded(
              flex: 5,
              child: Calendar(),
            ),
          ],
        ),
        desktop: Row(
          children: [
            // Once our width is less then 1300 then it start showing errors
            // Now there is no error if our width is less then 1340

            Expanded(
              flex: _size.width > 1340 ? 6 : 9,
              child: Courses(
                courseId: courseId,
                courseName: courseName,
                username: username,
                overview: overview,
              ),
            ),
            Expanded(
              flex: _size.width > 1340 ? 3 : 6,
              child: Calendar(),
            ),
          ],
        ),
      ),
    );
  }
}
