import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/provider/category.dart';
import 'package:to_do_app/screens/category_detai_screen.dart';
import 'package:to_do_app/widgets/category_item.dart';

import '../provider/task.dart';
import '../screens/add_category_screen.dart';
import '../screens/add_task_screen.dart';
import '../widgets/task_item.dart';

enum AddingOption { Task, Category }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<CategoryLists>(context, listen: false).fetchAndSetCategories();
    Provider.of<Tasks>(context, listen: false).fetchAndSetTasks();
  }

  void pushCategoryDetailScreen(
    Category item,
    BuildContext context,
  ) {
    Navigator.of(context)
        .pushNamed(CategoryDetailScreen.routeName, arguments: item.id);
  }

  @override
  Widget build(BuildContext context) {
    final tasksData = Provider.of<Tasks>(context);
    final categoryData = Provider.of<CategoryLists>(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    bool confirmDelete = false;
    bool needTrailingColor = true;

    void triggerBuild() {
      setState(() {});
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: const Padding(
          padding: EdgeInsets.only(left: 13),
          child: Text(
            'MitMinder',
            style: TextStyle(
                color: Colors.black, fontSize: 25, fontFamily: 'SFProDisplay'),
          ),
        ),
        actions: [
          PopupMenuButton(
              itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: AddingOption.Task,
                      child: Text('Task'),
                    ),
                    const PopupMenuItem(
                      value: AddingOption.Category,
                      child: Text('Category'),
                    ),
                  ],
              icon: const Icon(
                Icons.add,
                color: Colors.blue,
              ),
              onSelected: (AddingOption selectedOption) {
                if (selectedOption == AddingOption.Task) {
                  Navigator.of(context).pushNamed(AddTaskScreen.routeName);
                } else {
                  Navigator.of(context).pushNamed(AddCategoryScreen.routeName);
                }
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: screenHeight / 2.3,
              child: ListView.builder(
                  itemCount: tasksData.tasks.length,
                  itemBuilder: (ctx, i) {
                    return Dismissible(
                      key: ValueKey(tasksData.tasks[i].id),
                      background: Container(
                        alignment: Alignment.centerRight,
                        color: tasksData.tasks[i].color,
                        padding: const EdgeInsets.only(right: 20),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 4,
                        ),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) {
                        // setState(() {});
                        tasksData.deleteTask(tasksData.tasks[i].id);
                        categoryData.deleteTaskFromCategory(
                            tasksData.tasks[i].id, tasksData.tasks[i].category);
                        // setState(() {});
                      },
                      confirmDismiss: (_) {
                        return showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                                  title: const Text('Confirm to delete task'),
                                  content: const Text(
                                      'Do you want to remove the task ?'),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop(false);
                                        },
                                        child: const Text(
                                          'No',
                                          style: TextStyle(color: Colors.black),
                                        )),
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop(true);
                                        },
                                        child: const Text('Yes',
                                            style: TextStyle(
                                                color: Colors.black))),
                                  ],
                                ));
                      },
                      child: TaskItem(
                          tasksData.tasks[i], needTrailingColor, Colors.white),
                    );
                  }),
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
            Container(
              height: screenHeight,
              padding: const EdgeInsets.only(left: 14),
              child: Column(
                children: [
                  const Text(
                    "My Lists",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 20),
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 10)),
                  Expanded(
                    child: ListView.builder(
                      // shrinkWrap: true,
                      itemCount: categoryData.categoryLists.length,
                      itemBuilder: (ctx, i) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4),
                          child: CategoryItem(categoryData.categoryLists[i],
                              pushCategoryDetailScreen),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
