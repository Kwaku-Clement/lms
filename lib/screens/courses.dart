import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lms/widget/responsive.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lms/constants/colors.dart';
import 'package:lms/constants/constants.dart';
import 'package:lms/models/course_model.dart';
import 'package:lms/nav/custom_appbar.dart';
import 'package:lms/pages/group_tile.dart';
import 'package:lms/service/database.dart';

class Courses extends StatefulWidget {
  final VoidCallback openDrawer;
  final String courseId;
  final String courseName;
  final String username;
  final String overview;
  const Courses(
      {Key key,
      this.openDrawer,
      this.courseId,
      this.courseName,
      this.username,
      this.overview})
      : super(key: key);
  @override
  _CoursesState createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  String _userName = '';
  Stream _courses;
  String search;
  TextEditingController searchController = TextEditingController();

  // initState()
  @override
  void initState() {
    super.initState();
    getUserData();
  }

  // functions
  getUserData() async {
    DocumentSnapshot userdoc =
        await userCollection.doc(FirebaseAuth.instance.currentUser.uid).get();
    setState(() {
      _userName = userdoc.get('username');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          openDrawer: widget.openDrawer,
        ),
        body: courseList(),

        // Container(
        //   child: Column(
        //     children: [
        //       Padding(
        //         padding: const EdgeInsets.all(15.0),
        //         child: Container(
        //             child: TextFormField(
        //           onTap: () {
        //             showSearch(context: context, delegate: SearchCourse());
        //           },
        //           onChanged: (value) {
        //             setState(() {
        //               search = value.toLowerCase();
        //             });
        //           },
        //           controller: searchController,
        //           decoration: InputDecoration(
        //               suffixIcon: IconButton(
        //                 icon: Icon(Icons.clear),
        //                 onPressed: () => searchController.clear(),
        //               ),
        //               hintText: '"Search course..."'),
        //         )),
        //       ),
        //       // Expanded(
        //       //     child: StreamBuilder<QuerySnapshot>(
        //       //   stream: (search == null || search.trim() == "")
        //       //       ? FirebaseFirestore.instance.collection('courses').snapshots()
        //       //       : FirebaseFirestore.instance
        //       //           .collection('courses')
        //       //           .where('searchIndex', arrayContains: search)
        //       //           .snapshots(),
        //       //   builder: (context, snapshot) {
        //       //     if (snapshot.hasError) {
        //       //       return Text('oops! error occured ${snapshot.error}');
        //       //     }
        //       //     switch (snapshot.connectionState) {
        //       //       case ConnectionState.waiting:
        //       //         return Center(child: CircularProgressIndicator());
        //       //       case ConnectionState.none:
        //       //         return Text('No course was found');
        //       //       default:
        //       //         return ListView(
        //       //           children: snapshot.data.docs.map((DocumentSnapshot doc) {
        //       //             return ListTile(
        //       //               title: Text(doc['courses']),
        //       //             );
        //       //           }).toList(),
        //       //         );
        //       //     }
        //       //   },
        //       // ))

        //       Expanded(
        //         child: Container(
        //           padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
        //           color: Colors.white,
        //           child: Column(
        //             children: [
        //               Expanded(
        //                 child: SingleChildScrollView(
        //                   padding: EdgeInsets.all(kDefaultPadding),
        //                   child: Expanded(
        //                     child: Column(
        //                       crossAxisAlignment: CrossAxisAlignment.start,
        //                       children: [
        //                         SizedBox(height: 10),
        //                         LayoutBuilder(
        //                           builder: (context, constraints) => SizedBox(
        //                             width: constraints.maxWidth > 850
        //                                 ? 800
        //                                 : constraints.maxWidth,
        //                             child: courseList(),
        //                           ),
        //                         ),
        //                       ],
        //                     ),
        //                   ),
        //                 ),
        //               )
        //             ],
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // )
      ),
    );
  }

  Widget courseList() {
    return Container(
      padding: EdgeInsets.only(
        top: kIsWeb ? kDefaultPadding : 0,
        left: kIsWeb ? 30 : 0,
      ),
      width: Responsive.isMobile(context)
          ? MediaQuery.of(context).size.width
          : 900,
      child: StreamBuilder(
        stream: Database().getCourses(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              if (snapshot.data.docs.length != 0) {
                return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      int reqIndex = snapshot.data.docs.length - index - 1;
                      return GroupTile(
                          userName: snapshot.data.docs[reqIndex].get('tutor'),
                          courseId:
                              snapshot.data.docs[reqIndex].get('courseId'),
                          courseName: destructureName(
                              snapshot.data.docs[reqIndex].get('courseName') ==
                                      null
                                  ? Container()
                                  : destructureName(snapshot.data.docs[reqIndex]
                                      .get('courseName'))),
                          overview: destructureName(
                            snapshot.data.docs[reqIndex].get('overview') == null
                                ? Container()
                                : destructureName(snapshot.data.docs[reqIndex]
                                    .get('overview')),
                          ));
                    });
              } else {
                return Container();
              }
            } else {
              return Container();
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class SearchCourse extends SearchDelegate<CourseModel> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(Icons.navigate_before),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text(query),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
        child: StreamBuilder<QuerySnapshot>(
      stream: (query == null || query.trim() == "")
          ? FirebaseFirestore.instance.collection('courses').snapshots()
          : FirebaseFirestore.instance
              .collection('courses')
              .where('searchIndex', arrayContains: query)
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('oops! error occured ${snapshot.error}');
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.none:
            return Text('No course was found');
          default:
            return ListView(
              children: snapshot.data.docs.map((DocumentSnapshot doc) {
                return ListTile(
                  title: Text(doc['courses']),
                  onTap: () {
                    showResults(context);
                  },
                );
              }).toList(),
            );
        }
      },
    ));
  }
}
