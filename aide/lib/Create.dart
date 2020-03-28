import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

// A new widget to render new task creation screen
class TODOCreate extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TODOCreateState();
  }
}

class TODOCreateState extends State<TODOCreate> {
  final collection = Firestore.instance.collection('tasks');
  // Controller that handles the TextField
  final TextEditingController controller = TextEditingController();
  final TextEditingController notes = TextEditingController();

//  String _date = "Not set";
//  String _time = "Not set";
//  DateTime dateSelected;
  DateTime date1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create a task')),
      body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
              children: <Widget>[
                TextField(
                // Opens the keyboard automatically
                  autofocus: true,
                  controller: controller,
                  decoration: InputDecoration(
                      labelText: 'Enter new task')),
                SizedBox(height: 10),
                TextField(
                  // Opens the keyboard automatically
                    autofocus: true,
                    keyboardType: TextInputType.multiline,
                    maxLines: 4,
                    maxLength: 200,
                    controller: notes,
                    decoration: InputDecoration(
                        labelText: 'Enter more details of task')),
                SizedBox(height: 10),
                DateTimePickerFormField(
                  inputType: InputType.both,
                  format: DateFormat("yyyy-MM-dd HH:mm"),
                  editable: false,
                  decoration: InputDecoration(
                      labelText: 'DateTime',
                      hasFloatingPlaceholder: false
                  ),
                  onChanged: (dt) {
                    setState(() => date1 = dt);
                    print('Selected date: $date1');
                  },
                ),
                SizedBox(height: 16.0),
//                RaisedButton(
//                  shape: RoundedRectangleBorder(
//                      borderRadius: BorderRadius.circular(5.0)),
//                  elevation: 4.0,
//                  onPressed: () {
//                    DatePicker.showDatePicker(context,
//                        theme: DatePickerTheme(
//                          containerHeight: 210.0,
//                        ),
//                        showTitleActions: true,
//                        minTime: DateTime(2000, 1, 1),
//                        maxTime: DateTime(2030, 12, 31), onConfirm: (date) {
//                          print('confirm date $date');
//                          DateFormat df = DateFormat('yyyy-MM-dd');
//                          _date = '${date.year}-${date.month}-${date.day}';
//                          _date = df.parse(date.toString()).toString();
//                          setState(() {});
//                        }, currentTime: DateTime.now(), locale: LocaleType.en);
//                  },
//                  child: Container(
//                    alignment: Alignment.center,
//                    height: 50.0,
//                    child: Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                      children: <Widget>[
//                        Row(
//                          children: <Widget>[
//                            Container(
//                              child: Row(
//                                children: <Widget>[
//                                  Icon(
//                                    Icons.date_range,
//                                    size: 18.0,
//                                    color: Colors.teal,
//                                  ),
//                                  Text(
//                                    " $_date",
//                                    style: TextStyle(
//                                        color: Colors.teal,
//                                        fontWeight: FontWeight.bold,
//                                        fontSize: 18.0),
//                                  ),
//                                ],
//                              ),
//                            )
//                          ],
//                        ),
//                        Text(
//                          "  Change",
//                          style: TextStyle(
//                              color: Colors.teal,
//                              fontWeight: FontWeight.bold,
//                              fontSize: 18.0),
//                        ),
//                      ],
//                    ),
//                  ),
//                  color: Colors.white,
//                ),
//                SizedBox(
//                  height: 20.0,
//                ),
//                RaisedButton(
//                  shape: RoundedRectangleBorder(
//                      borderRadius: BorderRadius.circular(5.0)),
//                  elevation: 4.0,
//                  onPressed: () {
//                    DatePicker.showTimePicker(context,
//                        theme: DatePickerTheme(
//                          containerHeight: 210.0,
//                        ),
//                        showTitleActions: true, onConfirm: (time) {
//                          print('confirm time $time');
//                          DateFormat df = DateFormat('HH:mm:ss');
//                          _time = '${time.hour}:${time.minute}:${time.second}';
//                          _time = df.parse(time.toString()).toString();
//                          setState(() {});
//                        }, currentTime: DateTime.now(), locale: LocaleType.en);
//                    setState(() {});
//                  },
//                  child: Container(
//                    alignment: Alignment.center,
//                    height: 50.0,
//                    child: Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                      children: <Widget>[
//                        Row(
//                          children: <Widget>[
//                            Container(
//                              child: Row(
//                                children: <Widget>[
//                                  Icon(
//                                    Icons.access_time,
//                                    size: 18.0,
//                                    color: Colors.teal,
//                                  ),
//                                  Text(
//                                    " $_time",
//                                    style: TextStyle(
//                                        color: Colors.teal,
//                                        fontWeight: FontWeight.bold,
//                                        fontSize: 18.0),
//                                  ),
//                                ],
//                              ),
//                            )
//                          ],
//                        ),
//                        Text(
//                          "  Change",
//                          style: TextStyle(
//                              color: Colors.teal,
//                              fontWeight: FontWeight.bold,
//                              fontSize: 18.0),
//                        ),
//                      ],
//                    ),
//                  ),
//                  color: Colors.white,
//                )

            ]
          )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: () async {
          // Create a new document
          await collection.add({'name': controller.text, 'notes': notes.text, 'timestamp': date1 , 'completed': false});
          // Go back to list screen
          Navigator.pop(context);
        },
      ),
    );
  }
}

