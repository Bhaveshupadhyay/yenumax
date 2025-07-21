import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/state/data_state.dart';
import '../../../../core/common/widgets/landscape_video_card_with_horizontal_title.dart';
import '../../../../core/common/widgets/loader.dart';
import '../../model/episode_model.dart';
import '../cubit/episodes_cubit.dart';

class EpisodesListWidget extends StatelessWidget {
  final int contentId;
  final int seasonNumber;
  final EpisodesCubit episodesCubit;
  const EpisodesListWidget({super.key, required this.contentId, required this.seasonNumber, required this.episodesCubit});

  @override
  Widget build(BuildContext context) {
    print(seasonNumber);
    return BlocBuilder<EpisodesCubit,DataState>(
      bloc: episodesCubit,
      builder: (BuildContext context, DataState state) {
        print(state);
        if(state is DataLoaded<List<EpisodeModel>>){
          final episodes= state.data;
          return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context,index){
              if(index<episodes.length){
                final episode= episodes[index];
                return  Padding(
                  padding: EdgeInsets.only(bottom: 20.h,left: 10.w,right: 10.w),
                  child: LandscapeVideoWithHorizontalTitle(episodeId: episode.id,
                      episodeNumber: episode.episodeNumber, thumbnail: episode.posterImage,
                      title: '${episode.episodeNumber}. ${episode.title}', description: episode.description, duration: episode.duration),
                );
              }
              else{
                return Center(
                  child: Loader(),
                );
              }
            },
            itemCount: episodes.length + (state.isLoadingMore?1:0),
          );
          return SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context,index){
                if(index<episodes.length){
                  final episode= episodes[index];
                  return  Padding(
                    padding: EdgeInsets.only(bottom: 20.h,left: 10.w,right: 10.w),
                    child: LandscapeVideoWithHorizontalTitle(episodeId: episode.id,
                        episodeNumber: episode.episodeNumber, thumbnail: episode.posterImage,
                        title: '${episode.episodeNumber}. ${episode.title}', description: episode.description, duration: episode.duration),
                  );
                }
                else{
                  return Center(
                    child: Loader(),
                  );
                }
              },
              childCount: episodes.length + (state.isLoadingMore?1:0),
            ),
          );
        }
        return SizedBox.shrink();
      },

      // buildWhen: (oldState, currentState){
      //   if(currentState is DataLoaded<List<EpisodeModel>> && currentState.)
      // },
    );
  }
}
