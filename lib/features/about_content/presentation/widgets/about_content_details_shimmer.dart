import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shawn/core/common/widgets/shimmer_loader.dart';

import '../../../../core/theme/app_color.dart';

class AboutContentDetailsShimmer extends StatelessWidget {
  const AboutContentDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [


        ShimmerLoader(height: 0.55.sh,width: double.infinity,),
        SizedBox(height: 25.h,),

        // Row(
        //   spacing: 10.w,
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     AboutVideoRating(text: content.age,),
        //     AboutVideoRating(text: '13 Seasons',),
        //     AboutVideoRating(text: 'HD',),
        //     AboutVideoRating(text: content.averageRating,),
        //   ],
        // ),
        SizedBox(height: 10.h,),
        Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                spacing: 5.w,
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index){
                  return  Row(
                    spacing: 5.w,
                    children: [
                      ShimmerLoader(width: 50.w,height: 25.h,),

                      Icon(Icons.circle,size: 8.sp,color: AppColors.primaryColor,),
                    ],
                  );
                })
            ),
          ),
        ),

        SizedBox(height: 20.h,),
        Center(
          child: ShimmerLoader(width: 50.w,height: 25.h,),
        ),
        SizedBox(height: 20.h,),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(3, (index)=>
                ShimmerLoader(width: 25.w,height: 25.h,)
            ),
          ),
        ),

        SizedBox(height: 20.h,),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: ShimmerLoader(width: double.infinity,height: 25.h,),
        ),

        SizedBox(height: 20.h,),


        // if(content.categoryId== ContentCategory.webSeries)
        //   SeasonDropDown(
        //       seasons: [
        //         'Season 1',
        //         'Season 2',
        //         'Season 3',
        //       ],
        //       onChanged: (value){
        //
        //       }
        //   ),

      ],
    );
  }
}
