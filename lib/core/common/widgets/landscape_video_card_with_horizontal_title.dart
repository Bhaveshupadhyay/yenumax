import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shawn/core/common/widgets/shimmer_loader.dart';
import 'package:shawn/core/constant/links.dart';

import '../../../utils/convert_utils.dart';

class LandscapeVideoWithHorizontalTitle extends StatelessWidget {
  final int episodeId;
  final int episodeNumber;
  final String thumbnail;
  final String title;
  final String description;
  final int duration;
  final VoidCallback? onTap;

  const LandscapeVideoWithHorizontalTitle({
    super.key, this.onTap,
    required this.episodeNumber,
    required this.thumbnail,
    required this.title,
    required this.description,
    required this.duration, required this.episodeId,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: CachedNetworkImage(
                  memCacheWidth: 300,
                  fit: BoxFit.fill,
                  height: 90.h,
                  width: 120.w,
                  // memCacheHeight: 200,
                  placeholder: (context, url){
                    return ShimmerLoader(borderRadius: BorderRadius.only(topLeft: Radius.circular(10.r),
                    topRight: Radius.circular(10.r)));
                  },
                  errorWidget: (context,s,d){
                    return ShimmerLoader(borderRadius: BorderRadius.only(topLeft: Radius.circular(10.r),
                        topRight: Radius.circular(10.r)));
                  },
                  imageUrl: '$baseImageUrl/$thumbnail',
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(10.r)),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 2.h,horizontal: 5.w),
                    child: Text(ConvertUtils.formatDuration(duration),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(width: 20.w,),
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(description,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              )
          )
        ],
      ),
    );
  }

}
