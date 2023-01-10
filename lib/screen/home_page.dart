import 'package:attendance_record/models/attendance.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  final List<Attendance> _attendance;
  const HomePage({
    Key? key,
    required attendance,
  }) : _attendance = attendance;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isToggle = false;
  final DateFormat _ddMMMYYFormat = DateFormat("dd MM yyyy, h:mm:a");

  void _addAttendanceRecord() {
    final newAttendance = Attendance(
      user: '',
      phoneNum: '',
      checkIn: DateTime.now(),
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddAttendanceRecordScreen(
            attendance: newAttendance,
            onSave: (attendance) {
              setState(() {
                widget._attendance.add(attendance);
              });
              Navigator.pop(context);
            }),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('en_short', timeago.EnShortMessages());
    timeago.setLocaleMessages('fr', timeago.FrMessages());
    //load the saved state of the toggle button
    SharedPreferences.getInstance().then((prefs) {
      _isToggle = prefs.getBool("isToggle") ?? false;
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final sortedAttendances = widget._attendance.sort(
      (a, b) => b.checkIn.compareTo(a.checkIn),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance Record"),
        actions: <Widget>[
          //toggle button to change the time format
          Transform.scale(
            scale: 0.7,
            child: Switch(
              value: _isToggle,
              onChanged: (value) {
                setState(() {
                  _isToggle = value;
                });
                // save the state of the toggle button
                SharedPreferences.getInstance().then((prefs) {
                  prefs.setBool('isToggle', _isToggle);
                });
              },
            ),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: widget._attendance.length,
        itemBuilder: (context, index) {
          final attendance = widget._attendance[index];
          return ListTile(
            title: Text(attendance.user),
            subtitle: Text(attendance.phoneNum),
            trailing: Text(
              _isToggle
                  ? _ddMMMYYFormat.format(attendance.checkIn)
                  : timeago.format(attendance.checkIn, locale: "en_short"),
            ),
          );
        },
      ),
    );
  }
}
