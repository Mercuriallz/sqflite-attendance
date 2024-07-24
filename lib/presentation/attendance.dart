// ignore_for_file: use_build_context_synchronously

import 'package:attend_mobile/constant/textstyle.dart';
import 'package:attend_mobile/constant/utils/location.dart';
import 'package:attend_mobile/db_offline/database.offline.dart';
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

  String stateName = "";
  String streetName = "";

  @override
  void initState() {
    super.initState();
    loadLocations();
    fetchCurrentLocation(); // Fetch location on initialization
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal mendapatkan lokasi $e")),
      );
    }
  }

  fetchCurrentLocation() async {
    setState(() {
      isLoadingLocation = true;
    });
    try {
      currentPosition = await LocationUtils.getCurrentLocation();
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
        const SnackBar(content: Text('Please select a location.')),
      );
      return;
    }
    if (currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please get your current location first.')),
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
          street: streetName,
          state: stateName
        );
        await DatabaseHelper().insertAttendance(attendance.toMap());
        EasyLoading.showSuccess("Berhasil attendance!");
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You are more than 50 meters away from the location.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save attendance: $e')),
      );
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
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Detail lokasi", style: mediumBlackTextB,),
                    const SizedBox(height: 10),
                    Text(
                      "Lokasi: ${selectedLocation!.name}",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Latitude: ${selectedLocation!.latitude}",
                      style: smallBlackText
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Longitude: ${selectedLocation!.longitude}",
                      style: smallBlackText,
                    ),
                    const SizedBox(height: 4),
                     Text(
                      "Jalan: $streetName",
                      style: smallBlackText
                    ),
                     const SizedBox(height: 4),
                     Text(
                      "Provinsi: $stateName",
                      style: smallBlackText
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            distance != null ?
              Text(
                "Jarak ke lokasi yang dipilih: ${distance!.toStringAsFixed(2)} meter",
                style: mediumBlackTextB,
              ) : const SizedBox(),
            const Spacer(),
            ElevatedButton(
              onPressed: isSaving ? null : saveAttendance,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: isSaving
                  ? const CircularProgressIndicator()
                  : const Text('Save Attendance'),
            ),
          ],
        ),
      ),
    );
  }
}
