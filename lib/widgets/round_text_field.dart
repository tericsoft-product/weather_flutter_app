import 'package:flutter/material.dart';

import '/constants/app_colors.dart';

class RoundTextField extends StatelessWidget {
  const RoundTextField({
    super.key,
    this.controller,
  });

  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: AppColors.accentBlue,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextField(
        style: const TextStyle(
          color: AppColors.white,
        ),
        controller: controller,
        decoration: InputDecoration(
          fillColor: Colors.white,
          focusColor: Colors.white,
          prefixIcon: Padding(
            padding: const EdgeInsets.all(16.0), // Adjust padding as needed
            child: Icon(
              Icons.search,
              color: AppColors.grey,
            ),
          ),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: const TextStyle(
            color: AppColors.grey,
            fontWeight: FontWeight.w400,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 15.0), // Center vertically
        ),
      ),
    );
  }
}
