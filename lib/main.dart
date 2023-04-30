import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/screens/add_category_screen.dart';
import 'package:to_do_app/screens/category_detai_screen.dart';
import 'package:to_do_app/screens/edit_category_screen.dart';

import '../provider/category.dart';
import '../provider/task.dart';
import '../screens/add_task_screen.dart';
import '../screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (BuildContext context) => CategoryLists()),
        ChangeNotifierProvider(create: (BuildContext context) => Tasks()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: const Color(0xFFFFFFFF),
              ),
        ),
        home: const HomeScreen(),
        routes: {
          AddTaskScreen.routeName: (ctx) => const AddTaskScreen(),
          AddCategoryScreen.routeName: (ctx) => const AddCategoryScreen(),
          CategoryDetailScreen.routeName: (ctx) => const CategoryDetailScreen(),
          EditCategoryScreen.routeName: (ctx) => const EditCategoryScreen(),
        },
      ),
    );
  }
}
