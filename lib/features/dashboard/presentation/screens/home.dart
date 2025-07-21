import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shawn/core/common/cubit/continue_watching_cubit.dart';
import 'package:shawn/core/common/state/data_state.dart';
import 'package:shawn/core/common/widgets/continue_watching.dart';
import 'package:shawn/core/common/widgets/portrait_video_card_list_shimmer.dart';
import 'package:shawn/core/common/widgets/shimmer_loader.dart';
import 'package:shawn/core/service/network_api.dart';
import 'package:shawn/core/service/token_api.dart';
import 'package:shawn/core/theme/app_color.dart';
import 'package:shawn/features/dashboard/model/home_contents_model.dart';
import 'package:shawn/features/dashboard/model/slider_model.dart';
import 'package:shawn/features/dashboard/presentation/cubit/home_cubit.dart';
import 'package:shawn/features/dashboard/presentation/cubit/slider_cubit.dart';
import 'package:shawn/features/dashboard/presentation/widgets/home_slider.dart';
import '../../../about_content/presentation/screens/about_content.dart';

import '../../../../core/common/widgets/portrait_video_card_list.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _scrollController= ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<SliderCubit>().getSlider();
    context.read<HomeCubit>().loadHome();
    context.read<ContinueWatchingCubit>().loadContinueWatching();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<HomeCubit>().loadHome();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme=Theme.of(context);

    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        spacing: 35.h,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<SliderCubit,DataState>(
            builder: (BuildContext context, DataState state) {
              if(state is DataLoaded<List<SliderModel>>){
                return HomeSlider(sliders: state.data);
              }
              else if(state is DataLoading){
                return ShimmerLoader(width: double.infinity,height: 0.4.sh,);
              }
              return SizedBox.shrink();
            },
          ),

          if(TokenApi.isUserLoggedIn())
            BlocBuilder<ContinueWatchingCubit,ContinueWatchingState>(
              builder: (context,state){
                if(state is ContinueWatchingLoaded){
                  if(state.data.isNotEmpty){
                    return ContinueWatching(
                      title: 'Continue Watching',
                      continueWatchingList: state.data,
                    );
                  }
                }
                return SizedBox.shrink();
              },
            ),
          BlocBuilder<HomeCubit,DataState>(
            builder: (BuildContext context, DataState state) {
              if(state is DataLoaded<List<HomeContentsModel>>){
                return Column(
                  spacing: 35.h,
                  children: List.generate(state.data.length+ (state.isLoadingMore? 1:0), (index){
                    if(index< state.data.length){
                      final content= state.data[index];
                      return PortraitVideoCardList(
                        title: content.title,
                        contentList: content.items,
                        isTrending: content.isTrending,
                      );
                    }
                    else{
                      return PortraitVideoCardListShimmer();
                    }
                  }),
                );
              }
              else if(state is DataLoading){
                return PortraitVideoCardListShimmer();
              }
              return SizedBox.shrink();
            },

          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
