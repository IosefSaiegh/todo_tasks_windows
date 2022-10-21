import 'package:flutter/material.dart';
import 'package:todo_tasks/pages/all_todos.dart';
import 'package:todo_tasks/pages/completed_todos.dart';
import 'package:todo_tasks/pages/not_completed.dart';

import '../pages/importants.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  int index = 0;
  @override
  Widget build(BuildContext context) {
    const widgetList = [
      AllToDos(),
      CompletedToDos(),
      NotCompleted(),
      ImportantsToDos()
    ];
    return Scaffold(
      body: widgetList[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (value) {
          setState(() {
            index = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box),
            label: 'Completed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box_outlined),
            label: 'Not Completed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_border),
            label: 'Importants',
          ),
        ],
      ),
    );
  }
}
