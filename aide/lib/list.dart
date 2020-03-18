import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// A new widget that will render the screen to view tasks
class TODOList extends StatelessWidget {

  // Setting reference to 'tasks' collection
  final collection = Firestore.instance.collection('tasks');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aide - TODO List'),
      ),
      // Making a StreamBuilder to listen to changes in real time
      body: StreamBuilder<QuerySnapshot>(
          stream: collection.snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
            // Handling errors from firebase
            if(snapshot.hasError)
              return Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState){
              // Disaplay if still loadig data
              case ConnectionState.waiting: return Text('Loading...');
              default:
                return ListView(
                  // Got rid of Task class
                  children: snapshot.data.documents.map((DocumentSnapshot document){
                    return CheckboxListTile(
                      title: Text(document['name']),
                      value: document['completed'],
                      // Updating the database on task completion
                      onChanged: (newValue) => collection.document(document.documentID).updateData({'completed': newValue})
                      );
                  }).toList(),
                );
              }
            },
          ),

      // Add a button to open new screen to create a new task
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/create'),
        child: Icon(Icons.add),
      ),
    );
  }
}
