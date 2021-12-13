import 'package:cloud_firestore/cloud_firestore.dart';

class CourseModel {
  String courseId;
  String courseName;
  String overview;
  String tutor;
  List<String> students;
  List<String> indexList;
  List<String> tokens;
  DateTime createdAt;
  DocumentReference reference;

  CourseModel({
    this.courseId,
    this.courseName,
    this.overview,
    this.tutor,
    this.students,
    this.indexList,
    this.tokens,
    this.createdAt,
    this.reference,
  });

  factory CourseModel.fromSnapshot({DocumentSnapshot snapshot}) {
    CourseModel newQuestion = CourseModel.fromJson(snapshot.data());
    newQuestion.reference = snapshot.reference;
    return newQuestion;
  }

  factory CourseModel.fromJson(Map<String, dynamic> json) =>
      _questionFromJson(json);

  Map<String, dynamic> toJson() => _questionToJson(this);

  @override
  String toString() => "Question<$courseName>";
}

CourseModel _questionFromJson(Map<String, dynamic> json) {
  return CourseModel(
    courseName: json['courseName'] as String,
    courseId: json['courseId'] as String,
    overview: json['overview'] as String,
    tutor: json['tutor'] as String,
    students: json['students'] as List,
    indexList: json['indexList'] as List,
    tokens: json['tokens'] as List,
    createdAt: json['createdAt'] == null
        ? null
        : (json['createdAt'] as Timestamp).toDate(),
  );
}

Map<String, dynamic> _questionToJson(CourseModel instance) => <String, dynamic>{
      'tutor': instance.tutor,
      'courseName': instance.courseName,
      'overview': instance.overview,
      'createdAt': instance.createdAt,
      'courseId': instance.courseId,
      'tokens': instance.tokens,
      'students': instance.students,
      'indexList': instance.indexList,
    };
