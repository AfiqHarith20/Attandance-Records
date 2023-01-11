import 'package:attendance_record/models/attendance.dart';
import 'package:flutter/material.dart';

class RecordDetailsPage extends StatefulWidget {
  final Attendance attendance;
  const RecordDetailsPage({
    super.key,
    required this.attendance,
  });

  @override
  State<RecordDetailsPage> createState() => _RecordDetailsPageState();
}

class _RecordDetailsPageState extends State<RecordDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance Record"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Name: ${widget.attendance.user}"),
            Text("Phone Number: ${widget.attendance.phoneNum}"),
            Text("Check-In Time: ${widget.attendance.checkIn}"),
          ],
        ),
      ),
    );
  }
}
