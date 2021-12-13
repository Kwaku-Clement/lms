import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:lms/service/database.dart';
import 'package:path/path.dart';

class AddFile extends StatefulWidget {
  final String courseId;

  const AddFile({Key key, this.courseId}) : super(key: key);

  @override
  _AddFileState createState() => _AddFileState();
}

class _AddFileState extends State<AddFile> {
  UploadTask task;
  File file;
  bool uploading = false;

  double val = 0;
  Reference ref;

  List<File> _files = [];
  List<String> name = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Files'),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(4),
              child: GridView.builder(
                  itemCount: _files.length + 1,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    return index == 0
                        ? Center(
                            child: TextButton.icon(
                                icon: Icon(Icons.add),
                                label: Text('Add file'),
                                onPressed: () =>
                                    !uploading ? selectFile() : null),
                          )
                        : Container(
                            child: Image.asset('assets/images/pdf_cover.png'),
                            margin: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: FileImage(_files[index - 1]),
                                  fit: BoxFit.cover),
                            ),
                          );
                  }),
            ),
            uploading
                ? Center(
                    child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        child: Text(
                          'uploading...',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CircularProgressIndicator(
                        value: val,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      )
                    ],
                  ))
                : Container(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      uploading = true;
                    });
                    uploadFile()
                        .whenComplete(() => Navigator.of(context).pop());
                  },
                  icon: Icon(Icons.upload),
                  label: Text('Upload'),
                ),
              ),
            )
          ],
        ));
  }

  Future selectFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      result.files.forEach((selectedFile) {
        File file = File(selectedFile.path);
        setState(() {
          _files.add(file);
        });
      });
    }
  }

  Future uploadFile() async {
    int i = 1;
    for (var file in _files) {
      setState(() {
        val = i / _files.length;
      });
      ref = FirebaseStorage.instance
          .ref()
          .child('documents/${basename(file.path)}');
      await ref.putFile(file).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          coursesCollection
              .doc(widget.courseId)
              .collection('Files')
              .add({'url': value, 'name': basename(file.path)});
          i++;
        });
      });
    }
  }
}
