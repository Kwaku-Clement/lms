import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lms/quiz/views/create_quiz.dart';
import 'package:lms/widget/responsive.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lms/constants/constants.dart';
import 'package:lms/nav/custom_appbar.dart';
import 'package:lms/service/database.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:lms/tutor/add_announcement.dart';
import 'package:lms/tutor/add_assignment.dart';
import 'package:lms/tutor/add_files.dart';
import 'package:lms/tutor/add_overview.dart';
import 'package:lms/tutor/add_schedule.dart';
import 'package:lms/tutor/add_vdeo.dart';
import 'package:lms/widget/BottomSheet.dart';
import 'package:lms/widget/main_screen.dart';

import '../constants/colors.dart';

class Dashboard extends StatefulWidget {
  final String courseId;
  final String courseName;
  final String overview;
  final VoidCallback openDrawer;

  const Dashboard(
      {Key key, this.openDrawer, this.courseId, this.courseName, this.overview})
      : super(key: key);
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String _userName = '';
  User _user;
  Stream _courses;

  bool dataReceived = false;
  String userRole = '';

  String overview =
      '''Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ultrices placerat ac pellentesque aenean cursus metus amet. Malesuada ullamcorper nullam commodo amet turpis sem consectetur ac. Tempor et diam cras hendrerit porttitor cursus accumsan, lectus pulvinar. Nulla tellus lobortis hac quam quis sed in ac pellentesque.\n
Nulla cras purus etiam magna. Enim ornare ornare neque ornare commodo lacus. Morbi ut nisl, scelerisque nibh nunc lobortis. Dictum dictum pellentesque nunc risus, nulla posuere amet, amet. Amet, cras vitae fermentum risus elit. Neque mauris hac dignissim scelerisque. Ipsum mauris fringilla feugiat at venenatis ornare volutpat at leo. In est sit in turpis. Purus viverra nisl dapibus in fringilla id morbi.''';

  // initState()
  @override
  void initState() {
    super.initState();
    getUserData();
    _getUserAuthAndJoinedGroups();
    print(widget.courseName);
  }

  // functions
  getUserData() async {
    DocumentSnapshot userdoc =
        await userCollection.doc(FirebaseAuth.instance.currentUser.uid).get();
    setState(() {
      _userName = userdoc.get('username');
      userRole = userdoc.get('role');
      dataReceived = true;
    });
  }

  _getUserAuthAndJoinedGroups() async {
    _user = FirebaseAuth.instance.currentUser;

    await Database(uid: _user.uid).getUserCourses().then((snapshots) {
      setState(() {
        _courses = snapshots;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        openDrawer: widget.openDrawer,
      ),
      body: Container(
        padding: EdgeInsets.only(
          top: kIsWeb ? kDefaultPadding : 0,
          left: kIsWeb ? 30 : 0,
        ),
        width: Responsive.isMobile(context)
            ? MediaQuery.of(context).size.width
            : 900,
        color: Colors.white,
        child: Column(
          children: [
            Divider(thickness: 1),
            Container(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(kDefaultPadding),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(
                                text:
                                    "Welcome! $_userName to \n${widget.courseName}",
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Divider(thickness: 1),
                      SizedBox(height: 20),
                      LayoutBuilder(
                        builder: (context, constraints) => SizedBox(
                          width: constraints.maxWidth > 850
                              ? 800
                              : constraints.maxWidth,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Course Summary",
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              SizedBox(height: 15),
                              Container(
                                child: Text.rich(
                                  TextSpan(
                                    text: widget.overview,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              // Row(
                              //   children: [
                              //     Text(
                              //       "COURSES",
                              //       style: TextStyle(fontSize: 12),
                              //     ),
                              //     Spacer(),
                              //     TextButton(
                              //       onPressed: () {
                              //         Navigator.push(
                              //           context,
                              //           MaterialPageRoute(
                              //               builder: (context) =>
                              //                   CourseScreen()),
                              //         );
                              //       },
                              //       child: Text(
                              //         "Go to courses",
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              // Divider(thickness: 1),
                              // SizedBox(height: 10),
                              SizedBox(height: kDefaultPadding / 2),
                              //  groupsList(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: dataReceived == false
          ? Container()
          : userRole == 'Tutor'
              ? FloatingActionButton.extended(
                  onPressed: adminMenu,
                  tooltip: 'Update',
                  label: Text("Update Course"),
                  icon: Icon(Icons.add))
              : Container(),
    );
  }

  adminMenu() {
    showModalBottomSheet(
        enableDrag: false,
        context: (context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 28.0),
            child: BottomSheetWidget(
              container: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 300,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: names.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              leading: Icon(icons[index]),
                              title: Text(
                                "${names[index]}",
                              ),
                              onTap: () => selectedUpdate(context, index),
                            ),
                          );
                        }),
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget groupsList() {
    return StreamBuilder(
      stream: _courses,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['courseNames'] != null) {
            if (snapshot.data['courseNames'].length != 0) {
              return ListView.builder(
                  itemCount: snapshot.data['courseNames'].length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    int reqIndex =
                        snapshot.data['courseNames'].length - index - 1;
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                            leading: CircleAvatar(
                              radius: 30.0,
                              backgroundColor: Colors.blueAccent,
                              child: Text(
                                  destructureName(snapshot.data['courseNames']
                                          [reqIndex])
                                      .substring(0, 1)
                                      .toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white)),
                            ),
                            title: Text(
                              destructureName(
                                  snapshot.data['courseNames'][reqIndex]),
                            ),
                            onTap: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MainScreen(
                                      courseName: snapshot.data['courseNames']
                                          [reqIndex],
                                      courseId: snapshot.data['courseIds']
                                          [reqIndex],
                                      overview: snapshot.data['overview']
                                          [reqIndex],
                                    ),
                                  ),
                                  (Route<dynamic> route) => false);
                            }),
                      ),
                    );
                  });
            } else {
              return Container(
                child: Text(
                    "You've not joined any course, tap on the 'search bar' icon to search for courses by tapping on the search button below."),
              );
            }
          } else {
            return Container(
              child: Text(
                  "You've not joined any course, tap on the 'search bar'  icon to search for courses by tapping on the search button below."),
            );
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  selectedUpdate(BuildContext context, item) {
    switch (item) {
      case 0:
        showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 260,
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Choose what you want to update'),
                        ),
                        SizedBox(height: 10),
                        Card(
                          child: InkWell(
                              child: ListTile(
                                leading: Icon(Icons.file_upload),
                                title: Text('Documents'),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AddFile(courseId: widget.courseId),
                                    ));
                              }),
                        ),
                        SizedBox(height: 10),
                        Card(
                          child: InkWell(
                              child: ListTile(
                                leading: Icon(Icons.picture_in_picture),
                                title: Text('Videos'),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AddVideo(courseId: widget.courseId),
                                    ));
                              }),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              );
            });
        break;
      case 1:
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddAnnouncement(
                  courseId: widget.courseId, courseName: widget.courseName),
            ));
        break;
      case 2:
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddOverView(courseId: widget.courseId),
            ));
        break;
      case 3:
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddSchedule(courseId: widget.courseId),
            ));
        break;

      case 4:
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddAssignment(courseId: widget.courseId),
            ));
        break;
      case 5:
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateTest(courseId: widget.courseId),
            ));
        break;
    }
  }

  final List names = [
    'Update resources',
    'Add announcement',
    'Add Overvew',
    'Add Meeting',
    'Add Assignment',
    'Create Quiz',
  ];

  final List icons = [
    Icons.folder_open_outlined,
    Icons.announcement_outlined,
    Icons.preview,
    Icons.schedule,
    Icons.assignment,
    Icons.clean_hands_outlined,
  ];
}
