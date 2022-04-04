import 'package:flutter/material.dart';

// An initial version of home containing issues.
import 'home.dart';
// The completed version of home.
// import 'home_completed.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Image Processing Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeWidget(),
    );
  }
}
