import 'package:flutter/material.dart';

import 'package:todo_tasks/models/task_model.dart';
import 'package:todo_tasks/pages/all_todos.dart';
import 'package:todo_tasks/tasks_db.dart';

class AddTaskDialog extends StatefulWidget {
  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return FutureBuilder(
      future: TasksDatabase.instance.readAllTasks(),
      builder: (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return AlertDialog(
            title: const Text('Add Task'),
            content: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: formKey,
              child: Wrap(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Title',
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                    controller: _titleController,
                  ),
                  const SizedBox(
                    height: 10,
                    width: 10,
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                    maxLines: 4,
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                onPressed: () {
                  const AllToDos().createState();
                  formKey.currentState!.save();
                  if (formKey.currentState!.validate()) {
                    TasksDatabase.instance.create(
                      Task(
                        id: snapshot.data!.length + 1,
                        name: _titleController.text,
                        description: _descriptionController.text,
                        starred: false,
                        date: DateTime.now(),
                      ),
                    );
                    Navigator.pop(context);
                  } else {
                    return;
                  }
                },
                child: const Text('Add Task'),
              )
            ],
          );
        } else {
          return const Center(
            child: Text('Error'),
          );
        }
      },
    );
  }
}

class EditTaskDialog extends StatefulWidget {
  final Task task;
  const EditTaskDialog({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  State<EditTaskDialog> createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<EditTaskDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Task'),
      content: Form(
        child: Wrap(
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
              // initialValue: widget.task.name.isEmpty
              //     ? 'The task has no title'
              //     : widget.task.name,
            ),
            const SizedBox(
              height: 10,
              width: 10,
            ),
            TextFormField(
              maxLines: 4,
              // initialValue: widget.task.description.isEmpty
              //     ? 'The task has no description'
              //     : widget.task.description,
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          onPressed: () {
            TasksDatabase.instance.update(
              widget.task.copy(
                name: _titleController.text,
                description: _descriptionController.text,
                date: DateTime.now(),
              ),
            );
            Navigator.pop(context);
            setState(() {});
          },
          child: const Text('Edit Task'),
        )
      ],
    );
  }
}
