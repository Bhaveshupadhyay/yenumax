import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shawn/core/common/state/data_state.dart';
import 'package:shawn/core/common/widgets/common_textfield.dart';
import 'package:shawn/core/constant/content_type.dart';
import 'package:shawn/core/constant/links.dart';
import 'package:shawn/core/theme/app_color.dart';
import 'package:shawn/features/dashboard/model/search_model.dart';
import 'package:shawn/features/dashboard/presentation/cubit/pageview_cubit.dart';
import 'package:shawn/features/dashboard/presentation/cubit/search_cubit.dart';
import '../../../../core/common/widgets/shimmer_loader.dart';
import '../../../about_content/presentation/screens/about_content.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _searchTextController= TextEditingController();
  final _pageController= PageController();

  @override
  Widget build(BuildContext context) {
    final theme= Theme.of(context);

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          RPadding(
            padding: const EdgeInsets.all(10),
            child: CommonTextField(
                hintText: 'Search...',
                textEditingController: _searchTextController,
                keyboardType: TextInputType.text,
              bgColor: theme.textTheme.titleSmall?.color?.withValues(alpha: 0.2),
              prefixIcon: Icon(Icons.search,size: 20.sp,),
              borderRadius: BorderRadius.circular(15.r),
              contentPadding: EdgeInsets.symmetric(vertical: 5.h,horizontal: 10.w),
              onTextChanged: (q){
                  context.read<SearchCubit>().search(q: q);
              },
            ),
          ),

          BlocBuilder<PageViewCubit,int>(
            builder: (context, currentIndex){
              try{
                _pageController.animateToPage(
                  currentIndex,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
              catch(e){}
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        context.read<PageViewCubit>().animatePage(_pageController,0);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5.h),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: currentIndex==0? 2:0,
                                    color: AppColors.primaryColor
                                )
                            )
                        ),
                        child: Center(
                          child: Text('Videos',
                            style: theme.textTheme.titleMedium!.copyWith(
                              // color: _getColor(context,currentPage,0)
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        context.read<PageViewCubit>().animatePage(_pageController,1);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5.h),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: currentIndex==1? 2:0,
                                    color: AppColors.primaryColor
                                )
                            )
                        ),
                        child: Center(
                          child: Text('Collections',
                            style: theme.textTheme.titleMedium!.copyWith(
                              // color: _getColor(context,currentPage,1)
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              );
            },
          ),

          Expanded(
            child: BlocBuilder<SearchCubit,DataState>(
              builder: (BuildContext context, DataState state) {
                if(state is DataLoaded<SearchModel>){
                  final videoList= state.data.videos;
                  final collectionList= state.data.collections;
                  return PageView(
                    controller: _pageController,

                    onPageChanged: (index){
                      context.read<PageViewCubit>().pageChanged(index);
                    },
                    children: [
                      _videoList(list: videoList),
                      _collectionList(list: collectionList)
                    ],
                  );
                }
                return SizedBox.shrink();

              },

            ),
          )
        ],
      ),
    );
  }

  Widget _videoCard({required int contentId, required String thumbnail, required String title,
    int? seasonNumber, required int contentType})=>
      InkWell(
        onTap: (){
          if(contentType==ContentType.movie || contentType==ContentType.webSeries){
            Navigator.push(context, MaterialPageRoute(builder: (builder)=>AboutContent(contentId: contentId, contentType: contentType)));
          }
          else{

          }
        },
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 10.w),
            child: Row(
              spacing: 20.w,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: CachedNetworkImage(
                    memCacheWidth: 300,
                    fit: BoxFit.fill,
                    height: 90.h,
                    width: 120.w,
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if(seasonNumber!=null)
                      Opacity(
                        opacity: 0.5,
                        child: Text(
                          'Season $seasonNumber',
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
        ),
      );


  Widget _videoList({required List<VideoContentModel> list})=>
      ListView.builder(
          itemCount: list.length,
          itemBuilder: (context,index){
            final video= list[index];
            return _videoCard(contentId: video.id, thumbnail: video.backdropImage, title: video.title,seasonNumber: video.seasonNumber, contentType: video.type);
          }
      );

  Widget _collectionList({required List<CollectionContentModel> list})=>
      ListView.builder(
          itemCount: list.length,
          itemBuilder: (context,index){
            final video= list[index];
            return _videoCard(contentId: video.id, thumbnail: video.backdropImage, title: video.title, contentType: video.type);
          }
      );

  @override
  void dispose() {
    _searchTextController.dispose();
    _pageController.dispose();
    super.dispose();
  }
}
