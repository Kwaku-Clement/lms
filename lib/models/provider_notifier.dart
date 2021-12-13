import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:lms/models/course_model.dart';
import 'package:lms/models/create_quiz_model.dart';
import 'package:lms/models/models.dart';
import 'package:lms/models/quiz_model.dart';

class ProviderNotifier with ChangeNotifier {
  List<Model> _courseList = [];
  Model _currentModel;

  UnmodifiableListView<Model> get courseList =>
      UnmodifiableListView(_courseList);

  Model get currentModel => _currentModel;

  set modelList(List<Model> courseList) {
    _courseList = courseList;
    notifyListeners();
  }

  set currentModel(Model course) {
    _currentModel = course;
    notifyListeners();
  }

  addCourse(Model course) {
    _courseList.insert(0, course);
    notifyListeners();
  }

  deleteCourse(Model course) {
    _courseList.removeWhere((_course) => _course.id == course.id);
    notifyListeners();
  }

  //Quiz provider notifier
  List<QuizModel> _quizList = [];
  QuizModel _currentQuiz;

  UnmodifiableListView<QuizModel> get quizList =>
      UnmodifiableListView(_quizList);

  QuizModel get currentQuiz => _currentQuiz;

  set quizList(List<QuizModel> quizList) {
    _quizList = quizList;
    notifyListeners();
  }

  set currentQuiz(QuizModel quiz) {
    _currentQuiz = quiz;
    notifyListeners();
  }

  addQuiz(QuizModel quiz) {
    _quizList.insert(0, quiz);
    notifyListeners();
  }

  deleteQuiz(QuizModel quiz) {
    _quizList.removeWhere((_quiz) => _quiz.id == quiz.id);
    notifyListeners();
  }

  //Create Quiz provider notifier
  List<CreateQuiz> _createQuizList = [];
  CreateQuiz _currentCreateQuiz;

  UnmodifiableListView<CreateQuiz> get createQuizList =>
      UnmodifiableListView(_createQuizList);

  CreateQuiz get currentCreateQuiz => _currentCreateQuiz;

  set createQuizList(List<CreateQuiz> createQuizList) {
    _createQuizList = createQuizList;
    notifyListeners();
  }

  set currentCreateQuiz(CreateQuiz createQuiz) {
    _currentCreateQuiz = createQuiz;
    notifyListeners();
  }

  addCreateQuiz(CreateQuiz createQuiz) {
    _createQuizList.insert(0, createQuiz);
    notifyListeners();
  }

  deleteCreateQuiz(CreateQuiz quiz) {
    _createQuizList.removeWhere((_quiz) => _quiz.quizId == quiz.quizId);
    notifyListeners();
  }

  //Courses provider notifier
  List<CourseModel> _allCoursesList = [];
  CourseModel _currentAllCourses;

  UnmodifiableListView<CourseModel> get allCourses =>
      UnmodifiableListView(_allCoursesList);

  CourseModel get currentCourse => _currentAllCourses;

  set allCourseList(List<CourseModel> assignmentList) {
    _allCoursesList = assignmentList;
    notifyListeners();
  }

  set currentAllCourses(CourseModel courses) {
    _currentAllCourses = courses;
    notifyListeners();
  }

  addAllCourses(CourseModel courses) {
    _allCoursesList.insert(0, courses);
    notifyListeners();
  }

  deleteAllCourses(CourseModel courses) {
    _allCoursesList
        .removeWhere((_courses) => _courses.courseId == courses.courseId);
    notifyListeners();
  }
}
