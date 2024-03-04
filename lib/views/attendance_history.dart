import 'dart:io';

import 'package:employee_attendance_app/model/sql_helper.dart';
import 'package:flutter/material.dart';

class AttendanceHistory extends StatefulWidget {
  const AttendanceHistory({super.key});

  @override
  State<AttendanceHistory> createState() => _AttendanceHistoryState();
}

class _AttendanceHistoryState extends State<AttendanceHistory> {
  late String code;
  late String name = "";
  List attendanceList = [];

  Future<void> getName() async {
    name = await SQLHelper.getName(int.parse(code));
    setState(() {});
  }

  Future<void> getAttendance() async {
    attendanceList = await SQLHelper.getAttendance(int.parse(code));
    print(attendanceList);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    code = ModalRoute.of(context)!.settings.arguments as String;
    getName();
    getAttendance();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${name}'s Attendance History"),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.all(8),
        child: ListView(
          children: attendanceList
              .map(
                (e) => Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: FileImage(
                        File(e["image"]),
                      ),
                    ),
                    title: Text("${e["status"]}"),
                    subtitle: Text("${e["createdAt"]}"),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
