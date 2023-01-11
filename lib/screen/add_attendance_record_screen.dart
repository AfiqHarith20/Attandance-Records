import 'package:attendance_record/models/attendance.dart';
import 'package:flutter/material.dart';

class AddAttandanceRecordScreen extends StatefulWidget {
  final Attendance attendance;
  final void Function(Attendance) onSave;
  const AddAttandanceRecordScreen({
    Key? key,
    required this.attendance,
    required this.onSave,
  }) : super(key: key);

  @override
  State<AddAttandanceRecordScreen> createState() =>
      _AddAttandanceRecordScreenState();
}

class _AddAttandanceRecordScreenState extends State<AddAttandanceRecordScreen> {
  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _checkInController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController.text = widget.attendance.user;
    _phoneNumberController.text = widget.attendance.phoneNum;
    _checkInController.text = widget.attendance.checkIn.toIso8601String();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Attendance Record'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            TextField(
              controller: _checkInController,
              decoration: InputDecoration(labelText: 'Check In Time'),
            ),
            ElevatedButton(
              onPressed: () {
                final newAttendance = Attendance(
                  user: _nameController.text,
                  phoneNum: _phoneNumberController.text,
                  checkIn: DateTime.parse(_checkInController.text),
                );
                widget.onSave(newAttendance);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
