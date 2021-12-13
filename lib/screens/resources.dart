import 'dart:io';

import 'package:lms/widget/responsive.dart';
import 'package:flutter/material.dart';
import 'package:lms/constants/colors.dart';
import 'package:lms/nav/custom_appbar.dart';
import 'package:lms/screens/open_pdf.dart';
import 'package:lms/service/database.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:lms/widget/videoWidget.dart';

class Resources extends StatefulWidget {
  final String courseName;
  final String courseId;
  final String username;
  final VoidCallback openDrawer;

  const Resources(
      {Key key,
      @required this.courseId,
      this.courseName,
      this.openDrawer,
      this.username})
      : super(key: key);

  @override
  _ResourcesState createState() => _ResourcesState();
}

class _ResourcesState extends State<Resources> {
 
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          openDrawer: widget.openDrawer,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              top: kIsWeb ? kDefaultPadding : 0,
              left: kIsWeb ? 30 : 0,
            ),
            width: Responsive.isMobile(context)
                ? MediaQuery.of(context).size.width
                : 900,
            child: Column(
              children: [
                Divider(thickness: 1),
                Card(
                  child: ExpansionTile(
                    title: Text('Documents'),
                    children: [
                      Container(
                        child: StreamBuilder(
                          stream: coursesCollection
                              .doc(widget.courseId)
                              .collection('Files')
                              .snapshots(),
                          builder: (context, snapshot) {
                            return !snapshot.hasData
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Container(
                                    padding: EdgeInsets.all(4),
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: snapshot.data.docs.length,
                                        itemBuilder: (context, index) {
                                          final url = snapshot.data.docs[index]
                                              .get('url');
                                          return Container(
                                            height: 80,
                                            child: ListTile(
                                              leading: Image.asset(
                                                'assets/images/pdf_cover.png',
                                                fit: BoxFit.fitHeight,
                                                width: 50,
                                                height: 50,
                                              ),
                                              title: TextButton(
                                                onPressed: () async {
                                                  final file = await Database
                                                      .loadNetwork(url);

                                                  if (file != null)
                                                    CircularProgressIndicator();
                                                  openPDF(context, file);
                                                },
                                                child: Text(
                                                  snapshot.data.docs[index]
                                                      .get('name'),
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Card(
                  child: ExpansionTile(
                    title: Text('Videos'),
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height,
                        child: StreamBuilder(
                          stream: coursesCollection
                              .doc(widget.courseId)
                              .collection('Videos')
                              .snapshots(),
                          builder: (context, snapshot) {
                            return !snapshot.hasData
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Container(
                                    padding: EdgeInsets.all(4),
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: snapshot.data.docs.length,
                                        itemBuilder: (context, index) {
                                          final url = snapshot.data.docs[index]
                                              .get('imageUrl');
                                          return Container(
                                            child: ListTile(
                                              title: Text(snapshot
                                                  .data.docs[index]
                                                  .get('title')),
                                              subtitle: Container(
                                                width: double.infinity,
                                                height: 250,
                                                alignment: Alignment.center,
                                                child: Container(
                                                    key: new PageStorageKey(
                                                      "keydata$index",
                                                    ),
                                                    child: VideoWidget(
                                                      play: false,
                                                      url: url,
                                                    )),
                                              ),
                                            ),
                                          );
                                        }),
                                  );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  openPDF(BuildContext context, File file) => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => OpenPDFPage(file: file)),
      );
}

