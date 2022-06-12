import 'dart:convert';

const String tableQrResults = 'tasks';

class TasksFields {
  static final List<String> values = [];

  static const String id = 'id';
  static const String name = 'name';
  static const String description = 'description';
  static const String completed = 'completed';
  static const String date = 'date';
  static const String starred = 'starred';
}

class Task {
  late int id;
  late String name;
  late String description;
  late bool completed;
  late bool starred;
  late DateTime date;

  Task({
    required this.id,
    required this.name,
    required this.description,
    this.completed = false,
    required this.starred,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'completed': completed == true ? 1 : 0,
      'starred': starred == true ? 1 : 0,
      'date': date.toIso8601String(),
    };
  }

  Task.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    description = map['description'];
    completed = map['completed'] == 1 ? true : false;
    starred = map['starred'] == 1 ? true : false;
    date = DateTime.parse(map['date']);
  }

  Task copy({
    int? id,
    String? name,
    String? description,
    bool? completed,
    bool? starred,
    DateTime? date,
  }) =>
      Task(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        completed: completed ?? this.completed,
        starred: starred ?? this.starred,
        date: date ?? this.date,
      );
  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) => Task.fromMap(json.decode(source));
}
