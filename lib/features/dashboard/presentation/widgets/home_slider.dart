import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shawn/core/constant/links.dart';
import 'package:shawn/features/about_content/presentation/screens/about_content.dart';
import 'package:shawn/features/dashboard/model/slider_model.dart';

import '../../../../core/common/widgets/shimmer_loader.dart';
import '../../../../core/theme/app_color.dart';

class HomeSlider extends StatelessWidget {
  final List<SliderModel> sliders;
  const HomeSlider({super.key, required this.sliders});

  @override
  Widget build(BuildContext context) {
    final theme= Theme.of(context);

    return CarouselSlider.builder(
        itemCount: sliders.length,
        itemBuilder: (itemBuilder,index,i){
          return SizedBox(
              width: double.infinity,
              // color: Colors.black,
              // height: 350,
              child: InkWell(
                onTap: ()=>Navigator.push(context,MaterialPageRoute(builder: (builder)=>
                    AboutContent(contentId: sliders[index].id,contentType: sliders[index].type,))),
                  child: Stack(
                    children: [
                      SizedBox(
                        height: double.infinity,
                        width: double.infinity,
                        child: CachedNetworkImage(
                            memCacheWidth: 1000,
                            placeholder: (context, url) => ShimmerLoader(),
                            imageUrl:  '$baseImageUrl/${sliders[index].posterImage}',
                            fit: BoxFit.fill,
                            errorWidget: (context, url,x) => ShimmerLoader()
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.black.withValues(alpha: 0.9),
                                    spreadRadius: 10,
                                    blurRadius: 10,
                                    offset: const Offset(0, 4), // changes position of shadow
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.only(bottom: 5.h),
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        text: sliders[index].title.toUpperCase(),
                                        style: theme.textTheme.titleMedium,
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 3.h,),
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                                    child: ElevatedButton.icon(
                                        onPressed: null,
                                        style: ButtonStyle(
                                            backgroundColor: WidgetStateProperty.all(AppColors.primaryColor),
                                            elevation: WidgetStateProperty.all(20),
                                            padding: WidgetStateProperty.all(EdgeInsets.symmetric(vertical: 4.h))

                                        ),
                                        icon: Icon(Icons.play_arrow,color: AppColors.black,size: 20.sp,),
                                        label: Text('Play',style: theme.textTheme.titleMedium?.copyWith(color: AppColors.black),)
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )
              )
          );
        },
        options: CarouselOptions(
            initialPage: 2,
            autoPlay: true,
            viewportFraction: 1,
            aspectRatio: 1.sw/0.4.sh
        )
    );
  }
}
