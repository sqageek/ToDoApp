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
  final collection = Firestore.instance.collection('reminders');
  // Controller that handles the TextField
  final TextEditingController controller = TextEditingController();
  final TextEditingController notes = TextEditingController();
  DateTime date1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create a reminder')),
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
              ]
          )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: () async {
          // Create a new document
          await collection.add({'name': controller.text, 'hourly': false, 'daily': false, 'weekly': false, 'monthly': false, 'yearly': false, 'timestamp': date1 , 'completed': false});
          // Go back to list screen
          Navigator.pop(context);
        },
      ),
    );
  }
}

