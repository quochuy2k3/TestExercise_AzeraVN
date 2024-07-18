import 'package:flutter/material.dart';

class TodoListWidget extends StatefulWidget {
  @override
  _TodoListWidgetState createState() => _TodoListWidgetState();
}

class _TodoListWidgetState extends State<TodoListWidget> {
  List<String> _tasks = []; // List to store tasks

  TextEditingController _taskController =
      TextEditingController(); // Controller for text field

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      child: Card(
        elevation: 3,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'To-Do List',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(
              color: Colors.blue,
              thickness: 2.0,
              indent: 20.0,
              endIndent: 20.0,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_tasks[index]), // Display task
                    trailing: IconButton(
                      icon: Icon(Icons.delete), // Delete icon
                      onPressed: () {
                        setState(() {
                          _tasks.removeAt(index); // Remove task from list
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _taskController, // Text field controller
                      decoration: InputDecoration(
                        hintText: 'Enter a task', // Placeholder text
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add), // Add icon
                    onPressed: () {
                      if (_taskController.text.isNotEmpty) {
                        setState(() {
                          _tasks.add(_taskController.text); // Add task to list
                          _taskController.clear(); // Clear text field
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
