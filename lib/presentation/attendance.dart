import 'package:attend_mobile/constant/fake_gps.dart';
import 'package:attend_mobile/constant/text_style.dart';
import 'package:attend_mobile/constant/utils/location.dart';
import 'package:attend_mobile/db_offline/database_offline.dart';
import 'package:attend_mobile/model/attendance.model.dart';
import 'package:attend_mobile/model/location.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class AddAttendance extends StatefulWidget {
  const AddAttendance({super.key});

  @override
  AddAttendanceState createState() => AddAttendanceState();
}

class AddAttendanceState extends State<AddAttendance> {
  List<Locations> locations = [];
  Locations? selectedLocation;
  Position? currentPosition;
  bool isLoadingLocation = false;
  bool isSaving = false;
  double? distance;
  Position? position;

  String stateName = "";
  String streetName = "";

  @override
  void initState() {
    super.initState();
    loadLocations();
    fetchCurrentLocation();
  }

  loadLocations() async {
    try {
      List<Map<String, dynamic>> data = await DatabaseHelper().queryAllLocations();
      setState(() {
        locations = data.map((e) => Locations(
          id: e['id'],
          name: e['name'],
          latitude: e['latitude'],
          longitude: e['longitude'],
          street: e['street'],
          state: e['state']
        )).toList();
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal mendapatkan lokasi $e")),
        );
      }
    }
  }

  fetchCurrentLocation() async {
    setState(() {
      isLoadingLocation = true;
    });
    try {
      currentPosition = await LocationUtils.getCurrentLocation(context);
      if (selectedLocation != null && currentPosition != null) {
        List<Placemark> placemarks = await placemarkFromCoordinates(
            currentPosition!.latitude, currentPosition!.longitude);
        if (placemarks.isNotEmpty) {
          Placemark placemark = placemarks[0];
          if (mounted) {
            setState(() {
              stateName = placemark.administrativeArea ?? "";
              streetName = placemark.street ?? "";
            });
          }
        }

        if (mounted) {
          distance = Geolocator.distanceBetween(
            selectedLocation!.latitude,
            selectedLocation!.longitude,
            currentPosition!.latitude,
            currentPosition!.longitude,
          );
          setState(() {});
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoadingLocation = false;
        });
      }
    }
  }

  saveAttendance() async {
    if (selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Harap pilih lokasi terlebih dahulu")),
      );
      return;
    }
    if (currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lokasi kosong")),
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      double distance = Geolocator.distanceBetween(
        selectedLocation!.latitude,
        selectedLocation!.longitude,
        currentPosition!.latitude,
        currentPosition!.longitude,
      );

      if (distance <= 50) {
        Attendance attendance = Attendance(
          locationId: selectedLocation!.id!,
          timestamp: DateTime.now(),
          latitude: currentPosition!.latitude,
          longitude: currentPosition!.longitude,
          checkoutTimestamp: null,
          street: streetName,
          state: stateName,
        );
        await DatabaseHelper().insertAttendance(attendance.toMap());
        EasyLoading.showSuccess("Berhasil attendance!");
        if (mounted) {
          Navigator.pop(context);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Jarak kamu dengan lokasi lebih dari 50M")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to save attendance: $e")),
        );
      }
    } finally {
      setState(() {
        isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Input absen"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<Locations>(
              decoration: InputDecoration(
                labelText: "Pilih lokasi",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              value: selectedLocation,
              onChanged: (Locations? newValue) {
                setState(() {
                  selectedLocation = newValue;
                  if (currentPosition != null && selectedLocation != null) {
                    distance = Geolocator.distanceBetween(
                      selectedLocation!.latitude,
                      selectedLocation!.longitude,
                      currentPosition!.latitude,
                      currentPosition!.longitude,
                    );
                  }
                });
              },
              items: locations.map((Locations location) {
                return DropdownMenuItem<Locations>(
                  value: location,
                  child: Text(location.name),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            if (selectedLocation != null)
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width / 0.9,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8.0,
                        spreadRadius: 1.0,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Detail lokasi",
                        style: largeBlackTextB.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Lokasi: ${selectedLocation!.name}",
                        style: largeBlackTextB,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Latitude: ${selectedLocation!.latitude}",
                        style: smallGreyText,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Longitude: ${selectedLocation!.longitude}",
                        style: smallGreyText,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Jalan: ${selectedLocation!.street}",
                        style: smallGreyText,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Provinsi: ${selectedLocation!.state}",
                        style: smallGreyText,
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 20),
            if (distance != null)
              Text(
                "Jarak ke lokasi yang dipilih: ${distance!.toStringAsFixed(2)} meter",
                style: largeBlackTextB,
              ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                if (position?.isMocked ?? false) { 
                  showFakeGPSAlert(context);
                } else {
                  isSaving ? null : saveAttendance(); 
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: isSaving
                  ? const CircularProgressIndicator()
                  : const Text('Absen sekarang'),
            ),
          ],
        ),
      ),
    );
  }
}
