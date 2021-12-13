import 'package:flutter/material.dart';
import 'package:lms/calendar/calendar.dart';
import 'package:lms/tutor/homepage.dart';
import 'package:lms/widget/responsive.dart';

class WelcomeScreen extends StatelessWidget {
  final String courseId;
  final String courseName;

  const WelcomeScreen({Key key, this.courseId, this.courseName})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    // It provide us the width and height
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        // Let's work on our mobile part
        mobile: HomePage(),
        tablet: Row(
          children: [
            Expanded(
              flex: 9,
              child: HomePage(),
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
              child: HomePage(),
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
