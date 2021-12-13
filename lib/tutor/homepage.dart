import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lms/widget/responsive.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lms/constants/colors.dart';
import 'package:lms/constants/constants.dart';
import 'package:lms/constants/custom_colors.dart';
import 'package:lms/models/course_model.dart';
import 'package:lms/models/provider_notifier.dart';
import 'package:lms/nav/custom_appbar.dart';
import 'package:lms/service/database.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:lms/widget/admin_bottomSheet.dart';
import 'package:lms/widget/courses_screen.dart';
import 'package:lms/widget/main_screen.dart';
import 'package:lms/widget/preview_screen.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final VoidCallback openDrawer;

  const HomePage({Key key, this.openDrawer}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _userName = '';
  Stream _courses;
  String search;
  TextEditingController searchController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController courseNameController = TextEditingController();
  final TextEditingController courseOverviewController =
      TextEditingController();
  CourseModel _courseModel;

  bool dataReceived = false;
  String userRole = '';

  // initState()
  @override
  void initState() {
    super.initState();
    getUserData();
    _getUserAuthAndJoinedGroups();

    ProviderNotifier modelNotifier =
        Provider.of<ProviderNotifier>(context, listen: false);

    if (modelNotifier.currentModel != null) {
      _courseModel = modelNotifier.currentCourse;
    } else {
      _courseModel = CourseModel();
    }
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

  void _popupDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    Widget createButton = TextButton(
      child: Text("Create"),
      onPressed: () async {
        if (!_formKey.currentState.validate()) {
          return;
        }
        _formKey.currentState.save();

        Database(uid: user.uid)
            .createCourse(_courseModel, _userName, _courseCreated);
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Create a course"),
      content: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 200,
            child: Column(children: [
              Container(
                child: TextFormField(
                  //initialValue: _courseModel.courseName,
                  controller: courseNameController,
                  keyboardType: TextInputType.multiline,
                  decoration: kInputTextFieldDecoration.copyWith(
                      labelText: 'Course Name'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Course name is required';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _courseModel.courseName = value;
                  },
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                child: Container(
                  child: TextFormField(
                    //initialValue: _courseModel.overview,
                    controller: courseOverviewController,
                    minLines: 8,
                    maxLines: null,
                    decoration: kInputTextFieldDecoration.copyWith(
                        labelText: 'Course Summary'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Course Summary is required';
                      }

                      return null;
                    },
                    onSaved: (value) {
                      _courseModel.overview = value;
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
            ]),
          ),
        ),
      ),
      actions: [
        cancelButton,
        createButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
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
            : 800,
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Responsive.isMobile(context)
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Card(
                                color: CustomColors.firebaseGrey,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20.0, horizontal: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Today",
                                        style: TextStyle(
                                            fontFamily: 'Red Hat Display',
                                            fontSize: 20,
                                            color:
                                                CustomColors.googleBackground,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Spacer(),
                                      Text(
                                        getStrToday(),
                                        style: TextStyle(
                                            fontFamily: 'Red Hat Display',
                                            fontSize: 18,
                                            color:
                                                CustomColors.googleBackground,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              )),
                        )
                      : Container(),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text(
                      "Welcome! \n$_userName",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        bottom: 10.0, left: 18.0, right: 18.0),
                    child: Text(
                      "SEMESTER OVERVIEW",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                  child: LayoutBuilder(
                      builder: (context, constraints) => SizedBox(
                            width: constraints.maxWidth > 850
                                ? 800
                                : constraints.maxWidth,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    text:
                                        "Hello my love, Sunt architecto voluptatum esse tempora sint nihil minus incidunt nisi. Perspiciatis natus quo unde magnam numquam pariatur amet ut. Perspiciatis ab totam. Ut labore maxime provident. Voluptate ea omnis et ipsum asperiores laborum repellat explicabo fuga. Dolore voluptatem praesentium quis eos laborum dolores cupiditate nemo labore.",
                                    style: TextStyle(
                                      height: 1.5,
                                      color: Color(0xFF4D5875),
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                )),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Row(
                      children: [
                        Text(
                          "COURSES",
                          style: TextStyle(fontSize: 12),
                        ),
                        Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CourseScreen()),
                            );
                          },
                          child: Row(
                            children: [
                              Text(
                                "Browse courses",
                              ),
                              Icon(Icons.arrow_forward_ios, size: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 245,
                      child: StreamBuilder(
                        stream: _courses,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data['courseNames'] != null) {
                              if (snapshot.data['courseNames'].length != 0) {
                                return ListView.builder(
                                    itemCount:
                                        snapshot.data['courseNames'].length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      int reqIndex =
                                          snapshot.data['courseNames'].length -
                                              index -
                                              1;
                                      return Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ListTile(
                                              leading: CircleAvatar(
                                                radius: 30.0,
                                                backgroundColor:
                                                    Colors.blueAccent,
                                                child: Text(
                                                    destructureName(snapshot
                                                                    .data[
                                                                'courseNames']
                                                            [reqIndex])
                                                        .substring(0, 1)
                                                        .toUpperCase(),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                              ),
                                              title: Text(
                                                destructureName(
                                                    snapshot.data['courseNames']
                                                        [reqIndex]),
                                              ),
                                              onTap: () {
                                                Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          MainScreen(
                                                        courseName: snapshot
                                                                    .data[
                                                                'courseNames']
                                                            [reqIndex],
                                                        courseId: snapshot.data[
                                                                'courseIds']
                                                            [reqIndex],
                                                        overview: snapshot.data[
                                                                'overview']
                                                            [reqIndex],
                                                      ),
                                                    ),
                                                    (Route<dynamic> route) =>
                                                        false);
                                              }),
                                        ),
                                      );
                                    });
                              } else {
                                return Container(
                                  child: Text(
                                      "You've not joined any course, tap on the 'browse course' to view available courses."),
                                );
                              }
                            } else {
                              return Container(
                                child: Text(
                                    "You've not joined any course, tap on the 'browse course' to view available courses."),
                              );
                            }
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),

      // Container(
      //   padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
      //   color: Colors.white,
      //   child: ListView(
      //     children: [
      //       SizedBox(height: kDefaultPadding),
      //       Divider(thickness: 1),
      //       Expanded(
      //         child: SingleChildScrollView(
      //           padding: EdgeInsets.all(kDefaultPadding),
      //           child: Expanded(
      //             child: Column(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 Row(
      //                   children: [
      //                     Expanded(
      //                       child: Column(
      //                         crossAxisAlignment: CrossAxisAlignment.start,
      //                         children: [
      //                           Text(
      //                             "Welcome! $_userName",
      //                             style: Theme.of(context).textTheme.headline6,
      //                           ),
      //                           SizedBox(height: 40),
      //                           Text(
      //                             "SEMESTER OVERVIEW",
      //                             style: Theme.of(context).textTheme.headline6,
      //                           ),
      //                         ],
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //                 SizedBox(height: 10),
      //                 LayoutBuilder(
      //                   builder: (context, constraints) => SizedBox(
      //                     width: constraints.maxWidth > 850
      //                         ? 800
      //                         : constraints.maxWidth,
      //                     child: Column(
      //                       crossAxisAlignment: CrossAxisAlignment.start,
      //                       children: [
      //                         Text.rich(
      //                           TextSpan(
      //                             text:
      //                                 "Hello my love, Sunt architecto voluptatum esse tempora sint nihil minus incidunt nisi. Perspiciatis natus quo unde magnam numquam pariatur amet ut. Perspiciatis ab totam. Ut labore maxime provident. Voluptate ea omnis et ipsum asperiores laborum repellat explicabo fuga. Dolore voluptatem praesentium quis eos laborum dolores cupiditate nemo labore.",
      //                             style: TextStyle(
      //                               height: 1.5,
      //                               color: Color(0xFF4D5875),
      //                               fontWeight: FontWeight.w300,
      //                             ),
      //                           ),
      //                         ),
      //                         SizedBox(height: kDefaultPadding),
      //                         Row(
      //                           children: [
      //                             Text(
      //                               "COURSES",
      //                               style: TextStyle(fontSize: 12),
      //                             ),
      //                             Spacer(),
      //                             TextButton(
      //                               onPressed: () {
      //                                 Navigator.push(
      //                                   context,
      //                                   MaterialPageRoute(
      //                                       builder: (context) =>
      //                                           CourseScreen()),
      //                                 );
      //                               },
      //                               child: Text(
      //                                 "View All",
      //                               ),
      //                             ),
      //                           ],
      //                         ),
      //                       ],
      //                     ),
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ),
      //       ),
      //       Divider(thickness: 1),
      //       //SizedBox(height: 5),
      //       groupsList(),
      //     ],
      //   ),
      // ),

      floatingActionButton: dataReceived == false
          ? Container()
          : userRole == 'Tutor'
              ? FloatingActionButton.extended(
                  onPressed: () {
                    _popupDialog(context);
                  },
                  label: Text("Create Course"),
                  icon: Icon(Icons.add, color: Colors.white, size: 30.0),
                  backgroundColor: Colors.grey[700],
                  elevation: 0.0,
                )
              : Container(),
    );
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
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PreviewScreen(
                                      courseName: snapshot.data['courseNames']
                                          [reqIndex],
                                      courseId: snapshot.data['courseIds']
                                          [reqIndex],
                                      overview: snapshot.data['overview']
                                          [reqIndex],
                                    ),
                                  ));
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

  adminMenu() {
    showModalBottomSheet(
        enableDrag: false,
        isDismissible: false,
        context: (context),
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        builder: (context) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: AdminBottomSheetWidget(
                container: Form(
                  key: _formKey,
                  child: Container(
                    height: 250,
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        SizedBox(height: 10),
                        Container(
                          child: TextFormField(
                            //initialValue: _courseModel.courseName,
                            controller: courseNameController,
                            keyboardType: TextInputType.multiline,
                            decoration: kInputTextFieldDecoration.copyWith(
                                labelText: 'Course Name'),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Course name is required';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _courseModel.courseName = value;
                            },
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Container(
                            child: TextFormField(
                          // initialValue: _courseModel.overview,
                          controller: courseOverviewController,
                          minLines: 5,
                          maxLines: null,
                          decoration: kInputTextFieldDecoration.copyWith(
                              labelText: 'Course Summary'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Course Summary is required';
                            }

                            return null;
                          },
                          onSaved: (value) {
                            _courseModel.overview = value;
                          },
                        )),
                      ]),
                    ),
                  ),
                ),
                onTapConfirm: () {
                  if (!_formKey.currentState.validate()) {
                    return;
                  }
                  _formKey.currentState.save();

                  Database(uid: user.uid)
                      .createCourse(_courseModel, _userName, _courseCreated);
                  Navigator.of(context).pop();
                },
                onTapClose: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          );
        });
  }

  _getUserAuthAndJoinedGroups() async {
    Database(uid: user.uid).getUserCourses().then((snapshots) {
      setState(() {
        _courses = snapshots;
      });
    });
  }

  _saveCourse() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    Database(uid: user.uid)
        .createCourse(_courseModel, _userName, _courseCreated);
  }

  _courseCreated(CourseModel courses) {
    ProviderNotifier modelNotifier =
        Provider.of<ProviderNotifier>(context, listen: false);
    modelNotifier.addAllCourses(courses);
    courseNameController.clear();
    courseOverviewController.clear();
  }
}
