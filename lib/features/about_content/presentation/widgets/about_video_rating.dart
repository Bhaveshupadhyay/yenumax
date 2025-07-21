import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shawn/core/theme/app_color.dart';

class AboutVideoRating extends StatelessWidget {
  final String text;
  const AboutVideoRating({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme= Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.h,horizontal: 10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: AppColors.primaryColor,
          width: 1
        )
      ),
      child: Text(text,
        style: theme.textTheme.bodySmall,
      ),
    );
  }
}
