import 'package:attend_mobile/db_offline/database_offline.dart';
import 'package:attend_mobile/model/attendance.model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 

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

    final locationIds = data.map((entry) => entry['locationId'] as int).toSet();
    final locationDataList = await Future.wait(
      locationIds.map((id) => DatabaseHelper().getLocationById(id)),
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
        state: e['state'],
      )).toList();
      this.locationNames = locationNames;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Riwayat Absensi"),
      ),
      body: attendances.isEmpty
          ? const Center(child: Text("Belum ada riwayat absensi."))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: attendances.length,
                itemBuilder: (context, i) {
                  final attendance = attendances[i];
                  final locationName = locationNames[attendance.locationId] ?? "Lokasi tidak diketahui";
                  final formattedDate = DateFormat('dd MMM yyyy, HH:mm').format(attendance.timestamp);

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Attendance #${attendance.id}",
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Alamat: ${attendance.street}",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Lokasi: $locationName",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Tanggal: $formattedDate",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Latitude: ${attendance.latitude}, Longitude: ${attendance.longitude}",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
