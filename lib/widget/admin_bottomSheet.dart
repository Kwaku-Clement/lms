import 'package:flutter/material.dart';
import 'package:lms/constants/constants.dart';

class AdminBottomSheetWidget extends StatelessWidget {
  final Widget container;
  final VoidCallback onTapConfirm;
  final VoidCallback onTapClose;

  const AdminBottomSheetWidget(
      {Key key, this.onTapConfirm, this.onTapClose, this.container});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            container,
            buildButtons(),
            SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }

  Widget buildButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Container(
            width: 200,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 5,
                  shape: StadiumBorder(),
                  shadowColor: Colors.blueAccent),
              onPressed: onTapConfirm,
              child: Text(
                'Create Course',
                style: kSendButtonTextStyle.copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
        SizedBox(height: 10.0),
        TextButton(
          onPressed: onTapClose,
          child: Text('CANCEL', style: TextStyle(color: Colors.orangeAccent)),
        ),
      ],
    );
  }
}
