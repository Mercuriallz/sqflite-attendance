import 'package:attend_mobile/constant/card.dart';
import 'package:attend_mobile/presentation/add_location.dart';
import 'package:attend_mobile/presentation/attendance.dart';
import 'package:attend_mobile/presentation/history_attendance.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Placemark? placemark;

  @override
  Widget build(BuildContext context) {
    var isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    var screenWidth = MediaQuery.of(context).size.width;

    var totalGrid = isLandscape && screenWidth > 700 ? 3 : 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mobile Attendance',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1C4963),
        elevation: 0,
      ),
      body: GridView.count(
        crossAxisCount: totalGrid,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          buildMenuCard(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddAttendance()));
            },
            icon: Icons.fingerprint,
            text: "Absensi",
            color: const Color(0xFF1C4966),
          ),
          buildMenuCard(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AddLocation()));
            },
            icon: Icons.add_location_alt_outlined,
            text: "Tambah Lokasi",
            color: const Color(0xFF1299A2),
          ),
          buildMenuCard(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AttendanceHistoryPage()));
            },
            icon: Icons.history,
            text: "Riwayat Absensi",
            color: const Color(0xFF12C8A3),
          ),
        ],
      ),
    );
  }
}
