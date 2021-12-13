import 'package:flutter/material.dart';

class QuizState with ChangeNotifier {
  double _progress = 0;
  //Option _selected;

  final PageController controller = PageController();

  get progress => _progress;
  //get selected => _selected;

  set progress(double newValue) {
    _progress = newValue;
    notifyListeners();
  }

  // set selected(Option newValue) {
  //   _selected = newValue;
  //   notifyListeners();
  // }
  void previousPage() async {
    await controller.previousPage(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  void nextPage() async {
    await controller.nextPage(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }
}
