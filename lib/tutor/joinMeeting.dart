//import 'dart:io';

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:lms/constants/colors.dart';
import 'package:lms/service/database.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class JoinMeeting extends StatefulWidget {
  static const String id = 'join_meeting';
  final String serverUrl;

  const JoinMeeting({Key key, this.serverUrl}) : super(key: key);
  @override
  _JoinMeetingState createState() => _JoinMeetingState();
}

class _JoinMeetingState extends State<JoinMeeting>
    with AutomaticKeepAliveClientMixin {
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController roomController = TextEditingController();
  bool isAudioMuted = true;
  bool isVideoMuted = true;
  String username = '';
  String roomName = '12345678';

  @override
  void initState() {
    super.initState();
    getUserdata();
    joinMeeting();
  }

  getUserdata() async {
    DocumentSnapshot snapshot =
        await userCollection.doc(FirebaseAuth.instance.currentUser.uid).get();
    setState(() {
      username = snapshot.get('username');
    });
  }

  joinMeeting() async {
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
        ..serverURL = widget.serverUrl
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
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: getBody(),
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Container(
              height: 40,
              decoration: BoxDecoration(color: Colors.grey.withOpacity(0.03)),
              child: Row(
                children: [
                  Container(
                    width: size.width * 0.3,
                    height: 40,
                  ),
                  Text(
                    'Meeting ID',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Container(
              width: size.width,
              margin: EdgeInsets.only(left: 15, right: 15),
              child: Padding(
                padding: EdgeInsets.only(top: 3),
                child: PinCodeTextField(
                    controller: roomController,
                    appContext: context,
                    length: 8,
                    autoDisposeControllers: false,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(shape: PinCodeFieldShape.underline),
                    animationDuration: Duration(milliseconds: 300),
                    onChanged: (value) {}),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Text(
                "If you recieved an invitation link, tab on the link again to join the meeting",
                style: TextStyle(color: Colors.black87, height: 1.3),
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 40,
              width: size.width * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.zero,
                color: grey,
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Center(
                  child: Text(
                    username,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => joinMeeting()),
                );
              },
              child: Container(
                  width: size.width * 0.9,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                        colors: GradientColors.facebookMessenger),
                  ),
                  child: Center(
                      child: Text(
                    'Join',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ))),
            ),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.only(left: 15, right: 20),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'JOIN OPTIONS',
                    style: TextStyle(color: Colors.black, height: 1.3),
                  )),
            ),
            SizedBox(height: 10),
            Container(
              height: 50,
              decoration: BoxDecoration(color: grey.withOpacity(0.03)),
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Mute Audio',
                      style: TextStyle(
                          color: Colors.black,
                          height: 1.3,
                          fontSize: 15,
                          fontWeight: FontWeight.w700),
                    ),
                    Switch(
                      activeColor: primary,
                      value: isAudioMuted,
                      onChanged: (value) {
                        setState(() {
                          isAudioMuted = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 50,
              decoration: BoxDecoration(color: grey.withOpacity(0.03)),
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Mute Video',
                      style: TextStyle(
                          color: Colors.black,
                          height: 1.3,
                          fontSize: 15,
                          fontWeight: FontWeight.w700),
                    ),
                    Switch(
                      activeColor: primary,
                      value: isVideoMuted,
                      onChanged: (value) {
                        setState(() {
                          isVideoMuted = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
