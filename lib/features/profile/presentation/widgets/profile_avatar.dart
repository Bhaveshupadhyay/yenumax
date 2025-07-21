import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_color.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 100.w,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                AppColors.primaryColor,
                AppColors.orange,
              ]
          ),
          shape: BoxShape.circle,
          image: DecorationImage(
              image: AssetImage('assets/images/smile.png')
          )
      ),
    );
  }
}
