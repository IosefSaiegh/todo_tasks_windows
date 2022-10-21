import 'package:flutter/material.dart';
import 'package:todo_tasks/models/task_model.dart';

class TasksProvider extends ChangeNotifier {
  final List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void removeTask(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }

  void updateTask(Task task, int id) {
    _tasks.where((element) => element.id == id).forEach((element) {
      element.name = task.name;
      element.description = task.description;
      element.completed = task.completed;
      element.starred = task.starred;
      element.date = task.date;
    });
    _tasks.add(task);
    notifyListeners();
  }

  void checkTask(int id, value) {
    _tasks.where((element) => element.id == id).forEach((element) {
      element.completed = value;
    });
    notifyListeners();
  }
}
