import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/provider/category.dart';
import 'package:to_do_app/widgets/category_item.dart';

class BottomCategoryPicker extends StatefulWidget {
  const BottomCategoryPicker({super.key});

  @override
  State<BottomCategoryPicker> createState() => _BottomCategoryPickerState();
}

class _BottomCategoryPickerState extends State<BottomCategoryPicker> {
  void _pickCategory(Category pickedCategory, BuildContext context) {
    Navigator.of(context).pop(pickedCategory);
  }

  @override
  Widget build(BuildContext context) {
    final categoryData = Provider.of<CategoryLists>(context, listen: false);
    return ListView.builder(
        shrinkWrap: true,
        itemCount: categoryData.categoryLists.length,
        itemBuilder: (ctx, i) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 2),
            child: CategoryItem(categoryData.categoryLists[i], _pickCategory),
          );
        });
  }
}
