import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shawn/core/common/cubit/similar_cubit.dart';
import 'package:shawn/core/common/cubit/watchlist_cubit.dart';
import 'package:shawn/core/common/model/similar_content_model.dart';
import 'package:shawn/core/common/state/data_state.dart';
import 'package:shawn/core/common/widgets/common_btn.dart';
import 'package:shawn/core/common/widgets/loader.dart';
import 'package:shawn/core/constant/content_type.dart';
import 'package:shawn/core/constant/links.dart';
import 'package:shawn/core/service/network_api.dart';
import 'package:shawn/core/theme/theme.dart';
import 'package:shawn/core/utils/custom_snackbar.dart';
import 'package:shawn/features/about_content/model/episode_model.dart';
import 'package:shawn/features/about_content/presentation/cubit/content_details_cubit.dart';
import 'package:shawn/features/about_content/presentation/cubit/episodes_cubit.dart';
import 'package:shawn/features/about_content/presentation/cubit/season_cubit.dart';
import 'package:shawn/features/about_content/presentation/widgets/about_content_details_shimmer.dart';
import 'package:shawn/features/about_content/presentation/widgets/about_video_rating.dart';
import 'package:shawn/core/common/widgets/portrait_video_card.dart';
import 'package:shawn/features/about_content/presentation/widgets/season_drop_down.dart';
import 'package:shawn/core/common/widgets/landscape_video_card_with_horizontal_title.dart';
import 'package:shawn/features/about_content/presentation/widgets/similar_content_shimmer.dart';
import 'package:shawn/features/auth/presentation/screens/login.dart';
import 'package:shawn/features/dashboard/model/content_model.dart';
import 'package:shawn/features/video_play/presentation/screens/video_play_screen.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/service/token_api.dart';
import '../../../../core/theme/app_color.dart';
import '../widgets/about_video_icons.dart';

class AboutContent extends StatefulWidget {
  final int contentId;
  final int contentType;
  const AboutContent({super.key, required this.contentId, required this.contentType});

  @override
  State<AboutContent> createState() => _AboutContentState();
}

class _AboutContentState extends State<AboutContent> {
  final _scrollController= ScrollController();
  final _episodesCubit= EpisodesCubit();
  int? _seasonNumber;


  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    final theme= Theme.of(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (create)=>ContentDetailsCubit(DioApi())..loadContentById(contentId: widget.contentId, contentType: widget.contentType)),
        BlocProvider(create: (create)=>SeasonCubit()),
        BlocProvider(create: (create)=>SimilarCubit()),
        BlocProvider(create: (create)=>WatchlistCubit()),
      ],
      child: Scaffold(
          body: SafeArea(
            top: false,
            bottom: false,
            child: Stack(
              children: [
                CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: BlocConsumer<ContentDetailsCubit,DataState>(
                        builder: (BuildContext context, DataState state) {
                          if(state is DataLoaded<ContentModel>){
                            final content= state.data;
                            final genres= content.genres;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    SizedBox(
                                      height: 0.55.sh,
                                      width: double.infinity,
                                      child: CachedNetworkImage(
                                          memCacheWidth: 1000,
                                          placeholder: (context, url) => Shimmer(
                                              gradient: AppTheme.shimmerGradient(context),
                                              child: Container(
                                                color: Colors.white,
                                              )),
                                          imageUrl:  '$baseImageUrl/${content.backdropImage}',
                                          fit: BoxFit.fill,
                                          errorWidget: (context, url,x) => Shimmer(
                                              gradient: AppTheme.shimmerGradient(context),
                                              child: Container(
                                                color: Colors.white,
                                              ))
                                      ),
                                    ),
                                    Positioned.fill(
                                      child:  Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: AppColors.black.withValues(alpha: 0.9),
                                                  spreadRadius: 10,
                                                  blurRadius: 10,
                                                  offset: const Offset(0, 4), // changes position of shadow
                                                ),
                                              ]
                                          ),
                                          child: SizedBox(
                                            height: 100.h,
                                            child: Image.network('$baseImageUrl/${content.titleImage}',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 25.h,),

                                Row(
                                  spacing: 10.w,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AboutVideoRating(text: content.age,),
                                    if(content.categoryId == ContentType.webSeries)
                                      BlocBuilder<SeasonCubit,SeasonState>(
                                        builder: (BuildContext context, SeasonState state) {
                                          if(state is SeasonLoaded){
                                            return AboutVideoRating(text: '${state.totalSeasons} Seasons',);
                                          }
                                          return SizedBox.shrink();
                                        },
                                      ),
                                    AboutVideoRating(text: 'HD',),
                                    AboutVideoRating(text: content.averageRating,),
                                  ],
                                ),
                                SizedBox(height: 10.h,),
                                Center(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                        spacing: 5.w,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: List.generate(genres.length+1, (index){
                                          return  Row(
                                            spacing: 5.w,
                                            children: [
                                              Text(index==0?'${content.createdAt}' : genres[index-1],
                                                style: theme.textTheme.bodySmall,
                                              ),
                                              if(index!=genres.length)
                                                Icon(Icons.circle,size: 8.sp,color: AppColors.primaryColor,),
                                            ],
                                          );
                                        })
                                    ),
                                  ),
                                ),

                                SizedBox(height: 20.h,),
                                Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                                    child: CommonBtn(
                                      text: 'Play',
                                      onTap: (){
                                        if(TokenApi.isUserLoggedIn()){
                                          Navigator.push(context, MaterialPageRoute(builder: (builder)=>
                                              VideoPlayScreen(contentId: widget.contentId, contentType: widget.contentType,)));
                                        }
                                        else{
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
                                        }
                                      },
                                      padding: EdgeInsets.symmetric(vertical: 8.h),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20.h,),

                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      BlocConsumer<WatchlistCubit,WatchListState>(
                                        builder: (context,state){
                                          final isAddedToWatchList= state is WatchListContentUpdated? state.isAddedToWatchList : content.inWatchlist;
                                          return AboutVideoIcons(
                                              iconData: isAddedToWatchList? Icons.check : Icons.add,
                                              iconName: 'Watchlist',
                                            onTap: (){
                                               if(TokenApi.isUserLoggedIn()){
                                                 context.read<WatchlistCubit>().addToWatchList(contentId: widget.contentId, contentType: widget.contentType);
                                               }
                                               else{
                                                 Navigator.push(context, MaterialPageRoute(builder: (builder)=>Login()));
                                               }
                                            },
                                          );
                                        },
                                        listener: (context,state){
                                          if(state is WatchListContentUpdated){
                                            CustomSnackBar.show(context: context, message: '${state.isAddedToWatchList?'Added to': 'Removed from'} WatchList.'
                                            ,color: AppColors.green);
                                          }
                                        },
                                      ),
                                      AboutVideoIcons(
                                        iconData: Icons.video_collection_outlined, iconName: 'Trailer',
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (builder)=>
                                              VideoPlayScreen(contentId: widget.contentId, contentType: widget.contentType,isTrailer: true,)));
                                        },
                                      ),
                                      AboutVideoIcons(iconData: Icons.share, iconName: 'Share'),
                                    ],
                                  ),
                                ),

                                SizedBox(height: 20.h,),

                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                                  child: Text(content.description,
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ),

                                SizedBox(height: 20.h,),


                                BlocBuilder<SimilarCubit,DataState>(
                                  builder: (BuildContext context, DataState state) {
                                    if(state is DataLoaded<List<SimilarContentModel>>){
                                      final similarContents= state.data;
                                      return Column(
                                        spacing: 20.h,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                                            child: Text('More like this',
                                              style: theme.textTheme.titleMedium,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 150.h,
                                            child: ListView.builder(
                                                scrollDirection: Axis.horizontal,
                                                itemCount: similarContents.length,
                                                itemBuilder: (context,index){
                                                  return Padding(
                                                    padding: EdgeInsets.only(left: 20.w,right: index==9? 20.w:0),
                                                    child: PortraitVideoCard(
                                                      posterImg: similarContents[index].posterImage,
                                                      onTap: (){
                                                        Navigator.push(context, MaterialPageRoute(builder: (builder)=>
                                                        AboutContent(contentId: similarContents[index].contentId, contentType: similarContents[index].contentType,)));
                                                      },
                                                    ),
                                                  );
                                                }
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                    else if(state is DataLoading){
                                      return SimilarContentShimmer();
                                    }
                                    return SizedBox.shrink();
                                  },

                                ),
                                SizedBox(height: 20.h,),

                              ],
                            );
                          }
                          else if(state is DataLoading){
                            return AboutContentDetailsShimmer();
                          }
                          return SizedBox.shrink();
                        },
                        listener: (BuildContext context, DataState state) {
                          if(state is DataLoaded<ContentModel>){
                            context.read<SimilarCubit>().getSimilarContent(contentId: state.data.id, contentType: widget.contentType);
                            if(state.data.categoryId== ContentType.webSeries){
                              context.read<SeasonCubit>().getTotalSeasons(contentId: state.data.id);
                            }
                          }
                        },
                      )
                    ),
                    SliverToBoxAdapter(
                      child: BlocConsumer<SeasonCubit,SeasonState>(
                        builder: (context,state) {
                          if(state is SeasonLoaded && state.totalSeasons>0){
                            return Padding(
                              padding: EdgeInsets.only(bottom: 20.h),
                              child: Align(
                                alignment: Alignment.topLeft,
                                // child:  SingleChildScrollView(
                                //   scrollDirection: Axis.horizontal,
                                //   child: Row(
                                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //     children: List.generate(state.totalSeasons, (index)=>
                                //         Padding(
                                //           padding: EdgeInsets.only(left: 20.w, right:  index==state.totalSeasons-1? 20.w:0),
                                //           child: InkWell(
                                //             onTap: (){
                                //               _seasonNumber= index+1;
                                //             },
                                //             child: Container(
                                //               padding: EdgeInsets.symmetric(vertical: 5.h),
                                //               decoration: BoxDecoration(
                                //                   border: Border(
                                //                       bottom: BorderSide(
                                //                           width: 0==0? 2:0,
                                //                           color: AppColors.primaryColor
                                //                       )
                                //                   )
                                //               ),
                                //               child: Center(
                                //                 child: Text('Season ${index+1}',
                                //                   style: theme.textTheme.titleMedium!.copyWith(
                                //                     // color: _getColor(context,currentPage,0)
                                //                   ),
                                //                 ),
                                //               ),
                                //             ),
                                //           ),
                                //         )
                                //     ),
                                //   ),
                                // ),
                                child: SeasonDropDown(
                                    seasons: List.generate(state.totalSeasons, (index)=>'Season ${index+1}'),
                                    onChanged: (value){
                                      _seasonNumber= int.parse(value!.replaceAll('Season', ''));
                                      _episodesCubit.getEpisodes(
                                          contentId: widget.contentId,
                                          seasonNumber: _seasonNumber!,
                                          updateSeason: true
                                      );

                                    }
                                ),
                              ),
                            );
                          }
                          return SizedBox.shrink();
                        },
                        listener: (context, state) {
                          if(state is SeasonLoaded && state.totalSeasons>0){
                            _seasonNumber=1;
                            _episodesCubit.getEpisodes(contentId: widget.contentId, seasonNumber: _seasonNumber!);
                          }
                        },
                      ),
                    ),
                    BlocBuilder<EpisodesCubit,DataState>(
                      bloc: _episodesCubit,
                      builder: (BuildContext context, DataState state) {
                        if(state is DataLoaded<List<EpisodeModel>>){
                          final episodes= state.data;
                          return SliverList(
                            delegate: SliverChildBuilderDelegate(
                                  (context,index){
                                    if(index<episodes.length){
                                      final episode= episodes[index];
                                      return  Padding(
                                        padding: EdgeInsets.only(bottom: 20.h,left: 10.w,right: 10.w),
                                        child: LandscapeVideoWithHorizontalTitle(episodeId: episode.id,
                                            episodeNumber: episode.episodeNumber, thumbnail: episode.posterImage,
                                            title: '${episode.episodeNumber}. ${episode.title}', description: episode.description, duration: episode.duration,
                                        onTap: (){

                                        },),
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
                        return SliverToBoxAdapter(
                          child: SizedBox(), // or your actual content
                        );
                      },

                    ),
                    // SliverFillRemaining(
                    //   // hasScrollBody: true by default, which is correct for PageView
                    //   child: PageView.builder(
                    //     onPageChanged: (pageIndex){
                    //       print('pageIndex: $pageIndex');
                    //       _seasonNumber=pageIndex+1;
                    //       _episodesCubit.getEpisodes(contentId: widget.contentId, seasonNumber: pageIndex+1);
                    //     },
                    //     itemBuilder: (context,index)=>
                    //         EpisodesListWidget(key: ValueKey(index + 1),
                    //             episodesCubit: _episodesCubit,
                    //             contentId: widget.contentId,
                    //             seasonNumber: index+1
                    //         ),
                    //     itemCount: 2,
                    //   ),
                    // ),

                  ],
                ),
                Positioned.fill(
                  left: 20.w,
                  child:  Align(
                    alignment: Alignment.topLeft,
                    child: SafeArea(
                      child: InkWell(
                        onTap: ()=>Navigator.pop(context),
                        child: Container(
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.black.withValues(alpha: 0.6),
                                  spreadRadius: 10,
                                  blurRadius: 10,
                                  offset: const Offset(0, 4), // changes position of shadow
                                ),
                              ]
                          ),
                          child: Icon(Icons.arrow_back_ios,color: AppColors.primaryColor,),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 && _seasonNumber!=null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _episodesCubit.getEpisodes(
                contentId: widget.contentId,
                seasonNumber: _seasonNumber!,
              );
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}


