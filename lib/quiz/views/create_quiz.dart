import 'package:flutter/material.dart';
import 'package:lms/quiz/services/database.dart';
import 'package:lms/quiz/widget/widget.dart';
import 'package:random_string/random_string.dart';

import 'add_question.dart';

class CreateTest extends StatefulWidget {
  final String courseId;

  const CreateTest({Key key, this.courseId}) : super(key: key);
  @override
  _CreateTestState createState() => _CreateTestState();
}

class _CreateTestState extends State<CreateTest> {
  DatabaseService databaseService = new DatabaseService();
  final _formKey = GlobalKey<FormState>();

  String title, status, quizDesc;

  bool isLoading = false;
  String quizId;

  createQuiz() {
    quizId = randomAlphaNumeric(16);
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      Map<String, String> quizData = {
        "title": title,
        "status": status,
        "quizId": quizId,
      };

      databaseService
          .addQuizData(
              quizData: quizData, quizId: quizId, courseId: widget.courseId)
          .then((value) {
        setState(() {
          isLoading = false;
        });
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AddQuestion(quizId: quizId, courseId: widget.courseId)));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black54,
        ),
        title: AppLogo(),
        brightness: Brightness.light,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        //brightness: Brightness.li,
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              TextFormField(
                validator: (val) => val.isEmpty ? "Enter Quiz Title" : null,
                decoration: InputDecoration(hintText: "Quiz title"),
                onChanged: (val) {
                  title = val;
                },
              ),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                validator: (val) =>
                    val.isEmpty ? "Enter Quiz Description" : null,
                decoration: InputDecoration(hintText: "Quiz Description"),
                onChanged: (val) {
                  status = val;
                },
              ),
              SizedBox(
                height: 5,
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  createQuiz();
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(30)),
                  child: Text(
                    "Create Quiz",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: 60,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
