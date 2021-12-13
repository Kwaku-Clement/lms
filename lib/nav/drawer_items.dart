import 'package:flutter/material.dart';

import 'drawer_model.dart';

class DrawerItems {
  static const home = DrawerItem(icon: Icons.home, title: 'Homepage');
  static const dashboard =
      DrawerItem(icon: Icons.dashboard, title: 'Dashboard');
  static const overview = DrawerItem(icon: Icons.preview, title: 'Overview');
  static const announcement =
      DrawerItem(icon: Icons.announcement, title: 'Announcement');
  static const resources =
      DrawerItem(icon: Icons.folder_open_outlined, title: 'Resources');
  static const assignment =
      DrawerItem(icon: Icons.assignment, title: 'Assignment');
  static const test_quiz =
      DrawerItem(icon: Icons.clean_hands_outlined, title: 'Test & Quiz');
  static const schedule = DrawerItem(icon: Icons.schedule, title: 'Schedule');
  static const gradebook = DrawerItem(icon: Icons.grade, title: 'Gradebook');

  static final List<DrawerItem> all = [
    home,
    dashboard,
    overview,
    announcement,
    resources,
    schedule,
    assignment,
    test_quiz,
    gradebook,
  ];
}
