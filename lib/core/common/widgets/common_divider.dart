import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shawn/core/theme/app_color.dart';

class CommonDivider extends StatelessWidget {
  final Color? color;
  final double? verticalSpacing;
  const CommonDivider({super.key, this.color, this.verticalSpacing});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: verticalSpacing?? 5.h,),
        Divider(color: color??AppColors.white.withValues(alpha: 0.2),),
        SizedBox(height: verticalSpacing??5.h,),
      ],
    );
  }
}
