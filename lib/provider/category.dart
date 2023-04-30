import 'dart:convert';

import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../provider/task.dart';

class Category {
  final int? id;
  final String title;
  List<Task> categoryTasks;
  final Color color;

  Category({
    this.id,
    required this.title,
    required this.categoryTasks,
    required this.color,
  });

  List<Map<String, dynamic>> listToMap() {
    final map = categoryTasks
        .map((task) => {
              'id': task.id,
              'category': task.category,
              'title': task.title,
              'taskDate': task.taskDate.toIso8601String(),
              'taskTime': task.taskTime.toIso8601String(),
              'color': task.color,
              'isDone': task.isDone
            })
        .toList();
    return map;
  }

  factory Category.fromMap(Map<String, dynamic> Json) {
    String valueString = Json['color'].split('(0x')[1].split(')')[0];
    int colorValue = int.parse(valueString, radix: 16);
    return Category(
        id: Json['id'],
        title: Json['title'],
        categoryTasks: (json.decode(Json['categoryTasks']) as List<dynamic>)
            .map((item) => Task(
                id: item['id'],
                category: item['category'],
                title: item['title'],
                color: Color(colorValue),
                taskDate: DateTime.parse(item['taskDate']),
                taskTime: DateTime.parse(item['taskTime']),
                isDone: item['isDone']))
            .toList(),
        color: Color(colorValue));
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'categoryTasks': json.encode(listToMap()),
        'color': color.toString(),
      };
}

class CategoryLists with ChangeNotifier {
  List<Category> _categoryList = [];

  List<Category> get categoryLists {
    return [..._categoryList];
  }

  Future<void> fetchAndSetCategories() async {
    final db = DatabaseHelper();
    _categoryList = await db.getCategory();
    notifyListeners();
  }

  Future<void> addCategory(String title, Color catColor) async {
    final db = DatabaseHelper();
    final addedCategoryId = await db.insertCategory(
        Category(title: title, categoryTasks: [], color: catColor));
    _categoryList.insert(
        0,
        Category(
            id: addedCategoryId,
            title: title,
            categoryTasks: [],
            color: catColor));
    notifyListeners();
  }

  Future<void> addTaskToCategory(int? taskCategoryId, Task newTask) async {
    final listTasks = _categoryList
        .firstWhere((cat) => cat.id == taskCategoryId)
        .categoryTasks;
    listTasks.insert(0, newTask);
    final db = DatabaseHelper();
    await db.updateCategoryTasks(
        taskCategoryId,
        json.encode(listTasks
            .map((task) => {
                  'id': task.id,
                  'category': task.category,
                  'title': task.title,
                  'taskDate': task.taskDate.toIso8601String(),
                  'taskTime': task.taskTime.toIso8601String(),
                  'color': task.color.toString(),
                  'isDone': task.isDone
                })
            .toList()));
    notifyListeners();
  }

  Future<void> deleteTaskFromCategory(
      String taskId, String categoryTaskTitle) async {
    final foundCategoryIndex =
        _categoryList.indexWhere((cat) => cat.title == categoryTaskTitle);
    _categoryList[foundCategoryIndex]
        .categoryTasks
        .removeWhere((task) => task.id == taskId);
    final db = DatabaseHelper();
    await db.updateCategory(_categoryList[foundCategoryIndex].id,
        _categoryList[foundCategoryIndex]);
    notifyListeners();
  }

  Future<void> updateCategory(
      int? id, String title, List<Task> categoryTasks, Color newColor) async {
    final index = _categoryList.indexWhere((element) => element.id == id);
    _categoryList[index] = Category(
        id: id, title: title, categoryTasks: categoryTasks, color: newColor);
    final db = DatabaseHelper();
    await db.updateCategory(
        id,
        Category(
            id: id,
            title: title,
            categoryTasks: categoryTasks,
            color: newColor));
    notifyListeners();
  }

  Future<void> deleteCategory(int? id) async {
    final db = DatabaseHelper();
    await db.deleteCategory(id);
    _categoryList = await db.getCategory();
    notifyListeners();
  }

  Category findById(int id) {
    return _categoryList.firstWhere((cat) => cat.id == id, orElse: () {
      return Category(title: 'title', categoryTasks: [], color: Colors.black);
    });
  }
}
