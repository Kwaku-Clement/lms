import 'package:lms/constants/colors.dart';
import 'package:lms/widget/responsive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';
import 'package:intl/intl.dart';
import 'package:lms/constants/constants.dart';
import 'package:lms/models/models.dart';
import 'package:lms/models/provider_notifier.dart';
import 'package:lms/service/database.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddSchedule extends StatefulWidget {
  final String courseId;
  final String userName;
  final String courseName;

  const AddSchedule(
      {Key key, @required this.courseId, this.userName, this.courseName})
      : super(key: key);
  @override
  _AddScheduleState createState() => _AddScheduleState();
}

class _AddScheduleState extends State<AddSchedule> {
  String title;
  String details;
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController roomController = TextEditingController();
  final TextEditingController titleController = TextEditingController();

  final dateFormat = DateFormat('MM-dd-yyyy');

  Model _currentModel;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime _selectedDate = DateTime.now();
  Future<void> _selectDate() async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2222));

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = DateTime(picked.year, picked.month, picked.day,
            _selectedDate.hour, 0, 0, 0, 0);
      });
    }
  }

  String code = '';

  createCode() {
    setState(() {
      code = Uuid().v1().substring(0, 8);
    });
  }

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
    _selectedDate = DateTime(_selectedDate.year, _selectedDate.month,
        _selectedDate.day, _selectedDate.hour, 0, 0, 0, 0);
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
                    // initialValue: _currentModel.title,
                    controller: titleController,
                    keyboardType: TextInputType.text,
                    decoration: kInputTextFieldDecoration.copyWith(
                        labelText: 'Meeting title'),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Meeting title is required';
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
                  child: Text('Enter meeting ID',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center),
                ),
                SizedBox(height: 20),
                Container(
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          )
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: PinCodeTextField(
                        controller: roomController,
                        appContext: context,
                        length: 8,
                        autoDisposeControllers: false,
                        animationType: AnimationType.fade,
                        pinTheme: PinTheme(shape: PinCodeFieldShape.underline),
                        animationDuration: Duration(milliseconds: 300),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Meeting Id is required';
                          }

                          return null;
                        },
                        onSaved: (String value) {
                          _currentModel.details = value;
                        },
                        onChanged: (String value) {
                          _currentModel.details = value;
                        },
                      ),
                    )),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        child: TextFormField(
                      //initialValue: _currentModel.date,
                      controller: dateController,
                      decoration:
                          kInputTextFieldDecoration.copyWith(labelText: 'Date'),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Date is required';
                        }

                        return null;
                      },
                      onSaved: (String value) {
                        _currentModel.date = value;
                      },
                    )),
                    SizedBox(width: 10),
                    Container(
                        child: TextFormField(
                      //initialValue: _currentModel.time,
                      controller: timeController,
                      decoration:
                          kInputTextFieldDecoration.copyWith(labelText: 'Time'),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Time is required';
                        }

                        return null;
                      },
                      onSaved: (String value) {
                        _currentModel.time = value;
                      },
                    )),
                  ],
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Meeting ID: ',
                        style: TextStyle(fontSize: 30),
                      ),
                      SizedBox(height: 20),
                      Text(
                        code,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.purple,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25),
                InkWell(
                  onTap: () {
                    createCode();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: GradientColors.facebookMessenger),
                    ),
                    child: Center(
                      child: Text(
                        'Creete code',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25),
              ]),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          _saveSchedule();
        },
        child: Icon(Icons.save),
        foregroundColor: Colors.white,
      ),
    );
  }

  _saveSchedule() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    Database()
        .uploadSchedule(_currentModel, _onScheduleUploaded, widget.courseId);
  }

  _onScheduleUploaded(Model schedule) {
    ProviderNotifier modelNotifier =
        Provider.of<ProviderNotifier>(context, listen: false);
    modelNotifier.addCourse(schedule);
    titleController.clear();
    dateController.clear();
    timeController.clear();
    roomController.clear();
  }
}
