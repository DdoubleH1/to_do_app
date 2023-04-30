import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/provider/category.dart';
import 'package:to_do_app/screens/add_task_screen.dart';
import 'package:to_do_app/screens/edit_category_screen.dart';
import 'package:to_do_app/widgets/task_item.dart';

class CategoryDetailScreen extends StatefulWidget {
  const CategoryDetailScreen({Key? key}) : super(key: key);
  static const routeName = '/category_detail_screen';

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  Category pickedCategory =
      Category(title: '', categoryTasks: [], color: Colors.black);

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    final pickedCategoryId = ModalRoute.of(context)!.settings.arguments as int;
    pickedCategory = Provider.of<CategoryLists>(context, listen: false)
        .findById(pickedCategoryId);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool needTrailingColor = false;
    Color kColor = pickedCategory.color.computeLuminance() > 0.5
        ? Colors.black
        : Colors.white;

    return Scaffold(
      backgroundColor: pickedCategory.color,
      appBar: AppBar(
        backgroundColor: pickedCategory.color,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: kColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Padding(
          padding: EdgeInsets.only(top: size.height / 50),
          child: ListTile(
            title: Text(
              pickedCategory.title,
              style: TextStyle(
                  color: kColor, fontWeight: FontWeight.bold, fontSize: 30),
            ),
            subtitle: Text(
              '${pickedCategory.categoryTasks.length} ${pickedCategory.categoryTasks.length > 1 ? 'tasks' : 'task'}',
              style: TextStyle(color: kColor),
            ),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditCategoryScreen.routeName,
                        arguments: pickedCategory.id)
                    .then((_) {
                  setState(() {});
                });
              },
              icon: Icon(
                Icons.edit,
                color: kColor,
              ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: kColor,
          onPressed: () {
            Navigator.of(context)
                .pushNamed(AddTaskScreen.routeName, arguments: pickedCategory);
          },
          child: const Icon(
            Icons.add,
            color: Colors.blue,
          )),
      body: ListView.builder(
          itemCount: pickedCategory.categoryTasks.length,
          itemBuilder: (ctx, i) => TaskItem(pickedCategory.categoryTasks[i],
              needTrailingColor, pickedCategory.color)),
    );
  }
}
