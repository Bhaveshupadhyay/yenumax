import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_color.dart';

class CommonBtn extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final EdgeInsets? padding;
  final Color? fillColor;
  final Gradient? gradient;
  const CommonBtn({super.key, required this.text, required this.onTap, this.padding, this.fillColor, this.gradient});

  @override
  Widget build(BuildContext context) {
    final theme= Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: padding?? EdgeInsets.symmetric(vertical: 8.h,horizontal: 20.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
                color: AppColors.primaryColor,
                width: 1
            ),
          color: fillColor,
          gradient: gradient
        ),
        child: Center(
          child: Text(text,
            style: theme.textTheme.titleMedium,
          ),
        ),
      ),
    );
  }
}
