import 'package:flutter/material.dart';

void main() {
  runApp(TodolistApp());
}

class TodolistApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My ToDo App',
      home: TodoHomePage(),
    );
  }
}

class Todo {
  final String name;
  final TaskStatus taskStatus;

  Todo({
    required this.name,
    required this.taskStatus,
  });
}

enum TaskStatus { done, not_done }

class TodoHomePage extends StatefulWidget {
  @override
  State<TodoHomePage> createState() => TodoHomePageState();
}

class TodoHomePageState extends State<TodoHomePage> {
  final List<Todo> tasks = [
    // Todo(name: 'Task 1', taskStatus: TaskStatus.not_done),
    // Todo(name: 'Task 2', taskStatus: TaskStatus.not_done),
  ];
  final TextEditingController controller = TextEditingController();

  void addTodo() {
    if (controller.text.isNotEmpty) {
      setState(() {
        tasks.add(Todo(name: controller.text, taskStatus: TaskStatus.not_done));
        controller.clear();
      });
    }
  }

  void todoStatus(int index) {
    setState(() {
      tasks[index] = Todo(
          name: tasks[index].name,
          taskStatus: tasks[index].taskStatus == TaskStatus.done
              ? TaskStatus.not_done
              : TaskStatus.done);
    });
  }

  void editTodo(int index) {
    if (tasks[index].taskStatus != TaskStatus.done) {
      controller.text = tasks[index].name;
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Edit your task'),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Edit your task',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final str = controller.text;
                  setState(() {
                    tasks[index] =
                        Todo(name: str, taskStatus: tasks[index].taskStatus);
                    controller.clear();
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      );
    }
  }

  void removeTodo(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My ToDo App'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter a task',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: addTodo,
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final todo = tasks[index];
                return ListTile(
                  title: Text(todo.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.black),
                        onPressed: () => editTodo(index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => removeTodo(index),
                      ),
                    ],
                  ),
                  leading: Checkbox(
                    value: (tasks[index].taskStatus == TaskStatus.done),
                    onChanged: (_) => todoStatus(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
