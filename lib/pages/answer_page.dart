import 'package:flutter/material.dart';
import 'package:lms/constants/colors.dart';
import 'package:lms/constants/constants.dart';

class AnswerPage extends StatefulWidget {
  @override
  _AnswerPageState createState() => _AnswerPageState();
}

class _AnswerPageState extends State<AnswerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                child: Column(
                  children: [
                    Text('Title'),
                    Text('Number of submission'),
                    Text('Due date'),
                    Text('Grade Score'),
                  ],
                ),
              ),
              SizedBox(
                height: kDefaultPadding,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('INSTRUCTIONS'),
              ),
              SizedBox(
                height: kDefaultPadding,
              ),
              Divider(thickness: 1),
              Card(
                child: Text.rich(
                  TextSpan(
                    text:
                        "Hello my love, Sunt architecto voluptatum esse tempora sint nihil minus incidunt nisi. Perspiciatis natus quo unde magnam numquam pariatur amet ut. Perspiciatis ab totam. Ut labore maxime provident. Voluptate ea omnis et ipsum asperiores laborum repellat explicabo fuga. Dolore voluptatem praesentium quis eos laborum dolores cupiditate nemo labore. \n \nLove you, \n\nElvia",
                    style: TextStyle(
                      height: 1.5,
                      color: Color(0xFF4D5875),
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
              Divider(thickness: 1),
              SizedBox(
                height: kDefaultPadding,
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Card(
                  child: TextFormField(
                    minLines: 10,
                    maxLines: null,
                    decoration: kInputTextFieldDecoration.copyWith(
                        hintText: 'Please, add your answer here'),
                  ),
                ),
              ),
              Divider(thickness: 1),
              Card(
                child: Row(
                  children: [
                    TextButton(onPressed: () {}, child: Text('Choose file')),
                    Text('No file chosen'),
                    ElevatedButton(onPressed: () {}, child: Text('Submit'))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
