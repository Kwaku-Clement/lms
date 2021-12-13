import 'package:lms/constants/colors.dart';
import 'package:lms/widget/responsive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';
import 'package:uuid/uuid.dart';

class CreateMeeting extends StatefulWidget {
  static const String id = 'create_meeting';

  @override
  _CreateMeetingState createState() => _CreateMeetingState();
}

class _CreateMeetingState extends State<CreateMeeting>
    with AutomaticKeepAliveClientMixin {
  String code = '';

  createCode() {
    setState(() {
      code = Uuid().v1().substring(0, 8);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SafeArea(
      child: Scaffold(
          body: Center(
        child: Container(
          padding: EdgeInsets.only(
            top: kIsWeb ? kDefaultPadding : 0,
            left: kIsWeb ? 30 : 0,
          ),
          width: Responsive.isMobile(context)
              ? MediaQuery.of(context).size.width
              : 800,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Text('Create meeting ID and share it with your friends',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center),
              ),
              SizedBox(height: 40),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Meeting ID: ',
                    style: TextStyle(fontSize: 30),
                  ),
                  Text(
                    code,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.purple,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              SizedBox(height: 25),
              InkWell(
                onTap: () {
                  createCode();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / 2,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: GradientColors.facebookMessenger),
                  ),
                  child: Center(
                    child: Text(
                      'Creete code',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
