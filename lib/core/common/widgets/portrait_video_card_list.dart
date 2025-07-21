import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shawn/core/constant/content_type.dart';
import 'package:shawn/core/theme/app_color.dart';
import 'package:shawn/features/dashboard/model/content_model.dart';
import 'package:shawn/features/dashboard/model/home_contents_model.dart';

import '../../../features/about_content/presentation/screens/about_content.dart';
import 'portrait_video_card.dart';


class PortraitVideoCardList extends StatelessWidget {
  final String title;
  final List<HomeContentModel> contentList;
  final bool? isTrending;
  const PortraitVideoCardList({super.key, required this.title, required this.contentList, this.isTrending,});

  @override
  Widget build(BuildContext context) {
    final theme=Theme.of(context);

    return Column(
      spacing: 20.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(title,
            style: theme.textTheme.headlineSmall,
          ),
        ),
        SizedBox(
          height: 160.h,
          child: ListView.separated(
            itemCount: contentList.length,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context,index){
              return isTrending??false?
              SizedBox(
                width: 120.w,
                child: Stack(
                  children: [
                    Positioned(
                      left: 20.w,
                      child: SizedBox(
                        height: 150.h,
                        child: PortraitVideoCard(
                          onTap: ()=>_sendToAboutContentScreen(context: context,
                              contentId: contentList[index].contentId,
                            contentType: contentList[index].contentType
                          ),
                          posterImg: contentList[index].posterImg,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text('${index+1}',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 80.sp,
                            height: 1,
                            shadows: [
                              Shadow(
                                offset: Offset(2, 2),
                                blurRadius: 4,
                                color: AppColors.primaryColor.withValues(alpha: 0.6),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ):
              PortraitVideoCard(
                onTap: ()=>_sendToAboutContentScreen(context: context,
                    contentId: contentList[index].contentId,
                    contentType: contentList[index].contentType
                ),
                posterImg: contentList[index].posterImg,
              );
            }, separatorBuilder: (BuildContext context, int index) {
              return SizedBox(width: 20.w,);
          },
          ),
        )
      ],
    );
  }

  void _sendToAboutContentScreen({required BuildContext context, required int contentId, required int contentType})=>
      Navigator.push(context, MaterialPageRoute(builder: (builder)=>AboutContent(contentId: contentId,
          contentType: contentType)));
}
