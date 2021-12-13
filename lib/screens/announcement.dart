import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lms/widget/responsive.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lms/constants/colors.dart';
import 'package:lms/models/provider_notifier.dart';
import 'package:lms/nav/custom_appbar.dart';
import 'package:lms/service/database.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:readmore/readmore.dart';

class Announcement extends StatefulWidget {
  final String courseName;
  final String courseId;
  final String username;
  final VoidCallback openDrawer;

  const Announcement(
      {Key key,
      @required this.courseId,
      this.courseName,
      this.openDrawer,
      this.username})
      : super(key: key);

  @override
  _AnnouncementState createState() => _AnnouncementState();
}

class _AnnouncementState extends State<Announcement> {
  bool dataReceived = false;
  String userRole = '';

  @override
  void initState() {
    getUserData();

    ProviderNotifier notifier =
        Provider.of<ProviderNotifier>(context, listen: false);
    Database()
        .getAnnouncement(courseNotifier: notifier, courseId: widget.courseId);
    super.initState();
  }

  getUserData() async {
    DocumentSnapshot userdoc =
        await userCollection.doc(FirebaseAuth.instance.currentUser.uid).get();
    setState(() {
      userRole = userdoc.get('role');
      dataReceived = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    ProviderNotifier notifier = Provider.of<ProviderNotifier>(context);

    Future<void> _refreshList() async {
      Database()
          .getAnnouncement(courseNotifier: notifier, courseId: widget.courseId);
    }

    return SafeArea(
      child: Scaffold(
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
          child: Column(
            children: [
              Divider(thickness: 1),
              SizedBox(height: kDefaultPadding),
              Container(
                child: RefreshIndicator(
                  child: ListView.builder(
                    itemCount: notifier.courseList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(notifier.courseList[index].title),
                          ),
                          subtitle: ReadMoreText(
                            notifier.courseList[index].details,
                            trimLines: 5,
                            colorClickableText: Colors.lightBlueAccent,
                            trimMode: TrimMode.Line,
                            trimCollapsedText: '...Read More',
                            trimExpandedText: '...Collapse',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      );
                    },
                  ),
                  onRefresh: _refreshList,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
