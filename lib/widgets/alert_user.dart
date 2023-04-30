// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:to_do_app/provider/category.dart';
//
// import '../provider/task.dart';
//
// class AlertUser extends StatefulWidget {
//   final String taskId;
//   final String taskTitle;
//   const AlertUser({required this.taskId, required this.taskTitle, Key? key})
//       : super(key: key);
//
//   @override
//   State<AlertUser> createState() => _AlertUserState();
// }
//
// class _AlertUserState extends State<AlertUser> {
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text('Confirm to delete task'),
//       // content: const Text('Please return the edit screen!'),
//       actions: [
//         ElevatedButton(
//             onPressed: () {
//               Provider.of<Tasks>(context, listen: false)
//                   .deleteTask(widget.taskId);
//               Provider.of<CategoryLists>(context, listen: false)
//                   .deleteTaskFromCategory(widget.taskId, widget.taskTitle);
//               Navigator.of(context).pop();
//             },
//             child: const Text(
//               'Yes',
//               style: TextStyle(color: Colors.black),
//             )),
//         ElevatedButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: const Text('No', style: TextStyle(color: Colors.black))),
//       ],
//     );
//   }
// }
