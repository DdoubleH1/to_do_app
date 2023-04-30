import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/category.dart';
import '../provider/task.dart';

class CategoryItem extends StatefulWidget {
  // const CategoryItem({super.key});
  final Category item;
  final Function func;
  const CategoryItem(this.item, this.func, {super.key});

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  @override
  Widget build(BuildContext context) {
    final tasksData = Provider.of<Tasks>(context);
    final categoryData = Provider.of<CategoryLists>(context);
    Color kColor = widget.item.color.computeLuminance() > 0.5
        ? Colors.black
        : Colors.white;
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: ValueKey(widget.item.id),
      background: Container(
        alignment: Alignment.centerRight,
        color: widget.item.color,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) async {
        await categoryData.deleteCategory(widget.item.id);
        await tasksData.deleteCategoryTasks(widget.item.title);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: widget.item.color,
        ),
        child: GestureDetector(
          onTap: () {
            widget.func(widget.item, context);
          },
          child: ListTile(
            title: Text(
              widget.item.title,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 20, color: kColor),
            ),
            subtitle: Text(
              '${widget.item.categoryTasks.length} ${widget.item.categoryTasks.length > 1 ? 'tasks' : 'task'}',
              style: TextStyle(color: kColor),
            ),
          ),
        ),
      ),
    );
  }
}
