import 'package:flutter/material.dart';
import 'package:aide/task.dart';

// A new widget that will render the screen to view tasks
class TODOList extends StatelessWidget {
  final List<Task> tasks;
  final onToggle;

  // Receiving tasks from parent widget
  TODOList({@required this.tasks, @required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aide - TODO List'),
      ),
      body: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            // Changed ListTile to CheckboxListTile to have
            // the checkbox capability
            return CheckboxListTile(
              title: Text(tasks[index].getName()),
              // Passing a value and a callback for the checkbox
              value: tasks[index].isCompleted(),
              // The _ in the argument list is there because onChanged expects it
              // But we are not using it
              onChanged: (_) => onToggle(tasks[index]),
            );
          }),

      // Add a button to open new screen to create a new task
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/create'),
        child: Icon(Icons.add),
      ),
    );
  }
}
