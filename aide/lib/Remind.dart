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

class RemindCreateState extends State<RemindCreate> {
  final collection = Firestore.instance.collection('tasks');
  String _task = 'Choose a task';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a reminder'),
        centerTitle: true,
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
                return new Container(
                  padding: EdgeInsets.only(bottom: 16.0),
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: new Row(
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
                          ),
                          isEmpty: _task == null,
                          child: new DropdownButton(
                            isDense: true,
                            items: snapshot.data.documents
                                .map((DocumentSnapshot document) {
                              return new DropdownMenuItem<String>(
                                  value: document.data['name'],
                                  child: new Container(
                                    child: new Text(document.data['name']),
                                  )
                              );
                            }).toList(),
                            onChanged: (String newValue) {
                              setState(() {
                                _task = newValue;
                              });
                            },
                            isExpanded: true,
                            hint: _task == '' ? Text('Select one task...') : Text(_task, style: TextStyle(fontWeight: FontWeight.bold),),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
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
            'timestamp': DateTime.now(),
            'completed': false
          });
          // Go back to list screen
          Navigator.pop(context);
        },
      ),
    );
  }
}
