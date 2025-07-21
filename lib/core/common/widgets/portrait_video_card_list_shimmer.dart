import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shawn/core/common/widgets/shimmer_loader.dart';

class PortraitVideoCardListShimmer extends StatelessWidget {
  const PortraitVideoCardListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 20.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: ShimmerLoader(width: 0.4.sw,height: 25.h,),
        ),
        SizedBox(
          height: 160.h,
          child: ListView.separated(
            itemCount: 4,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context,index){
              return ShimmerLoader(
                width: 120.w,
                borderRadius: BorderRadius.circular(10.r),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(width: 20.w,);
            },
          ),
        )
      ],
    );
  }
}
