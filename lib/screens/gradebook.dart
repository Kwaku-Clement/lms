import 'package:lms/widget/responsive.dart';
import 'package:flutter/material.dart';
import 'package:lms/constants/colors.dart';
import 'package:lms/models/provider_notifier.dart';
import 'package:lms/nav/custom_appbar.dart';
import 'package:lms/service/database.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class GradeBook extends StatefulWidget {
  final String courseName;
  final String courseId;
  final VoidCallback openDrawer;

  const GradeBook(
      {Key key, @required this.courseId, this.courseName, this.openDrawer})
      : super(key: key);

  @override
  _GradeBookState createState() => _GradeBookState();
}

class _GradeBookState extends State<GradeBook> {
  @override
  void initState() {
    ProviderNotifier notifier =
        Provider.of<ProviderNotifier>(context, listen: false);
    Database().getSchedule(courseNotifier: notifier, courseId: widget.courseId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ProviderNotifier notifier = Provider.of<ProviderNotifier>(context);

    Future<void> _refreshList() async {
      Database()
          .getSchedule(courseNotifier: notifier, courseId: widget.courseId);
    }

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
          child: Column(
            children: [
              // Padding(
              //   padding:
              //       const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              //   child: Row(
              //     children: [
              //       // Once user click the menu icon the menu shows like drawer
              //       // Also we want to hide this menu icon on desktop
              //       if (!Responsive.isDesktop(context))
              //         IconButton(
              //           icon: Icon(Icons.menu),
              //           onPressed: () {
              //             _scaffoldKey.currentState.openDrawer();
              //           },
              //         ),
              //       if (!Responsive.isDesktop(context)) SizedBox(width: 5),
              //       Expanded(
              //         child: TextField(
              //           onChanged: (value) {},
              //           decoration: InputDecoration(
              //             hintText: "Search",
              //             fillColor: kBgLightColor,
              //             filled: true,
              //             suffixIcon: Padding(
              //               padding: const EdgeInsets.all(
              //                   kDefaultPadding * 0.75), //15
              //               child: SvgPicture.asset(
              //                 "assets/Icons/Search.svg",
              //                 width: 24,
              //               ),
              //             ),
              //             border: OutlineInputBorder(
              //               borderRadius: BorderRadius.all(Radius.circular(10)),
              //               borderSide: BorderSide.none,
              //             ),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              SizedBox(height: kDefaultPadding),
              Divider(thickness: 1),
              Container(
                child: RefreshIndicator(
                  child: ListView.builder(
                    itemCount: notifier.courseList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(notifier.courseList[index].title),
                          subtitle: Text(notifier.courseList[index].details),
                        ),
                      );
                    },
                  ),
                  onRefresh: _refreshList,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
