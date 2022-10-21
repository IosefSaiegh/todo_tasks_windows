import 'package:flutter/material.dart';
import 'package:todo_tasks/tasks_db.dart';
import 'package:todo_tasks/widgets/add_task_dialog.dart';

import '../models/task_model.dart';

class TaskDetails extends StatefulWidget {
  int id;
  TaskDetails({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<TaskDetails> createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  @override
  late Task task;

  @override
  Widget build(BuildContext context) {
    final db = TasksDatabase.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text(task.name),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          FutureBuilder<Task>(
            future: db.readTask(widget.id),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                task = snapshot.data;
                var minute = task.date.minute < 10
                    ? '0${task.date.minute}'
                    : task.date.minute;
                return Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => EditTaskDialog(task: task),
                            );
                          },
                          child: const Text('Edit'),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            db.delete(task.id);
                            Navigator.pop(context);
                          },
                          child: const Text('Delete'),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            setState(() {
                              db.update(task.copy(completed: !task.completed));
                            });
                          },
                          child: Text(
                            task.completed ? 'Uncomplete' : 'Complete',
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            setState(() {
                              db.update(task.copy(starred: !task.starred));
                            });
                          },
                          child: Text(
                            task.starred
                                ? 'Unmark as important'
                                : 'Mark as important',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const SizedBox(width: 10),
                        Text(
                          task.name,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const SizedBox(height: 20, width: 10),
                        Text(
                          task.description,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const SizedBox(width: 10),
                        Text(
                          '${task.date.day}.${task.date.month}.${task.date.year}',
                        ),
                        const SizedBox(width: 7),
                        Text(
                          '${task.date.hour}:$minute',
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    snapshot.error.toString(),
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }
}
