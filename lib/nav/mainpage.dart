import 'package:flutter/material.dart';
import 'package:lms/constants/custom_colors.dart';
import 'package:lms/screens/announcement.dart';
import 'package:lms/screens/assignment.dart';
import 'package:lms/screens/dashboard.dart';
import 'package:lms/screens/gradebook.dart';
import 'package:lms/screens/overview.dart';
import 'package:lms/screens/resources.dart';
import 'package:lms/screens/schedule.dart';
import 'package:lms/screens/test_quiz.dart';
import 'package:lms/tutor/homepage.dart';

import 'drawer_items.dart';
import 'drawer_model.dart';
import 'drawer_widget.dart';

class MainPage extends StatefulWidget {
  final String courseId;
  final String courseName;
  final String overview;
  const MainPage({Key key, this.courseId, this.courseName, this.overview})
      : super(key: key);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  double xOffset;
  double yOffset;
  double scaleFactor;
  DrawerItem item = DrawerItems.dashboard;
  bool isDrawerOpen;
  bool isDragging = false;

  @override
  void initState() {
    super.initState();

    closeDrawer();
  }

  openDrawer() => setState(() {
        xOffset = 230;
        yOffset = 100;
        scaleFactor = 0.9;

        isDrawerOpen = true;
      });

  closeDrawer() => setState(() {
        xOffset = 0;
        yOffset = 0;
        scaleFactor = 1;

        isDrawerOpen = false;
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          isDrawerOpen ? CustomColors.googleBackground : Colors.white12,
      body: Stack(children: [
        buildDrawer(),
        buildPage(),
      ]),
    );
  }

  Widget buildDrawer() => SafeArea(
        child: Container(
          width: xOffset,
          child: DrawerWidget(
            onSelectedItem: (item) {
              switch (item) {
                default:
                  setState(() {
                    this.item = item;
                    closeDrawer();
                  });
              }
            },
          ),
        ),
      );

  Widget buildPage() {
    return WillPopScope(
      onWillPop: () async {
        if (isDrawerOpen) {
          closeDrawer();
          return false;
        } else {
          return true;
        }
      },
      child: GestureDetector(
        onTap: closeDrawer,
        onHorizontalDragStart: (details) => isDragging = false,
        onHorizontalDragUpdate: (details) {
          if (!isDragging) return;
          const delta = 1;
          if (details.delta.dx > delta) {
            openDrawer();
          } else if (details.delta.dx < -delta) {
            closeDrawer();
          }
          isDragging = false;
        },
        child: AnimatedContainer(
            transform: Matrix4.translationValues(xOffset, yOffset, 0)
              ..scale(scaleFactor),
            duration: Duration(milliseconds: 300),
            child: AbsorbPointer(
              absorbing: isDrawerOpen,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(isDrawerOpen ? 20 : 0),
                child: Container(
                  color: isDrawerOpen ? Colors.grey : CustomColors.firebaseGrey,
                  child: getDrawerPage(),
                ),
              ),
            )),
      ),
    );
  }

  Widget getDrawerPage() {
    switch (item) {
      case DrawerItems.dashboard:
        return Dashboard(
          courseId: widget.courseId,
          overview: widget.overview,
          openDrawer: openDrawer,
        );
      case DrawerItems.overview:
        return Overview(
          openDrawer: openDrawer,
          courseId: widget.courseId,
        );
      case DrawerItems.announcement:
        return Announcement(
          openDrawer: openDrawer,
          courseId: widget.courseId,
        );

      case DrawerItems.resources:
        return Resources(
          openDrawer: openDrawer,
          courseId: widget.courseId,
        );
      case DrawerItems.schedule:
        return Schedule(
          openDrawer: openDrawer,
          courseId: widget.courseId,
        );
      case DrawerItems.assignment:
        return Assignment(
          openDrawer: openDrawer,
          courseId: widget.courseId,
        );
      case DrawerItems.test_quiz:
        return TestQuiz(
          openDrawer: openDrawer,
          courseId: widget.courseId,
        );

      case DrawerItems.gradebook:
        return GradeBook(
          openDrawer: openDrawer,
          courseId: widget.courseId,
        );

      case DrawerItems.home:
        return HomePage();

      default:
        return Dashboard(
          courseId: widget.courseId,
          overview: widget.overview,
          openDrawer: openDrawer,
        );
    }
  }
}
