import 'package:fluent_ui/fluent_ui.dart';
import 'package:todo_tasks/pages/all_todos.dart';
import 'package:todo_tasks/pages/completed_todos.dart';
import 'package:todo_tasks/pages/not_completed.dart';

import '../pages/importants.dart';
import '../widgets/add_task_dialog.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return NavigationView(
      pane: NavigationPane(
        selected: index,
        onChanged: (value) {
          setState(() {
            index = value;
          });
        },
        items: [
          PaneItemHeader(
            header: const Text(
              'ToDo Tasks',
              style: TextStyle(fontSize: 30),
            ),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.home),
            title: const Text('Home'),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.checkbox_composite),
            title: const Text('Completed'),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.checkbox),
            title: const Text('Not Completed'),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.favorite_list),
            title: const Text('Importants'),
          ),
          PaneItemSeparator(),
          PaneItemAction(
            title: const Text(
              'Add Task',
              style: TextStyle(fontSize: 20),
            ),
            icon: const Icon(FluentIcons.add),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AddTaskDialog(),
              );
            },
          ),
        ],
      ),
      content: NavigationBody(
        index: index,
        children: const [
          AllToDos(),
          CompletedToDos(),
          NotCompleted(),
          ImportantsToDos()
        ],
      ),
    );
  }
}
