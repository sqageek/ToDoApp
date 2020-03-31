import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

// A new widget to render new task creation screen
class RemindCreate extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RemindCreateState();
  }
}

MyGlobals myGlobals = new MyGlobals();
class MyGlobals {
  GlobalKey _scaffoldKey;
  MyGlobals() {
    _scaffoldKey = GlobalKey();
  }
  GlobalKey get scaffoldKey => _scaffoldKey;
}

class RemindCreateState extends State<RemindCreate> {
  final collection = Firestore.instance.collection('tasks');
  String _task = 'Choose a task';
  DateTime reminderDateTime;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override didChangeDependencies() {
    // called when InheritedWidget updates
    // read more here https://api.flutter.dev/flutter/widgets/InheritedWidget-class.html
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a reminder'),
        centerTitle: true,
        key: myGlobals.scaffoldKey,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: StreamBuilder<QuerySnapshot>(
          stream: collection.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            // Handling errors from firebase
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              // Display if still loading data
              case ConnectionState.waiting:
                return Text('Loading...');
              default:
//                return Container(
//                  padding: EdgeInsets.only(bottom: 16.0),
//                  width: MediaQuery.of(context).size.width,
//                  child:
                   return Column(children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(bottom: 10.0, top: 10.0),
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey.withOpacity(.5),
                      child: Text("  Add Reminder Title", style: TextStyle(fontSize: 16, color: Colors.blueAccent),),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        new Expanded(
                          flex: 4,
                          child: new InputDecorator(
                            decoration: const InputDecoration(
                              hintText: 'Choose a task',
                              hintStyle: TextStyle(
                                color: Colors.deepPurple,
                                fontSize: 16.0,
                                fontFamily: "OpenSans",
                                fontWeight: FontWeight.normal,
                              ),
                              hintMaxLines: 2,
                            ),
                            isEmpty: _task == null,
                            child: new DropdownButton(
                              isDense: true,
                              items: snapshot.data.documents
                                  .map((DocumentSnapshot document) {
                                return new DropdownMenuItem<String>(
                                    value: document.data['name'],
                                    child: new Container(
                                      child: new Text(document.data['name'],),
                                    ));
                              }).toList(),
                              onChanged: (String newValue) {
                                setState(() {
                                  _task = newValue;
                                });
                              },
                              isExpanded: true,
                              hint: _task == ''
                                  ? Text('Select one task...')
                                  : Text(
                                      _task,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                    ),
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                            ),
                          ),
                        ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Container(
                      padding: EdgeInsets.only(bottom: 10.0, top: 10.0),
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey.withOpacity(.5),
                      child: Text("  Reminder Details", style: TextStyle(fontSize: 16, color: Colors.blueAccent),),
                    ),
                    SizedBox(height: 10),
                    Text("DATE"),
                    SizedBox(height: 10),
                    DateTimePickerFormField(
                        inputType: InputType.both,
                        format: DateFormat("yyyy-MM-dd HH:mm"),
                        editable: false,
                        decoration: InputDecoration(
                            labelText: 'DateTime',
                            hasFloatingPlaceholder: false
                        ),
                        onChanged: (val) {
                          setState(() => reminderDateTime = val);
                          print('Selected date: $reminderDateTime');
                        },
                    ),
                    new Text("TIME"),
                    new Text("Repeat"),
                    new Text("Remind me before"),
                  ]
                   );
                //);
            }
          },
        ),
      ),
      resizeToAvoidBottomPadding: false,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: () async {
          // Create a new document
          await collection.add({
            'name': '',
            'hourly': false,
            'daily': false,
            'weekly': false,
            'monthly': false,
            'yearly': false,
            'timestamp': reminderDateTime,
            'completed': false
          });
          // Go back to list screen
          Navigator.pop(context);
        },
      ),
    );
  }
}
