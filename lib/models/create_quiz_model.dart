import 'package:cloud_firestore/cloud_firestore.dart';

class CreateQuiz {
  String quizId;
  String dueDate;
  String status;
  String title;
  String openDate;
  DateTime createdAt;
  DocumentReference reference;

  CreateQuiz({
    this.quizId,
    this.status,
    this.dueDate,
    this.title,
    this.openDate,
    this.createdAt,
  });

  CreateQuiz.fromSnapshot({DocumentSnapshot doc}) {
    quizId = doc.get("quizId");
    status = doc.get("status");
    dueDate = doc.get("dueDate");
    openDate = doc.get('openDate');
    title = doc.get("title");
    //createdAt = doc.get('createdAt');
  }
  CreateQuiz.fromMap(Map<String, dynamic> data) {
    quizId = data['quizId'];
    status = data['status'];
    dueDate = data['dueDate'];
    openDate = data['openDate'];
    title = data['title'];
    //createdAt = data['createdAt'];
  }

  Map<String, dynamic> toMap() {
    return {
      'quizId': quizId,
      'status': status,
      'title': title,
      'dueDate': dueDate,
      'openDate': openDate,
      //'createdAt': createdAt,
    };
  }
}
