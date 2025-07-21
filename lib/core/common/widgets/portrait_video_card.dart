import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shawn/core/constant/links.dart';

class PortraitVideoCard extends StatelessWidget {
  final String posterImg;
  final VoidCallback? onTap;
  final double? width;
  const PortraitVideoCard({super.key, this.onTap, this.width, required this.posterImg});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width??120.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          image: DecorationImage(
            image: NetworkImage('$baseImageUrl/$posterImg',),
            fit: BoxFit.fill
          )
        ),
      ),
    );
  }
}
