import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../provider/category.dart';

class Task {
  final String id;
  final String category;
  final String title;
  final DateTime taskDate;
  final DateTime taskTime;
  final Color color;
  bool isDone;

  Task(
      {required this.id,
      required this.category,
      required this.title,
      required this.color,
      required this.taskDate,
      required this.taskTime,
      required this.isDone});

  factory Task.fromMap(Map<String, dynamic> Json) {
    String valueString = Json['color'].split('(0x')[1].split(')')[0];
    int colorValue = int.parse(valueString, radix: 16);
    return Task(
        id: Json['id'],
        category: Json['category'],
        title: Json['title'],
        color: Color(colorValue),
        taskDate: DateTime.parse(Json['taskDate']),
        taskTime: DateTime.parse(Json['taskTime']),
        isDone: (Json['isDone'] == 'true') ? true : false);
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'category': category,
        'title': title,
        'color': color.toString(),
        'taskDate': taskDate.toIso8601String(),
        'taskTime': taskTime.toIso8601String(),
        'isDone': isDone.toString(),
      };
}

class Tasks with ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks {
    return [..._tasks];
  }

  Future<void> fetchAndSetTasks() async {
    final db = DatabaseHelper();
    _tasks = await db.getTask();
    notifyListeners();
  }

  Future<Task> addTask(String taskTitle, Category taskCategory,
      DateTime taskDate, DateTime taskTime) async {
    final newTask = Task(
      id: '${taskCategory.title}${DateTime.now()}',
      category: taskCategory.title,
      title: taskTitle,
      color: taskCategory.color,
      taskDate: taskDate,
      taskTime: taskTime,
      isDone: false,
    );
    final db = DatabaseHelper();
    await db.insertTask(newTask);
    _tasks.insert(0, newTask);
    notifyListeners();
    return _tasks[0];
  }

  Future<void> updateTask(Color newColor, Color oldColor) async {
    final db = DatabaseHelper();
    for (int i = 0; i < _tasks.length; i++) {
      if (_tasks[i].color == oldColor) {
        final updateTask = Task(
            id: _tasks[i].id,
            category: _tasks[i].category,
            title: _tasks[i].title,
            color: newColor,
            taskDate: _tasks[i].taskDate,
            taskTime: _tasks[i].taskTime,
            isDone: _tasks[i].isDone);
        await db.updateTask(_tasks[i].id, updateTask);
        _tasks[i] = updateTask;
      }
    }
    notifyListeners();
  }

  Future<void> deleteTask(String id) async {
    final db = DatabaseHelper();
    await db.deleteTask(id);
    final index = _tasks.indexWhere((element) => element.id == id);
    _tasks.removeAt(index);
  }
}
