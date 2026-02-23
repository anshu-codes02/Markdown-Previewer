import 'package:flutter/material.dart';

Widget BuildPanel({required String title, required Widget child}){
   return Container(
     padding: EdgeInsets.all(16),
     decoration: BoxDecoration(
      color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
     ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(child: child),
        ],
      )
   );
}