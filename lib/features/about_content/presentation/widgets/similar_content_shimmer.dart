import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/widgets/shimmer_loader.dart';

class SimilarContentShimmer extends StatelessWidget {
  const SimilarContentShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: ShimmerLoader(width: double.infinity,height: 25.h,),
        ),

        SizedBox(height: 20.h,),

        SizedBox(
          height: 150.h,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (context,index){
                return Padding(
                  padding: EdgeInsets.only(left: 20.w,right: index==9? 20.w:0),
                  child: ShimmerLoader(width: 120.w,borderRadius: BorderRadius.circular(10.r),),
                );
              }
          ),
        ),
      ],
    );
  }
}
