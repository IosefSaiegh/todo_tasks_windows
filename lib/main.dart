import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_tasks/providers/tasks_provider.dart';
import 'package:todo_tasks/screens/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TasksProvider(), lazy: false),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ToDo Tasks',
        home: HomePage(),
        theme: ThemeData.dark(),
      ),
    );
  }
}
