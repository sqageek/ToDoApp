import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
                      labelText: 'Enter name for your task')),
                SizedBox(height: 10),
                TextField(
                  // Opens the keyboard automatically
                    autofocus: true,
                    keyboardType: TextInputType.multiline,
                    maxLines: 4,
                    maxLength: 200,
                    controller: notes,
                    decoration: InputDecoration(
                        labelText: 'Enter more details for your task')),
            ]
          )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: () async {
          // Create a new document
          await collection.add({'name': controller.text, 'notes': notes.text, 'timestamp':  DateTime.now().millisecondsSinceEpoch , 'completed': false});
          // Go back to list screen
          Navigator.pop(context);
        },
      ),
    );
  }
}

