import 'package:fluent_ui/fluent_ui.dart';

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
            child: ProgressRing(),
          );
        } else if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return ContentDialog(
            title: const Text('Add Task'),
            content: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: formKey,
              child: Wrap(
                children: [
                  TextFormBox(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                    controller: _titleController,
                    placeholder: 'Title',
                  ),
                  const SizedBox(
                    height: 10,
                    width: 10,
                  ),
                  TextFormBox(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                    maxLines: 4,
                    controller: _descriptionController,
                    placeholder: 'Description',
                  ),
                ],
              ),
            ),
            actions: [
              Button(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FilledButton(
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
    return ContentDialog(
      title: const Text('Edit Task'),
      content: Form(
        child: Wrap(
          children: [
            TextFormBox(
              controller: _titleController,
              placeholder: 'Title',
              // initialValue: widget.task.name.isEmpty
              //     ? 'The task has no title'
              //     : widget.task.name,
            ),
            const SizedBox(
              height: 10,
              width: 10,
            ),
            TextFormBox(
              maxLines: 4,
              // initialValue: widget.task.description.isEmpty
              //     ? 'The task has no description'
              //     : widget.task.description,
              controller: _descriptionController,
              placeholder: 'Description',
            ),
          ],
        ),
      ),
      actions: [
        Button(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FilledButton(
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
