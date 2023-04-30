import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/provider/category.dart';

import '../constant/category_colors.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  static const routeName = '/add_category_screen';

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _categoryController = TextEditingController();
  var _categoryColor = const Color(0xFF006CFF);
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    Color submitCategoryColor;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: Text(
            'New Category',
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color),
          ),
        ),
        elevation: 0,
        leading: ElevatedButton(
            style: ElevatedButton.styleFrom(
                elevation: 0, animationDuration: Duration.zero),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Cancel',
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                  fontFamily: 'SFProText'),
            )),
        leadingWidth: 92,
        actions: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
              ),
              onPressed: () {
                if (_categoryController.text == "") {
                  return;
                } else {
                  Provider.of<CategoryLists>(context, listen: false)
                      .addCategory(_categoryController.text, _categoryColor);
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                'Done',
                style: TextStyle(
                    color: _categoryController.text == ""
                        ? Colors.grey
                        : Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontFamily: 'SFProText'),
              ))
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            height: screenHeight / 3,
            width: double.infinity,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              borderOnForeground: true,
              color: Colors.white70,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight / 40),
                    child: CircleAvatar(
                      radius: screenHeight / 15,
                      backgroundColor: _categoryColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                    child: TextFormField(
                      validator: (value) {
                        setState(() {});
                        return null;
                      },
                      controller: _categoryController,
                      textAlign: TextAlign.center,
                      cursorColor: Colors.blue,
                      cursorWidth: 1,
                      decoration: InputDecoration(
                        hintStyle: const TextStyle(
                            color: Colors.black38, fontWeight: FontWeight.bold),
                        hintText: 'Category Name',
                        disabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10)),
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.all(10)),
          Container(
              margin: EdgeInsets.symmetric(horizontal: screenWidth / 110),
              width: screenWidth - screenWidth / 20,
              height: screenHeight / 10,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                color: Colors.white70,
                child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemExtent: screenWidth / 7,
                    scrollDirection: Axis.horizontal,
                    itemCount: categoryColor.length,
                    itemBuilder: (ctx, i) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          backgroundColor: categoryColor[i],
                          // disabledBackgroundColor: categoryColor[i],
                        ),
                        onPressed: () {
                          setState(() {
                            _categoryColor = categoryColor[i];
                          });
                        },
                        child: const Text(""),
                      );
                    }),
              )),
        ],
      ),
    );
  }
}
