import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/category.dart';

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
    Color kColor = widget.item.color.computeLuminance() > 0.5
        ? Colors.black
        : Colors.white;
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: ValueKey(widget.item.id),
      background: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: widget.item.color,
        ),
      ),
      onDismissed: (direction) {
        Provider.of<CategoryLists>(context, listen: false)
            .deleteCategory(widget.item.id);
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
