import 'package:fluent_ui/fluent_ui.dart';
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
    return ScaffoldPage(
      content: FutureBuilder<Task>(
        future: db.readTask(widget.id),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: ProgressRing(),
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
                CommandBar(
                  primaryItems: [
                    CommandBarButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(FluentIcons.back),
                    ),
                    const CommandBarSeparator(),
                    CommandBarButton(
                      label: const Text('Edit'),
                      icon: const Icon(FluentIcons.edit),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => EditTaskDialog(task: task),
                        );
                      },
                    ),
                    CommandBarButton(
                      onPressed: () {
                        db.delete(task.id);
                        Navigator.pop(context);
                      },
                      label: const Text('Delete'),
                      icon: const Icon(FluentIcons.delete),
                    ),
                    CommandBarButton(
                      onPressed: () {
                        setState(() {
                          db.update(task.copy(completed: !task.completed));
                        });
                      },
                      icon: Icon(
                        task.completed
                            ? FluentIcons.cancel
                            : FluentIcons.accept,
                      ),
                      label: Text(
                        task.completed ? 'Uncomplete' : 'Complete',
                      ),
                    ),
                    CommandBarButton(
                      onPressed: () {
                        setState(() {
                          db.update(task.copy(starred: !task.starred));
                        });
                      },
                      icon: Icon(
                        task.starred
                            ? FluentIcons.favorite_star_fill
                            : FluentIcons.favorite_star,
                      ),
                      label: Text(
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
                      style: FluentTheme.of(context).typography.title,
                    ),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(height: 20, width: 10),
                    Text(
                      task.description,
                      style: FluentTheme.of(context).typography.body,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const SizedBox(width: 10),
                    Text(
                      '${task.date.day}.${task.date.month}.${task.date.year}',
                      style: FluentTheme.of(context).typography.caption,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      '${task.date.hour}:$minute',
                      style: FluentTheme.of(context).typography.caption,
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
    );
  }
}
