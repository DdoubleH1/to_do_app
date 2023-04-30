import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../provider/category.dart';
import '../provider/task.dart';

class DatabaseHelper {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'categories_tasks.db'),
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
            "CREATE TABLE categories(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, categoryTasks TEXT NOT NULL, color TEXT NOT NULL)");
        await db.execute(
            "CREATE TABLE tasks(id TEXT PRIMARY KEY, category TEXT NOT NULL, title TEXT NOT NULL, taskDate TEXT NOT NULL, taskTime TEXT NOT NULL, color TEXT NOT NULL, isDone TEXT NOT NULL)");
      },
    );
  }

  Future<int> insertCategory(Category category) async {
    final Database db = await initializeDB();
    final result = await db.insert('categories', category.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return result;
  }

  Future<List<Category>> getCategory() async {
    final Database db = await initializeDB();
    final extractedCategory = await db.query(
      'categories',
    );
    return extractedCategory.map((e) => Category.fromMap(e)).toList();
  }

  Future<void> updateCategoryTasks(int? id, String categoryList) async {
    final Database db = await initializeDB();
    await db.rawUpdate('UPDATE categories SET categoryTasks = ? WHERE id = ?',
        [categoryList, id]);
  }

  Future<void> updateCategory(int? id, Category category) async {
    final Database db = await initializeDB();
    await db.update('categories', category.toMap(),
        where: 'id = ?',
        whereArgs: [id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteCategory(int? id) async {
    final Database db = await initializeDB();
    await db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> insertTask(Task task) async {
    final Database db = await initializeDB();
    final result = await db.insert('tasks', task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return result;
  }

  Future<void> deleteTask(String? id) async {
    final Database db = await initializeDB();
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Task>> getTask() async {
    final Database db = await initializeDB();
    final extractListTasks = await db.query('tasks');
    final extractTask = extractListTasks.map((e) => Task.fromMap(e)).toList();
    return extractTask;
  }

  Future<void> updateTask(String? id, Task task) async {
    final Database db = await initializeDB();
    await db.update('tasks', task.toMap(),
        where: 'id = ?',
        whereArgs: [id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
