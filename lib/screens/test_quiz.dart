import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lms/quiz/services/database.dart';
import 'package:lms/widget/responsive.dart';
import 'package:flutter/material.dart';
import 'package:lms/constants/colors.dart';
import 'package:lms/models/create_quiz_model.dart';
import 'package:lms/nav/custom_appbar.dart';
import 'package:lms/quiz/views/quiz_play.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class TestQuiz extends StatefulWidget {
  final String courseName;
  final String courseId;
  final String username;
  final VoidCallback openDrawer;

  const TestQuiz(
      {Key key,
      @required this.courseId,
      this.courseName,
      this.openDrawer,
      this.username})
      : super(key: key);

  @override
  _TestQuizState createState() => _TestQuizState();
}

class _TestQuizState extends State<TestQuiz> {
  Stream quizStream;
  DatabaseService databaseService = new DatabaseService();

  @override
  void initState() {
    databaseService.getQuizData(courseId: widget.courseId).then((value) {
      quizStream = value;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            stream: FirebaseFirestore.instance
                .collection(widget.courseId)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());
              if (snapshot.hasError)
                return Center(child: Text('Unkown error occurred'));

              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildList(context, snapshot.data.docs),
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
      'TITLE',
      'DESCRIPTION',
      '',
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
    final quiz = CreateQuiz.fromSnapshot(doc: snapshot);
    if (quiz == null) {
      return Container();
    }

    return DataRow(cells: [
      DataCell(Text(quiz.title)),
      DataCell(Text(quiz.status)),
      DataCell(Text('Start Quiz'), onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    QuizPlay(quizId: quiz.quizId, courseId: widget.courseId)));
      }),
    ]);
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
            label: Text(column),
          ))
      .toList();
}
