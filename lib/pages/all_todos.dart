import 'package:fluent_ui/fluent_ui.dart';
import 'package:todo_tasks/models/task_model.dart';
import 'package:todo_tasks/screens/task_details.dart';
import 'package:todo_tasks/tasks_db.dart';

class AllToDos extends StatefulWidget {
  const AllToDos({Key? key}) : super(key: key);

  @override
  State<AllToDos> createState() => _AllToDosState();
}

class _AllToDosState extends State<AllToDos> {
  @override
  Widget build(BuildContext context) {
    late List<Task?>? tasks;
    TasksDatabase.instance;
    return ScaffoldPage(
      content: FutureBuilder<List<Task>>(
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
                return GestureDetector(
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
                );
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
            return Container();
          }
        },
      ),
    );
  }
}
