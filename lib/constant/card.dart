import 'package:attend_mobile/constant/text_style.dart';
import 'package:flutter/material.dart';

Widget buildMenuCard({
  required VoidCallback onTap,
  required IconData icon,
  required String text,
  TextStyle? textStyle,
  required Color color,
  double width = 0,
  double height = 0,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      width: width,
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 40),
          const SizedBox(height: 12),
          Text(
            text,
            style: largeWhiteText,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
