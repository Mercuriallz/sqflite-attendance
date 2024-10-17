import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void showFakeGPSAlert(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, 
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Fake GPS terdeteksi"),
        content: const Text(
          "Sepertinya kamu menggunakan aplikasi fake GPS, matikan terlebih dahulu sebelum kamu ingin menggunakan aplikasi",
        ),
        actions: [
          TextButton(
            onPressed: () {
              
              SystemNavigator.pop();
            },
            child: const Text('Tutup'),
          ),
        ],
      );
    },
  );
}
