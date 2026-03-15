import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WidgetOutlinedBtn extends StatelessWidget {
  final String title;
  final IconData icon;
  const WidgetOutlinedBtn({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: Icon(icon, color: Colors.red),
        label: Text(title, style: TextStyle(color: Colors.red)),
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.red.withOpacity(0.2),
          side: const BorderSide(color: Colors.red, width: 1.5),
          fixedSize: const Size(380, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
