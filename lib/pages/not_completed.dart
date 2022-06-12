import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:todo_tasks/models/task_model.dart';
import 'package:todo_tasks/tasks_db.dart';

import '../providers/tasks_provider.dart';
import '../screens/task_details.dart';

class NotCompleted extends StatefulWidget {
  const NotCompleted({Key? key}) : super(key: key);

  @override
  State<NotCompleted> createState() => _NotCompletedState();
}

class _NotCompletedState extends State<NotCompleted> {
  @override
  Widget build(BuildContext context) {
    late List<Task?>? tasks;
    TasksProvider tasksProvider = Provider.of<TasksProvider>(context);
    TasksDatabase.instance;
    return ScaffoldPage(
      content: FutureBuilder(
        future: TasksDatabase.instance.readAllTasks(),
        builder: (BuildContext context, AsyncSnapshot<List<Task?>> snapshot) {
          if (snapshot.hasData) {
            tasks = snapshot.data;
            return ListView.builder(
              itemCount: tasks?.length,
              itemBuilder: (BuildContext context, int index) {
                Task task = tasks![index]!;
                int minute = task.date.minute;
                String time =
                    '${task.date.hour}:${minute < 10 ? '0$minute' : minute}';
                String date =
                    '${task.date.day}.${task.date.month}.${task.date.year}';
                return task.completed == false
                    ? GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            FluentPageRoute(
                              builder: (context) => TaskDetails(id: task.id),
                            ),
                          );
                        },
                        child: ListTile(
                          title: Text(task.name),
                          subtitle: Text(
                            task.description,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          trailing: Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  task.starred
                                      ? FluentIcons.favorite_star_fill
                                      : FluentIcons.favorite_star,
                                ),
                                onPressed: () {
                                  setState(() {
                                    TasksDatabase.instance.update(
                                      task.copy(
                                        starred: !task.starred,
                                      ),
                                    );
                                  });
                                },
                              ),
                              IconButton(
                                icon: const Icon(FluentIcons.delete),
                                onPressed: () {
                                  setState(() {
                                    TasksDatabase.instance.delete(task.id);
                                  });
                                },
                              ),
                            ],
                          ),
                          leading: Checkbox(
                            checked: task.completed,
                            onChanged: (value) {
                              TasksDatabase.instance.update(
                                task.copy(
                                  completed: value,
                                ),
                              );
                              setState(() {});
                            },
                          ),
                        ),
                      )
                    : Container();
              },
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: ProgressRing(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          } else {
            return const Center(
              child: Text('No data'),
            );
          }
        },
      ),
    );
  }
}
