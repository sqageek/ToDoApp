import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TODOList extends StatefulWidget {
  @override
  _TODOList createState() => _TODOList();
}

// A new widget that will render the screen to view tasks
//class TODOList extends State<TODOListState>
class _TODOList extends State<TODOList> {
  // Setting reference to 'tasks' collection
  final collection = Firestore.instance.collection('tasks');
//  final String title;
//  final String notes;
//  final DateTime timestamp;
//  final bool completed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aide - TODO List'),
      ),
      // Making a StreamBuilder to listen to changes in real time
      body: StreamBuilder<QuerySnapshot>(
        stream: collection.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // Handling errors from firebase
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            // Display if still loading data
            case ConnectionState.waiting:
              return Text('Loading...');
            default:
              return ListView.separated(
                padding: const EdgeInsets.all(4.0),
                separatorBuilder: (context, index) => Divider(
                  color: Colors.blueAccent,
                  thickness: 1.0,
                ),
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
//                    return Container(
////                      height: 50,
////                      margin: EdgeInsets.all(1),
////                      child: Center(
////                          child: Text(snapshot.data.documents[index]['name'],
////                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: "Open Sans"), textAlign: TextAlign.left,),),
////                      color: (snapshot.data.documents[index]['completed'] == true)? Colors.green : Colors.orangeAccent ,
////                    );

                  var s = snapshot.data.documents[index];
                  return Dismissible(
                    //key: Key(s['key']),
                    key: UniqueKey(),
                    background: Container(color: Colors.orangeAccent),
                    direction:
                        (s['completed'] ? DismissDirection.horizontal : null),
                    onDismissed: (direction) {
                      setState(() async {
                        await collection.document(s.documentID).delete();
                        //snapshot.data.documents.removeAt(index);
                      });
                      Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text('Task "${s['name']}" dismissed!')));
                    },
                    child: new GestureDetector(
                      child: new Container(
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
                          new Align(
                            child: new Text((s['notes'] == null)
                                ? '\n'
                                : '\n' + '${s['notes']}' + '\n'),
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
                              //new Align (child: new Text( (s['timestamp'] == null) ? '' : '${s['timestamp']}',
                              new Align(
                                child: new Text(
                                  (s['timestamp'] == null)
                                      ? ''
                                      : new DateTime.fromMillisecondsSinceEpoch(
                                              s['timestamp'])
                                          .toLocal()
                                          .toString()
                                          .substring(
                                              0,
                                              DateTime.fromMillisecondsSinceEpoch(
                                                          s['timestamp'])
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
                        ]),
                      ),
                      onLongPress: () {
                        collection
                            .document(s.documentID)
                            .updateData({'completed': !s['completed']});
                        Scaffold.of(context).showSnackBar(SnackBar(
                            content:
                                //!s['completed'] ? Text('Task "${s['name']}" marked as completed!')  : Text('Task "${s['name']}" marked as not completed!')
                                new RichText(
                          textAlign: TextAlign.center,
                          text: new TextSpan(
                            style: TextStyle(color: Colors.black),
                            children: <TextSpan>[
                              new TextSpan(
                                  text: 'Task ',
                                  style: new TextStyle(color: Colors.white)),
                              new TextSpan(
                                  text: '${s['name']}',
                                  style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber)),
                              new TextSpan(
                                  text: ' marked as ',
                                  style: new TextStyle(color: Colors.white)),
                              new TextSpan(
                                  text: s['completed'] ? 'not ' : '',
                                  style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red)),
                              new TextSpan(
                                  text: 'completed!',
                                  style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ],
                          ),
                        )));
                      },
                    ),
                  );
                  //)
                },
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
