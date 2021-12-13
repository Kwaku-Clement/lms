import 'package:cloud_firestore/cloud_firestore.dart';

class QuizModel {
  String id;
  String question;
  String option1;
  String option2;
  String option3;
  String option4;
  String correctOption;
  bool answered;
  DocumentReference reference;

  QuizModel({
    this.id,
    this.question,
    this.option1,
    this.option2,
    this.option3,
    this.option4,
    this.correctOption,
    this.answered,
    this.reference,
  });
  QuizModel.fromSnapshot({DocumentSnapshot doc}) {
    id = doc.id;
    question = doc.get("question");
    option1 = doc.get("option1");
    option2 = doc.get("option2");
    option3 = doc.get('option3');
    option4 = doc.get("option4");
    correctOption = doc.get("correctOption");
    answered = doc.get('answered');
  }
  QuizModel.fromJson(Map<String, dynamic> data) {
    id = data['id'];
    question = data['question'];
    option1 = data['option1'];
    option2 = data['option2'];
    option3 = data['option3'];
    option4 = data['option4'];
    correctOption = data['correctOption'];
    answered = data['answered'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'option1': option1,
      'option2': option2,
      'option4': option4,
      'option3': option3,
      'correctOption': correctOption,
      'answered': answered,
    };
  }
}
