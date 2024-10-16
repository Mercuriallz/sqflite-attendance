import 'package:attend_mobile/constant/text_style.dart';
import 'package:attend_mobile/constant/utils/location.dart';
import 'package:attend_mobile/db_offline/database_offline.dart';
import 'package:attend_mobile/model/location.model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class AddLocation extends StatefulWidget {
  const AddLocation({super.key});

  @override
  AddLocationState createState() => AddLocationState();
}

class AddLocationState extends State<AddLocation> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();

  Position? currentPosition;
  String stateName = "";
  String streetName = "";
  String locationError = "";

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    EasyLoading.show(status: "Mohon tunggu... sedang mengambil koordinat lokasi anda");
    try {
      currentPosition = await LocationUtils.getCurrentLocation();
      if (currentPosition != null) {
        if (kDebugMode) {
          print("Current pos ==>>>: ${currentPosition!.latitude}, ${currentPosition!.longitude}");
        }
        List<Placemark> placemarks = await placemarkFromCoordinates(
            currentPosition!.latitude, currentPosition!.longitude);
        if (placemarks.isNotEmpty) {
          Placemark placemark = placemarks[0];
          setState(() {
            stateName = placemark.administrativeArea ?? "";
            streetName = placemark.street ?? "";
            locationError = "";
          });
          if (kDebugMode) {
            print("Placemark: ${placemark.toJson()}");
          }
        } else {
          setState(() {
            locationError = "Data kosong.";
          });
        }
      }
    } catch (e) {
      setState(() {
        locationError = e.toString();
      });
      if (kDebugMode) {
        print("Error fetching location: $locationError");
      }
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> saveLocation() async {
    if (currentPosition != null && formKey.currentState!.validate()) {
      Locations location = Locations(
        name: nameController.text,
        latitude: currentPosition!.latitude,
        longitude: currentPosition!.longitude,
        street: streetName,
        state: stateName,
      );
      await DatabaseHelper().insertLocation(location.toMap());
      EasyLoading.showSuccess("Berhasil menambahkan lokasi", duration: const Duration(seconds: 3));

     if(mounted) {
       Navigator.pop(context);
     }
    }
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Tambah Lokasi"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Nama Lokasi",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Masukkan nama lokasi",
                ),
                validator: (v) {
                  if (v!.isEmpty) {
                    return "This field is required";
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 16),
              if (currentPosition != null)
                Center( // Center the card
                  child: Container(
                    width: MediaQuery.of(context).size.width / 0.9,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8.0,
                          spreadRadius: 1.0,
                          offset:  Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "* Informasi lokasi",
                          style: smallBlackTextB,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Latitude: ${currentPosition!.latitude}",
                          style: smallBlackText,
                        ),
                        Text(
                          "Longitude: ${currentPosition!.longitude}",
                          style: smallBlackText,
                        ),
                        Text(
                          "Jalan: $streetName",
                          style: smallBlackText,
                        ),
                        Text(
                          "Provinsi: $stateName",
                          style: smallBlackText,
                        ),
                      ],
                    ),
                  ),
                ),
              if (locationError.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    locationError,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const Spacer(),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: saveLocation,
                child: const Text("Simpan Lokasi"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
