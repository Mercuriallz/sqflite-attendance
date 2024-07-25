import 'package:attend_mobile/db_offline/database.offline.dart';
import 'package:attend_mobile/model/attendance.model.dart';
import 'package:flutter/material.dart';

class AttendanceHistoryPage extends StatefulWidget {
  const AttendanceHistoryPage({super.key});

  @override
  AttendanceHistoryPageState createState() => AttendanceHistoryPageState();
}

class AttendanceHistoryPageState extends State<AttendanceHistoryPage> {
  List<Attendance> attendances = [];
  Map<int, String> locationNames = {};

  @override
  void initState() {
    super.initState();
    loadAttendances();
  }

 loadAttendances() async {
  List<Map<String, dynamic>> data = await DatabaseHelper().queryAllAttendances();
  Map<int, String> locationNames = {};

  // Fetch location names for each unique locationId
  final locationIds = data.map((entry) => entry['locationId'] as int).toSet();
  final locationDataList = await Future.wait(
    locationIds.map((id) => DatabaseHelper().getLocationById(id))
  );

  for (var locationData in locationDataList) {
    if (locationData != null) {
      locationNames[locationData['id']] = locationData['name'];
    }
  }

  setState(() {
    attendances = data.map((e) => Attendance(
      id: e['id'],
      locationId: e['locationId'],
      timestamp: DateTime.parse(e['timestamp']),
      latitude: e['latitude'],
      longitude: e['longitude'],
      street: e['street'],
      state: e['state']
    )).toList();
    this.locationNames = locationNames;
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Riwayat absensi"),
      ),
      body: attendances.isEmpty
          ? const Center(child: Text("Belum ada riwayat absensi."))
          : ListView.builder(
              itemCount: attendances.length,
              itemBuilder: (context, i) {
                final attendance = attendances[i];
                final locationName = locationNames[attendance.locationId] ?? "Lokasi tidak diketahui";

                return ListTile(
                  title: Text("Attendance #${attendance.id}"),
                  subtitle: Text(
                    "Location: $locationName\n"
                    "Timestamp: ${attendance.timestamp}\n"
                    "Latitude: ${attendance.latitude}\n"
                    "Longitude: ${attendance.longitude}",
                  ),
                );
              },
            ),
    );
  }
}
