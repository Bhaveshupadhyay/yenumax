import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shawn/core/common/model/continue_watching_model.dart';
import 'package:shawn/core/constant/links.dart';
import 'package:shawn/features/about_content/presentation/screens/about_content.dart';

import '../../theme/app_color.dart';

class ContinueWatching extends StatelessWidget {
  final String title;
  final List<ContinueWatchingModel> continueWatchingList;
  const ContinueWatching({super.key, required this.title, required this.continueWatchingList});

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
          height: 140.h,
          child: ListView.builder(
            itemCount: continueWatchingList.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context,index){
              final continueWatchingVideo =continueWatchingList[index];
              return Padding(
                padding: EdgeInsets.only(left: 20.w,right: index==9? 20.w:0),
                child: InkWell(
                  onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (builder)=>
                      AboutContent(contentId: continueWatchingVideo.contentId, contentType: continueWatchingVideo.contentType))),
                  child: SizedBox(
                    width: 180.w,
                    child: Column(
                      spacing: 5.h,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LayoutBuilder(
                          builder: (context,constraints){
                            return SizedBox(
                              height: 110.h,
                              child: Stack(
                                children: [
                                  Container(
                                    width: 180.w,
                                    height: 110.h,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.r),
                                        image: DecorationImage(
                                            image: NetworkImage('$baseImageUrl/${continueWatchingVideo.backdropImage}',
                                            ),
                                            fit: BoxFit.cover
                                        )
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Column(
                                        spacing: 2.h,
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Icon(Icons.play_arrow,color: AppColors.white,),
                                          Container(
                                            width: continueWatchingVideo.progressPercent * constraints.maxWidth,
                                            height: 3.h,
                                            decoration: BoxDecoration(
                                              color: AppColors.videoProgress,
                                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.r),
                                                  bottomRight: Radius.circular(10.r)),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        Expanded(
                          child: Text('${continueWatchingVideo.title} hdiuwedwfwyfbwfw fwgfuywgfyuwgfuwfuytftwuftu',
                            style: theme.textTheme.titleSmall,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              );
            },
          ),
        )
      ],
    );
  }
}
