import 'package:flutter/material.dart';
import 'package:aide/task.dart';

void main() => runApp(TODOApp());

// The sole reason we keep this extra component is
// because runApp will only take a StatelessWidget as its argument
class TODOApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TODO();
  }
}

// Here we are defining a StatefulWidget
class TODO extends StatefulWidget {
  // Every stateful widget must override createState
  @override
  State<StatefulWidget> createState() {
    return TODOState();
  }
}

class TODOState extends State<TODO> {
  // Creating a list of tasks with some fake data
  final List<Task> tasks = [];

  // Function that modifies the state when a new task is created
  void onTaskCreated(String name) {
    // All state modifications have to be wrapped in setState
    // This way Flutter knows that something has changed
    setState(() {
      tasks.add(Task(name));
    });
  }

  // A new callback function to toggle task's completion
  void onTaskToggled(Task task) {
    setState(() {
      task.setCompleted(!task.isCompleted());
    });
  }

  // This widget is the root of your application.
  // Now state is responsible for building the widget
  @override
  Widget build(BuildContext context) {
    // Instead of rendering content, we define routes for different screens
    // in our app
    return MaterialApp(
      title: 'Welcome to Aide',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        // Screen to view tasks
        '/': (context) => TODOList(tasks: tasks, onToggle: onTaskToggled),
        // Screen to create tasks
        '/create': (context) => TODOCreate(
              onCreate: onTaskCreated,
            ),
      },
    );
  }
}

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

// A new widget to render new task creation screen
class TODOCreate extends StatefulWidget {
  // Callback function that gets called when user submits a new task
  final onCreate;

  TODOCreate({@required this.onCreate});

  @override
  State<StatefulWidget> createState() {
    return TODOCreateState();
  }
}

class TODOCreateState extends State<TODOCreate> {
  // Controller that handles the TextField
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create a task')),
      body: Center(
          child: Padding(
              padding: EdgeInsets.all(16),
              child: TextField(
                  // Opens the keyboard automatically
                  autofocus: true,
                  controller: controller,
                  decoration:
                      InputDecoration(labelText: 'Enter name for your task')))),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: () {
          // Call the callback with the new task name
          widget.onCreate(controller.text);
          // Go back to list screen
          Navigator.pop(context);
        },
      ),
    );
  }
}
