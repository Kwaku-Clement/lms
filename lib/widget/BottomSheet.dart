import 'package:flutter/material.dart';
import 'package:lms/constants/constants.dart';

class BottomSheetWidget extends StatelessWidget {
  final Widget container;
  final VoidCallback onTapConfirm;
  final VoidCallback onTapClose;

  const BottomSheetWidget(
      {Key key, this.onTapConfirm, this.onTapClose, this.container});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          container,
          //buildButtons(),
        ],
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
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(shape: StadiumBorder()),
              onPressed: onTapConfirm,
              child: Text(
                'Send',
                style: kSendButtonTextStyle.copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
        TextButton(
          onPressed: onTapClose,
          child: Text('CANCEL', style: TextStyle(color: Colors.orangeAccent)),
        ),
      ],
    );
  }
}
