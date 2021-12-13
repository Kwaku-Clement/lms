import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lms/widget/responsive.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:lms/constants/colors.dart';
import 'package:lms/models/models.dart';
import 'package:lms/models/provider_notifier.dart';
import 'package:lms/nav/custom_appbar.dart';
import 'package:lms/service/database.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class Schedule extends StatefulWidget {
  final String courseName;
  final String courseId;
  final String username;
  final VoidCallback openDrawer;

  const Schedule(
      {Key key,
      @required this.courseId,
      this.courseName,
      this.openDrawer,
      this.username})
      : super(key: key);

  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  bool dataReceived = false;
  bool isAudioMuted = true;
  bool isVideoMuted = true;
  String username = '';
  final dateFormat = DateFormat('MM-dd-yyyy');

  @override
  void initState() {
    getUserData();
    // _getUserAuthAndJoinedGroups();

    ProviderNotifier notifier =
        Provider.of<ProviderNotifier>(context, listen: false);
    Database().getSchedule(courseNotifier: notifier, courseId: widget.courseId);
    super.initState();
  }

  getUserData() async {
    DocumentSnapshot userdoc =
        await userCollection.doc(FirebaseAuth.instance.currentUser.uid).get();
    setState(() {
      username = userdoc.get('username');
      dataReceived = true;
    });
  }

  joinMeeting(String roomName) async {
    try {
      Map<FeatureFlagEnum, bool> featureflags = {
        FeatureFlagEnum.WELCOME_PAGE_ENABLED: false
      };
      if (Platform.isAndroid) {
        featureflags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
      } else if (Platform.isIOS) {
        featureflags[FeatureFlagEnum.PIP_ENABLED] = false;
      }

      var options = JitsiMeetingOptions(room: roomName)
        ..userDisplayName = username == '' ? username : username
        ..audioMuted = isAudioMuted
        ..videoMuted = isVideoMuted
        ..featureFlags.addAll(featureflags)
        ..webOptions = {
          'RoomName': roomName,
          'width': '100%',
          'height': '100%',
          'enableWelcomePage': false,
          'chromeExtensionBanner': null,
          'userInfo': {'displayName': username}
        };

      await JitsiMeet.joinMeeting(options);
    } catch (e) {
//print('Error: $e');
      Text('Enter meeting ID');
    }
  }

  @override
  void dispose() {
    JitsiMeet.closeMeeting();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ProviderNotifier notifier = Provider.of<ProviderNotifier>(context);

    Future<void> _refreshList() async {
      Database()
          .getSchedule(courseNotifier: notifier, courseId: widget.courseId);
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
          child: StreamBuilder<QuerySnapshot>(
            stream: Database().getSchedules(courseId: widget.courseId),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());
              if (snapshot.hasError)
                return Center(child: Text('Unkown error occurred'));

              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildList(context, snapshot.data.docs),
                  // DataTable(
                  //   sortColumnIndex: 0,
                  //   dataRowHeight: 80,
                  //   dataTextStyle: TextStyle(
                  //       fontSize: 18.0,
                  //       fontWeight: FontWeight.w700,
                  //       color: Colors.black),
                  //   columns: getColumns(columns),
                  //   rows:
                  //   getRows(context, snapshot.data),
                  // ),
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    final columns = [
      '',
      'Description',
      'Date and Time',
      'Join meeting',
    ];
    return ListView(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: ClampingScrollPhysics(),
          child: DataTable(
            columns: getColumns(columns),
            rows:
                //getRows(context, snapshot),
                snapshot
                    .map<DataRow>((data) => _buildListItem(context, data))
                    .toList(),
          ),
        ),
      ],
    );
  }

  _buildListItem(BuildContext context, DocumentSnapshot snapshot) {
    final schedule = Model.fromSnapshot(doc: snapshot);
    if (schedule == null) {
      return Container();
    }

    return DataRow(cells: [
      DataCell(
        Icon(Icons.video_camera_back, size: 54, color: Colors.yellow),
      ),
      DataCell(
        Text(schedule.title == null ? "title" : schedule.title),
      ),
      DataCell(
        Text(schedule.date + ", \n" + schedule.time),
      ),
      DataCell(
        ElevatedButton(
            onPressed: () => joinMeeting(schedule.details),
            child: Text('Join')),
        //onTap: () =>joinMeeting(schedule.details),
      ),
    ]);
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
            label: Text(column),
          ))
      .toList();

  List<DataRow> getRows(BuildContext context, List<DocumentSnapshot> snapshot) {
    List<DataRow> newList = snapshot.map<DataRow>((document) {
      final schedule = Model.fromMap(document.data());
      if (schedule == null) {
        return null;
      }
      return DataRow(cells: [
        DataCell(
          Icon(Icons.video_camera_back, color: Colors.yellowAccent),
        ),
        DataCell(
          Text(schedule.title == null ? "title" : schedule.title),
        ),
        DataCell(
          Text(schedule.date + ", \n" + schedule.time),
        ),
        DataCell(
          ElevatedButton(
            onPressed: () => joinMeeting(schedule.details),
            child: Text('Join'),
          ),
        ),
      ]);
    }).toList();
    return newList;
  }
}
