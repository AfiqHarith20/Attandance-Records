import 'package:attendance_record/dummy_data.dart';
import 'package:attendance_record/models/attendance.dart';
import 'package:attendance_record/screen/home_page.dart';
import 'package:attendance_record/screen/search_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendance Record',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(
        attendance: Dummy_Data,
      ),
      // routes: {
      //   SearchPage.routeName: (context) => SearchPage(
      //         attendance: [],
      //         onSearch: (List<Attendance> attendance) {},
      //       ),
      // },
    );
  }
}
