import 'package:flutter/material.dart';
import 'package:lms/authentication/Screens/login_screen.dart';
import 'package:lms/authentication/auth.dart';

import 'drawer_menu_widget.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback openDrawer;

  CustomAppBar({
    Key key,
    @required this.openDrawer,
  }) : super(key: key);
  final Auth _auth = Auth();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        DrawerMenuWidget(
          onClicked: openDrawer,
        ),
        Spacer(),
        TextButton(
          onPressed: () async {
            await _auth.signOut();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => SignIn(),
                ),
                (Route<dynamic> route) => false);
          },
          child: Text('Logout', style: TextStyle(fontSize: 18)),
        ),
      ]),
      // actions: [
      //   PopupMenuButton(
      //     icon: Icon(
      //       Icons.more_vert,
      //       color: Colors.black,
      //       size: 34,
      //     ),
      //     itemBuilder: (context) => [
      //       PopupMenuItem<int>(
      //         value: 0,
      //         child: TextButton.icon(
      //           onPressed: () async {
      //             await _auth.signOut();
      //             Navigator.pushAndRemoveUntil(
      //                 context,
      //                 MaterialPageRoute(
      //                   builder: (context) => SignIn(),
      //                 ),
      //                 (Route<dynamic> route) => false);
      //           },
      //           icon: Icon(Icons.logout),
      //           label: Text('Logout'),
      //         ),
      //       ),
      //     ],
      //   )
      // ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
