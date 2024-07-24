import 'package:flutter/material.dart';

Widget buildMenuCard({
  required VoidCallback onTap,
  required IconData icon,
  required String text,
  required TextStyle textColor,
  required Color color,
  double width = 0,
  double height = 0,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      width: width,
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 40),
          const SizedBox(height: 10),
          Text(text, style: textColor),
        ],
      ),
    ),
  );
}
