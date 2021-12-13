import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  Future<void> addData(userData) async {
    FirebaseFirestore.instance
        .collection("users")
        .add(userData)
        .catchError((e) {});
  }

  getData() async {
    return await FirebaseFirestore.instance.collection("users").snapshots();
  }

  Future<void> addQuizData(
      {Map quizData, String quizId, String courseId}) async {
    await FirebaseFirestore.instance
        .collection(courseId)
        .doc(quizId)
        .set(quizData)
        .catchError((e) {
      print(e);
    });
  }

  Future<void> addQuestionData(
      {quizData, String quizId, String courseId}) async {
    await FirebaseFirestore.instance
        .collection(courseId)
        .doc(quizId)
        .collection("QNA")
        .add(quizData)
        .catchError((e) {
      print(e);
    });
  }

  getQuizData({String courseId}) async {
    return await FirebaseFirestore.instance.collection(courseId).snapshots();
  }

  getQuestionData({String quizId, String courseId}) async {
    return await FirebaseFirestore.instance
        .collection(courseId)
        .doc(quizId)
        .collection("QNA")
        .get();
  }
}
