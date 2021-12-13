import 'package:flutter/material.dart';

class TestQuizAnswer extends StatefulWidget {
  @override
  _TestQuizAnswerState createState() => _TestQuizAnswerState();
}

class _TestQuizAnswerState extends State<TestQuizAnswer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: LinearProgressIndicator(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text('Question 1 0f 20'),
                  Spacer(),
                  Text('10 points')
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Question'),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    TextButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.arrow_back_ios),
                        label: Text('Back')),
                    TextButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.arrow_forward_ios),
                        label: Text('Back')),
                    ElevatedButton(onPressed: () {}, child: Text('Save'))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
