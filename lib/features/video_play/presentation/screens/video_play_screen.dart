import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:shawn/core/common/state/data_state.dart';
import 'package:shawn/core/common/widgets/loader.dart';
import 'package:shawn/features/video_play/model/video_quality_model.dart';
import 'package:shawn/features/video_play/presentation/cubits/video_link_cubit.dart';

import '../../../quality_player/cubit/player_cubit.dart';
import '../../../quality_player/src/quality_player.dart';
import '../../model/video_model.dart';

class VideoPlayScreen extends StatefulWidget {
  final int contentId;
  final int contentType;
  final bool isTrailer;

  const VideoPlayScreen({super.key, required this.contentId,required this.contentType, this.isTrailer=false});

  @override
  State<VideoPlayScreen> createState() => _VideoPlayScreenState();
}

class _VideoPlayScreenState extends State<VideoPlayScreen> {


  @override
  void initState() {
    super.initState();
    if(widget.isTrailer) {
      context.read<VideoLinkCubit>().getTrailer(contentId: widget.contentId, contentType: widget.contentType);
    }
    else{
      context.read<VideoLinkCubit>().getVideo(contentId: widget.contentId, contentType: widget.contentType);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<VideoLinkCubit,DataState>(
        builder: (context,state) {
          if(state is DataLoaded<List<VideoQualityModel>> || state is DataLoaded<VideoModel>){
            List<VideoQualityModel> videoQualities=[];
            if(state is DataLoaded<List<VideoQualityModel>>){
              videoQualities=state.data;
            }
            else if(state is DataLoaded<VideoModel>){
              videoQualities=state.data.videoQualities;
            }

            if(videoQualities.isNotEmpty) {
              return QualityPlayer(
              link: videoQualities[videoQualities.length-1].link,
              videoQualities: videoQualities.map((video)=>
                  VideoQuality(quality: video.resolution,
                      link: video.link)).toList(),
              alwaysLandscape: true,
            );
            }
          }
          else if(state is DataLoading){
            return SafeArea(
              child: SizedBox(
                height: 0.25.sh,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: ()=>
                        Navigator.pop(context),
                        child: Icon(Icons.close)
                    ),
                    Expanded(
                      child: Center(
                        child: Loader(),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
          return SafeArea(
            child: SizedBox(
              height: 0.25.sh,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                      onTap: ()=>
                          Navigator.pop(context),
                      child: Icon(Icons.close)
                  ),
                  Expanded(
                    child: Center(
                      child: Loader(),
                    ),
                  )
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}
