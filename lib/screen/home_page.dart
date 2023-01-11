import 'package:attendance_record/models/attendance.dart';
import 'package:attendance_record/screen/add_attendance_record_screen.dart';
import 'package:attendance_record/screen/search_page.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  final List<Attendance> _attendance;
  const HomePage({
    super.key,
    required List<Attendance> attendance,
  }) : _attendance = attendance;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Attendance> _filteredAttendance = List.from(widget._attendance);
  late List<Attendance> _filteredAttendanceList;
  final _searchController = TextEditingController();
  bool _isToggle = false;
  bool _showSearchBar = false;
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
        builder: (context) => AddAttandanceRecordScreen(
            attendance: newAttendance,
            onSave: (attendance) {
              setState(() {
                _filteredAttendance.add(attendance);
              });
              Navigator.pop(context);
              _showSuccessSnackBar();
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
    _filteredAttendanceList = widget._attendance;
    _searchController.addListener(_handleSearch);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearch() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchPage(
            attendance: _filteredAttendance,
            onSearch: onSearch,
          ),
        ));
  }

  void _openSearchPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchPage(
            attendance: _filteredAttendance,
            onSearch: (List<Attendance> filteredList) {
              setState(() {
                _filteredAttendanceList = filteredList;
              });
              Navigator.pop(context);
            },
          ),
        ));
  }

  void onSearch(List<Attendance> filteredList) {
    setState(() {
      _filteredAttendanceList = filteredList;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sortedAttendances = widget._attendance.sort(
      (a, b) => b.checkIn.compareTo(a.checkIn),
    );
    return Builder(
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Attendance Record"),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Search"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            TextField(
                              decoration: const InputDecoration(
                                  labelText: "Enter name or phone number"),
                              onChanged: (text) {
                                setState(() {
                                  _filteredAttendanceList =
                                      widget._attendance.where((attendance) {
                                    final keyword = text.toLowerCase();
                                    return attendance.user
                                            .toLowerCase()
                                            .contains(keyword) ||
                                        attendance.phoneNum
                                            .toLowerCase()
                                            .contains(keyword);
                                  }).toList();
                                });
                              },
                            ),
                            TextButton(
                              child: Text("Search"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
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
            itemCount: _filteredAttendance.length,
            itemBuilder: (context, index) {
              final attendance = _filteredAttendance[index];
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
          floatingActionButton: FloatingActionButton(
            onPressed: _addAttendanceRecord,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  void _showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("New Attendance Record added Successfully!"),
    ));
  }
}
