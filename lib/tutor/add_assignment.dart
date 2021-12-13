import 'package:lms/constants/colors.dart';
import 'package:lms/widget/responsive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lms/constants/constants.dart';
import 'package:lms/models/models.dart';
import 'package:lms/models/provider_notifier.dart';
import 'package:lms/service/database.dart';
import 'package:provider/provider.dart';

class AddAssignment extends StatefulWidget {
  final String courseId;
  final String userName;
  final String courseName;

  const AddAssignment(
      {Key key, @required this.courseId, this.userName, this.courseName})
      : super(key: key);
  @override
  _AddAssignmentState createState() => _AddAssignmentState();
}

class _AddAssignmentState extends State<AddAssignment> {
  String title;
  String details;
  final TextEditingController detailsController = TextEditingController();
  final TextEditingController titleController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Back'),
        elevation: 0.0,
      ),
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            top: kIsWeb ? kDefaultPadding : 0,
            left: kIsWeb ? 30 : 0,
          ),
          width: Responsive.isMobile(context)
              ? MediaQuery.of(context).size.width
              : 800,
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                Container(
                  child: TextFormField(
                    initialValue: _currentModel.title,
                    controller: titleController,
                    keyboardType: TextInputType.text,
                    decoration: kInputTextFieldDecoration.copyWith(
                        labelText: 'Forum title'),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Forum title is required';
                      }

                      return null;
                    },
                    onSaved: (String value) {
                      _currentModel.title = value;
                    },
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                    child: TextFormField(
                  initialValue: _currentModel.details,
                  controller: detailsController,
                  minLines: 5,
                  maxLines: null,
                  decoration: kInputTextFieldDecoration.copyWith(
                      labelText: 'Forum details'),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Forum details is required';
                    }

                    return null;
                  },
                  onSaved: (String value) {
                    _currentModel.details = value;
                  },
                )),
                SizedBox(height: 20),
              ]),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          _saveForum();
        },
        child: Icon(Icons.save),
        foregroundColor: Colors.white,
      ),
    );
  }

  _saveForum() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    Database().uploadForum(_currentModel, widget.courseId, _onQuizUploaded);
  }

  _onQuizUploaded(Model forum) {
    ProviderNotifier modelNotifier =
        Provider.of<ProviderNotifier>(context, listen: false);
    modelNotifier.addCourse(forum);
    titleController.clear();
    detailsController.clear();
  }
}
