import 'package:attend_mobile/constant/fake_gps.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

class LocationUtils {
  static Future<Position?> getCurrentLocation(BuildContext context) async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
          return Future.error('Location permissions are denied.');
        }
      }

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      if (position.isMocked) {
        if (context.mounted) {
          showFakeGPSAlert(context);
        }
      }

      return position;
    } catch (e) {
      return Future.error('Failed to get current location: $e');
    }
  }
}
