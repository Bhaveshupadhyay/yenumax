import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/widgets/loader.dart';
import '../../../../core/theme/app_color.dart';

class AuthBtn extends StatelessWidget {

  final String text;
  final VoidCallback onTap;
  final Color? bgColor;
  final double? width;
  final bool? isLoading;

  const AuthBtn({super.key, required this.text, required this.onTap, this.bgColor, this.width, this.isLoading});

  @override
  Widget build(BuildContext context) {
    return isLoading??false?
    const Loader() :
    SizedBox(
      width: width,
      child: Material(
        elevation: 5,
        shadowColor: AppColors.orange,
        color: bgColor?? AppColors.primaryColor,
        borderRadius: BorderRadius.circular(30.r),
        child: TextButton(
          onPressed: onTap,
          style: ButtonStyle(
              // backgroundColor: WidgetStateProperty.all(bgColor?? AppColors.primaryColor),
              padding: WidgetStateProperty.all(EdgeInsets.symmetric(vertical: 20.h,horizontal: 20.w)),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  )
              ),
          ),
          child: Text(text,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontSize: 18.sp,
            ),
          ),
        ),
      ),
    );
  }
}
