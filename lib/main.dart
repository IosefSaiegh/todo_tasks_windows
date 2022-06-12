import 'dart:async';
import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:todo_tasks/providers/tasks_provider.dart';
import 'package:todo_tasks/screens/home_page.dart';

Future<void> _moveLnkFileToDesktop() async {
  String myAppDataPath = '${Platform.environment['AppData']}\\todo_tasks';

  try {
    var myAppDataDirectoryExists = await Directory(myAppDataPath).exists();
    if (!myAppDataDirectoryExists) {
      await Directory(myAppDataPath).create();
      await File(
              '${File(Platform.resolvedExecutable).parent.path}\\assets\\ToDo Tasks.lnk')
          .copy(
              '${Platform.environment['USERPROFILE']}\\desktop\\ToDo Tasks.lnk');
    } else {
      await File(
              '${File(Platform.resolvedExecutable).parent.path}\\data\\flutter_assets\\ToDo Tasks.lnk')
          .copy(
              '${Platform.environment['USERPROFILE']}\\desktop\\ToDo Tasks.lnk');
    }
  } catch (e) {
    print(e);
  }
}

void main() {
  runApp(MyApp());
  _moveLnkFileToDesktop();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TasksProvider(), lazy: false),
      ],
      child: FluentApp(
        debugShowCheckedModeBanner: false,
        title: 'ToDo Tasks',
        home: HomePage(),
      ),
    );
  }
}
