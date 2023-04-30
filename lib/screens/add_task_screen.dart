import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/screens/add_category_screen.dart';

import '../provider/category.dart';
import '../provider/task.dart';
import '../widgets/bottom_category_picker.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});
  static const routeName = '/add_task_screen';
  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _addTaskController = TextEditingController();
  late DateTime selectedDate = DateTime(1);
  late DateTime selectedTime = DateTime(1);
  Category pickedCategory = Category(
      // id: DateTime.now().toIso8601String(),
      title: "Lists",
      categoryTasks: [],
      color: Colors.transparent);

  bool isChecked = false;
  bool isCategoryListEmpty = true;

  Future<DateTime> _showDatePicker() async {
    setState(() {
      selectedDate = DateTime.now();
    });
    selectedDate = await showModalBottomSheet(
      context: context,
      builder: (_) => CupertinoDatePicker(
        mode: CupertinoDatePickerMode.date,
        onDateTimeChanged: (val) {
          setState(() {
            selectedDate = val;
          });
        },
      ),
    );
    return selectedDate;
  }

  Future<DateTime> _showTimePicker() async {
    setState(() {
      selectedTime = DateTime.now();
    });
    selectedDate = await showModalBottomSheet(
      context: context,
      builder: (_) => CupertinoDatePicker(
        use24hFormat: false,
        mode: CupertinoDatePickerMode.time,
        onDateTimeChanged: (val) {
          setState(() {
            selectedTime = val;
          });
        },
      ),
    );
    return selectedTime;
  }

  @override
  Widget build(BuildContext context) {
    // final pushCategoryData =
    //     ModalRoute.of(context)!.settings.arguments as Category;
    CategoryLists bottomCategoryList =
        Provider.of<CategoryLists>(context, listen: false);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    double bottomBarSize = 130;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: TextButton(
            style: TextButton.styleFrom(elevation: 0),
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
          TextButton(
              style: TextButton.styleFrom(elevation: 0),
              onPressed: (_addTaskController.text == '' ||
                      pickedCategory ==
                          Category(
                              // id: DateTime.now().toIso8601String(),
                              title: "Lists",
                              categoryTasks: [],
                              color: Colors.transparent) ||
                      selectedDate == DateTime(1) ||
                      selectedTime == DateTime(1))
                  ? () {
                      scaffoldMessenger.showSnackBar(const SnackBar(
                          duration: Duration(seconds: 2),
                          content: Center(
                            child: Text(
                                'Please complete missing task information'),
                          )));
                    }
                  : () async {
                      final addedTask =
                          await Provider.of<Tasks>(context, listen: false)
                              .addTask(_addTaskController.text, pickedCategory,
                                  selectedDate, selectedTime);
                      Provider.of<CategoryLists>(context, listen: false)
                          .addTaskToCategory(pickedCategory.id, addedTask);
                      Navigator.of(context).pop();

                      // show
                    },
              child: const Text(
                'Done',
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontFamily: 'SFProText'),
              ))
        ],
      ),
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: LayoutBuilder(
          builder: (ctx, constraint) {
            bottomBarSize = constraint.maxHeight;
            return BottomAppBar(
              child: Row(
                children: [
                  IconButton(
                    onPressed: _showDatePicker,
                    icon: const Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.black26,
                    ),
                  ),
                  IconButton(
                    onPressed: _showTimePicker,
                    icon: const Icon(
                      Icons.timer_outlined,
                      color: Colors.black26,
                    ),
                  ),
                  SizedBox(
                    width: constraint.maxWidth * 3 / 7,
                  ),
                  TextButton(
                      style: TextButton.styleFrom(
                        fixedSize: const Size(100, 30),
                        elevation: 0,
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (BuildContext ctx) {
                              return SizedBox(
                                  height: screenHeight / 2,
                                  width: double.infinity,
                                  child:
                                      (bottomCategoryList.categoryLists.isEmpty)
                                          ? Column(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: screenHeight / 5),
                                                  child: const Text(
                                                    'There is no category yet!',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pushNamed(
                                                              AddCategoryScreen
                                                                  .routeName)
                                                          .then((value) {
                                                        setState(() {});
                                                      });
                                                    },
                                                    child: const Text(
                                                      'Adding some',
                                                      style: TextStyle(
                                                          color: Colors.blue),
                                                    ))
                                              ],
                                            )
                                          : const BottomCategoryPicker());
                            }).then((value) {
                          setState(() {
                            pickedCategory = value;
                          });
                        });
                      },
                      child: Text(
                        pickedCategory.title,
                        style: const TextStyle(
                            color: Colors.grey,
                            fontFamily: 'SFProText',
                            fontSize: 18),
                      )),
                  SizedBox(
                      width: 10,
                      height: 10,
                      child:
                          CircleAvatar(backgroundColor: pickedCategory.color)),
                ],
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          ListTile(
              leading: Transform.scale(
                scale: 1.4,
                child: Checkbox(
                    side: const BorderSide(width: 0.7, color: Colors.black26),
                    shape: const CircleBorder(),
                    // checkColor: Colors.blue,
                    value: isChecked,
                    onChanged: (val) {
                      setState(() {
                        isChecked = val!;
                      });
                    }),
              ),
              title: TextField(
                style: const TextStyle(
                    fontFamily: 'SFProText', fontWeight: FontWeight.w500),
                maxLines: 1,
                cursorColor: Colors.blue,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'What do you want to do?'),
                controller: _addTaskController,
              ),
              subtitle: Row(children: [
                selectedDate == DateTime(1)
                    ? const Text('')
                    : const Icon(Icons.calendar_today_outlined),
                Text(selectedDate == DateTime(1)
                    ? ''
                    : DateFormat.MMMMd().format(selectedDate)),
                Padding(padding: EdgeInsets.only(left: screenWidth / 30)),
                selectedTime == DateTime(1)
                    ? const Text('')
                    : const Icon(Icons.timer_outlined),
                Text(selectedTime == DateTime(1)
                    ? ''
                    : DateFormat.jm().format(selectedTime)),
              ]),
              trailing: Column(
                children: [
                  const Padding(padding: EdgeInsets.only(bottom: 18)),
                  CircleAvatar(
                    backgroundColor: pickedCategory.color,
                    radius: 6,
                  )
                ],
              )),
        ],
      )),
    );
  }
}
