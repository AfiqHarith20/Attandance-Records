import 'package:attendance_record/models/attendance.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  static const String routeName = "/search";
  final List<Attendance> _attendance;
  final Function(List<Attendance>) onSearch;
  const SearchPage({
    super.key,
    required List<Attendance> attendance,
    required this.onSearch,
  }) : _attendance = attendance;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: "Search by name or phone number",
          ),
        ),
        TextButton(
          onPressed: () {
            final keyword = _searchController.text.toLowerCase();
            final filteredAttendance = widget._attendance.where((attendance) {
              return attendance.user.toLowerCase().contains(keyword) ||
                  attendance.phoneNum.toLowerCase().contains(keyword);
            }).toList();
            widget.onSearch(filteredAttendance);
            Navigator.pop(context);
          },
          child: const Text("Search"),
        ),
      ],
    );
  }
}
