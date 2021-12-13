import 'package:flutter/material.dart';
import 'package:lms/constants/custom_colors.dart';
import 'package:lms/service/database.dart';
import 'package:lms/widget/main_screen.dart';

import 'drawer_items.dart';
import 'drawer_model.dart';

class DrawerWidget extends StatefulWidget {
  final ValueChanged<DrawerItem> onSelectedItem;

  DrawerWidget({
    Key key,
    @required this.onSelectedItem,
  }) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final Color colors = CustomColors.firebaseGrey;
  Stream _courses;

  @override
  void initState() {
    super.initState();
    _getUserAuthAndJoinedGroups();
  }

  _getUserAuthAndJoinedGroups() async {
    await Database(uid: user.uid).getUserCourses().then((snapshots) {
      setState(() {
        _courses = snapshots;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.googleBackground,
      body: Container(
        padding: EdgeInsets.fromLTRB(10, 32, 10, 0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                child: Container(
                  child: ExpansionTile(
                    title: Text('Courses'),
                    children: [
                      Container(
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
                                        int reqIndex = snapshot
                                                .data['courseNames'].length -
                                            index -
                                            1;
                                        return Card(
                                          child: ListTile(
                                              title: Text(
                                                snapshot.data['courseNames']
                                                    [reqIndex],
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
                                                              courseId: snapshot
                                                                          .data[
                                                                      'courseIds']
                                                                  [reqIndex],
                                                              overview: snapshot
                                                                          .data[
                                                                      'overview']
                                                                  [reqIndex],
                                                            )),
                                                    (Route<dynamic> route) =>
                                                        false);
                                              }),
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
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Column(
                children: DrawerItems.all
                    .map(
                      (item) => ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        leading: Icon(
                          item.icon,
                          color: colors,
                        ),
                        title: Text(item.title,
                            style: TextStyle(
                              color: colors,
                              fontSize: 18,
                            )),
                        onTap: () => widget.onSelectedItem(item),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
