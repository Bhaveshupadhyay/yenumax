import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shawn/core/theme/app_color.dart';

class AboutVideoIcons extends StatelessWidget {
  final IconData iconData;
  final String iconName;
  final VoidCallback? onTap;
  const AboutVideoIcons({super.key, required this.iconData, required this.iconName, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme= Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Icon(iconData,size: 20.sp,color: AppColors.primaryColor,),
          Text(iconName,style: theme.textTheme.bodySmall,),
        ],
      ),
    );
  }
}
