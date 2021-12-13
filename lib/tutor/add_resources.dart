import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lms/constants/constants.dart';
import 'package:lms/models/models.dart';
import 'package:lms/models/provider_notifier.dart';
import 'package:lms/service/database.dart';
import 'package:provider/provider.dart';

class AddResources extends StatefulWidget {
  final String courseId;
  final String userName;
  final String courseName;
  final bool isUpdating;

  const AddResources(
      {Key key,
      @required this.courseId,
      this.userName,
      this.courseName,
      this.isUpdating})
      : super(key: key);

  @override
  _AddResourcesState createState() => _AddResourcesState();
}

class _AddResourcesState extends State<AddResources> {
  String title;
  String details;
  final TextEditingController titleController = TextEditingController();
  UploadTask task;
  String _fileUrl;
  File file;

  final dateFormat = DateFormat('MM-dd-yyyy');

  Model _currentModel;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    ProviderNotifier modelNotifier =
        Provider.of<ProviderNotifier>(context, listen: false);

    if (modelNotifier.currentModel != null) {
      _currentModel = modelNotifier.currentModel;
    } else {
      _currentModel = Model();
    }
  }

  _showImage() {
    if (file == null && _fileUrl == null) {
      return Text("File placeholder");
    } else if (file != null) {
      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.file(
            file,
            fit: BoxFit.cover,
            height: 250,
          ),
          FlatButton(
            padding: EdgeInsets.all(16),
            color: Colors.black54,
            child: Text(
              'Change File',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w400),
            ),
            onPressed: () => _getLocalFile(),
          )
        ],
      );
    } else if (_fileUrl != null) {
      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Image.network(
            _fileUrl,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            height: 250,
          ),
          FlatButton(
            padding: EdgeInsets.all(16),
            color: Colors.black54,
            child: Text(
              'Change Image',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w400),
            ),
            onPressed: () => _getLocalFile(),
          )
        ],
      );
    }
  }

  _getLocalFile() async {
    final FilePickerResult result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result == null) return;
    final path = result.files.single.path;

    setState(() => file = File(path));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Back'),
        elevation: 0.0,
      ),
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              _showImage(),
              SizedBox(height: 16),
              file == null && _fileUrl == null
                  ? ButtonTheme(
                      child: ElevatedButton(
                        onPressed: () => _getLocalFile(),
                        child: Text(
                          'Add File',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  : SizedBox(height: 0),
              Container(
                child: TextFormField(
                  initialValue: _currentModel.title,
                  controller: titleController,
                  keyboardType: TextInputType.text,
                  decoration:
                      kInputTextFieldDecoration.copyWith(labelText: 'Filename'),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Filename is required';
                    }
                    return null;
                  },
                  onSaved: (String value) {
                    _currentModel.title = value;
                  },
                ),
              ),
              SizedBox(height: 20),
            ]),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FocusScope.of(context).requestFocus(FocusNode());
          _saveResources();
        },
        child: Icon(Icons.save),
        foregroundColor: Colors.white,
      ),
    );
  }

  _saveResources() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    // Database(uid: user.uid).uploadResources(_currentModel, widget.isUpdating,
    //     widget.courseId, file, _onAnnounmentUploaded);
  }

  _onAnnounmentUploaded(Model announcement) {
    ProviderNotifier modelNotifier =
        Provider.of<ProviderNotifier>(context, listen: false);
    modelNotifier.addCourse(announcement);
    titleController.clear();
  }
}
