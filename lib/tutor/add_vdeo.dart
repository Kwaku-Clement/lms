import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lms/constants/colors.dart';
import 'package:lms/widget/responsive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:lms/service/database.dart';
import 'package:path/path.dart' as Path;
import 'package:video_player/video_player.dart';

class AddVideo extends StatefulWidget {
  final String courseId;

  const AddVideo({Key key, this.courseId}) : super(key: key);

  @override
  _AddVideoState createState() => _AddVideoState();
}

class _AddVideoState extends State<AddVideo> {
  bool uploading = false;
  double val = 0;
  CollectionReference imgRef;
  firebase_storage.Reference ref;

  List<File> _video = [];
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Video'),
          actions: [
            TextButton.icon(
                onPressed: () {
                  setState(() {
                    uploading = true;
                  });
                  uploadFile().whenComplete(() => Navigator.of(context).pop());
                },
                icon: Icon(Icons.upload, color: Colors.white),
                label: Text(
                  'Upload',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              top: kIsWeb ? kDefaultPadding : 0,
              left: kIsWeb ? 30 : 0,
            ),
            width: Responsive.isMobile(context)
                ? MediaQuery.of(context).size.width
                : 800,
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(4),
                  child: ListView.separated(
                    shrinkWrap: true,
                    cacheExtent: 1000,
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    key: PageStorageKey(widget.key),
                    addAutomaticKeepAlives: true,
                    itemCount: _video.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      return index == 0
                          ? Center(
                              child: TextButton(
                                child: Text('Add Video'),
                                onPressed: () =>
                                    !uploading ? chooseVideo() : null,
                              ),
                            )
                          : Container(
                              width: double.infinity,
                              height: 250,
                              alignment: Alignment.center,
                              child: Container(
                                  key: new PageStorageKey(
                                    "keydata$index",
                                  ),
                                  child: VideoWidget(
                                    play: true,
                                    url: _video[index - 1],
                                  )),
                            );
                    },
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                  ),
                ),
                uploading
                    ? Center(
                        child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            child: Center(
                              child: Text(
                                'uploading...',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          CircularProgressIndicator(
                            value: val,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.green),
                          )
                        ],
                      ))
                    : Container(),
              ],
            ),
          ),
        ));
  }

  chooseVideo() async {
    final pickedFile =
        await FilePicker.platform.pickFiles(type: FileType.video);
    setState(() {
      _video.add(File(pickedFile.files.single.path));
    });
    if (pickedFile == null) retrieveLostData();
  }

  Future<void> retrieveLostData() async {
    final LostData response = await picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _video.add(File(response.file.path));
      });
    } else {}
  }

  Future uploadFile() async {
    int i = 1;

    for (var file in _video) {
      setState(() {
        val = i / _video.length;
      });
      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child(widget.courseId)
          .child('videos/${Path.basename(file.path)}');
      await ref
          .putFile(file, SettableMetadata(contentType: 'video/mp4'))
          .whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          coursesCollection
              .doc(widget.courseId)
              .collection('Videos')
              .add({'imageUrl': value, 'title': Path.basename(file.path)});
          i++;
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    imgRef = FirebaseFirestore.instance.collection('courses');
  }
}

class VideoWidget extends StatefulWidget {
  final bool play;
  final File url;

  const VideoWidget({Key key, @required this.url, @required this.play})
      : super(key: key);

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  VideoPlayerController videoPlayerController;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.file(widget.url);
    _initializeVideoPlayerFuture = videoPlayerController.initialize().then((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    //    widget.videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return new Container(
            child: Card(
              key: new PageStorageKey(widget.url),
              elevation: 5.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Chewie(
                  key: new PageStorageKey(widget.url),
                  controller: ChewieController(
                    videoPlayerController: videoPlayerController,
                    aspectRatio: 3 / 2,
                    autoInitialize: true,
                    looping: false,
                    autoPlay: false,
                    // Errors can occur for example when trying to play a video
                    // from a non-existent URL
                    errorBuilder: (context, errorMessage) {
                      return Center(
                        child: Text(
                          errorMessage,
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
