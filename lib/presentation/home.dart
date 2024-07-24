import 'package:attend_mobile/constant/card.dart';
import 'package:attend_mobile/constant/textstyle.dart';
import 'package:attend_mobile/presentation/add.location.dart';
import 'package:attend_mobile/presentation/attendance.dart';
import 'package:attend_mobile/presentation/history.attendance.dart';
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

    var isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    var screenWidth = MediaQuery.of(context).size.width;

    var totalGrid = 0;
    if(isLandscape) {
      if(screenWidth > 700) {
        totalGrid = 3;
      } else {
        totalGrid = 2;
      } 
    } else {
      totalGrid = 2;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile Attendance'),
      ),
      body: GridView.count(
        crossAxisCount: totalGrid,
        primary: false,
        shrinkWrap: true,
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
                            textColor: smallWhiteText,
                            color: const Color(0xFF1C4963),
                        
                          ),

                          buildMenuCard(
                            onTap: () {
                              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddLocation()));
            
                            },
                            icon: Icons.add,
                            text: "Tambah lokasi",
                            textColor: smallWhiteText,
                            color: const Color(0xFF1C4963),
                        
                          ),

          buildMenuCard(
                            onTap: () {
                              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AttendanceHistoryPage()));
            
                            },
                            icon: Icons.timelapse,
                            text: "Riwayat absensi",
                            textColor: smallWhiteText,
                            color: const Color(0xFF1C4963),
                        
                          ),
      
           
          
          
        ],
        ),
    );
  }
}
