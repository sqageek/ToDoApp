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
  // Controller that handles the TextField
  final TextEditingController controller = TextEditingController();
  final TextEditingController notes = TextEditingController();
  DateTime date1;

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
                print(snapshot.data.documents.length);
                return ListView.separated(
                  padding: const EdgeInsets.all(4.0),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.blueAccent,
                    thickness: 1.0,
                  ),
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    var s = snapshot.data.documents[index];
                    bool confirmDismiss = true;
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: new Column(children: <Widget>[
                        new Align(
                          child: new Text(
                            '${s['name']}',
                            style: new TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ), //so big text
                          alignment: FractionalOffset.topLeft,
                        ),
                        //                              new Divider(color: Colors.blue,),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            //add some actions, icons...etc
                            new Align(
                              child: new Text(
                                "Status: ",
                                style: new TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal),
                              ), //so big text
                              alignment: FractionalOffset.centerLeft,
                            ),
                            new Align(
                              child: new Text(
                                s['completed'] ? 'DONE' : '',
                                style: new TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              ), //so big text
                              alignment: FractionalOffset.centerLeft,
                            ),
                            new Align(
                              child: new Text(
                                !s['completed'] ? 'PENDING' : '',
                                style: new TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              ), //so big text
                              alignment: FractionalOffset.centerLeft,
                            ),
                            new Spacer(),
                            new Align(
                              child: new Text(
                                (s['timestamp'] == null) ? '' : 'Due: ',
                                style: new TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: (s['completed'])
                                        ? Colors.green
                                        : Colors.red),
                              ), //so big text
                              alignment: FractionalOffset.centerLeft,
                            ),
                            new Align(
                              child: new Text(
                                (s['timestamp'] == null)
                                    ? ''
                                    : DateTime.parse(
                                            s['timestamp'].toDate().toString())
                                        .toLocal()
                                        .toString()
                                        .substring(
                                            0,
                                            DateTime.parse(s['timestamp']
                                                        .toDate()
                                                        .toString())
                                                    .toLocal()
                                                    .toString()
                                                    .length -
                                                4),
                                style: new TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: (s['completed'])
                                        ? Colors.green
                                        : Colors.red),
                              ), //so big text
                              alignment: FractionalOffset.centerLeft,
                            ),
                          ],
                        ),
//                            new Divider(color: Colors.blueAccent, thickness: 1.0,),
                      ]),
                    );
                  },
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
            'name': controller.text,
            'hourly': false,
            'daily': false,
            'weekly': false,
            'monthly': false,
            'yearly': false,
            'timestamp': date1,
            'completed': false
          });
          // Go back to list screen
          Navigator.pop(context);
        },
      ),
    );
  }
}
