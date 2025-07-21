import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shawn/core/common/cubit/watchlist_cubit.dart';
import 'package:shawn/core/common/widgets/common_btn.dart';
import 'package:shawn/core/common/widgets/common_divider.dart';
import 'package:shawn/core/common/widgets/continue_watching.dart';
import 'package:shawn/core/common/widgets/portrait_video_card_list_shimmer.dart';
import 'package:shawn/core/service/token_api.dart';
import 'package:shawn/core/theme/app_color.dart';
import 'package:shawn/features/auth/presentation/screens/login.dart';
import 'package:shawn/features/dashboard/model/home_contents_model.dart';
import 'package:shawn/features/dashboard/presentation/screens/help_support.dart';
import 'package:shawn/features/dashboard/presentation/widgets/subscription_expired.dart';
import 'package:shawn/features/profile/presentation/screens/profile_devices.dart';
import 'package:shawn/features/subscription/presentation/cubit/subscription_cubit.dart';

import '../../../../core/common/cubit/continue_watching_cubit.dart';
import '../../../about_content/presentation/screens/about_content.dart';
import '../../../../core/common/widgets/portrait_video_card_list.dart';
import '../../../profile/presentation/cubits/device_cubit.dart';

class Account extends StatelessWidget {
  const Account({super.key});

  @override
  Widget build(BuildContext context) {
    final theme= Theme.of(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context)=>DeviceCubit()..getAllDevices(),)
      ],
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    Expanded(child: Image.asset('assets/images/app_logo.png',height: 80.w,)),
                    Spacer(),
                    InkWell(
                      onTap: ()=> Navigator.push(context,
                          MaterialPageRoute(builder: (builder)=>HelpSupport())),
                      child: Row(
                        children: [
                          Icon(Icons.settings,size: 30.sp,),
                          SizedBox(width: 5.w,),
                          Text('Help & Settings',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.h,),
              if(TokenApi.isUserLoggedIn())
                Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<SubscriptionCubit,SubscriptionState>(
                    builder: (context, state) {
                      if(state is SubscriptionLoaded){
                        if(!state.subscriptionModel.isSubActive) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: SubscriptionExpired(),
                          );
                        }
                      }
                      return SizedBox.shrink();
                    },
                  ),


                  CommonDivider(verticalSpacing: 20.h,),
                  BlocBuilder<DeviceCubit,ConnectedDeviceState>(
                    builder: (context, state) {
                      if(state is ConnectedDeviceLoaded){
                        final devices= state.connectedDevices.devices;
                        return Column(
                          spacing: 15.h,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Row(
                                children: [
                                  Text('Profiles',
                                    style: theme.textTheme.headlineSmall,
                                  ),
                                  Spacer(),
                                  InkWell(
                                    onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (builder)=>ProfileDevices())),
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit_rounded,size: 18.sp,),
                                        SizedBox(width: 5.w,),
                                        Text('Edit',
                                          style: theme.textTheme.bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 100.h,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: devices.length,
                                  itemBuilder: (context,index){
                                    return Padding(
                                      padding: EdgeInsets.only(left: 20.w, right: index==9? 20.w:0),
                                      child: Column(
                                        spacing: 8.h,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(12.r),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: devices[index].deviceId==state.myDeviceId? AppColors.white:
                                                    Colors.transparent,
                                                    width: 2
                                                ),
                                                gradient: LinearGradient(
                                                    colors:
                                                    // index==4? [
                                                    //   theme.textTheme.titleSmall?.color?.withValues(alpha: 0.3)??Colors.transparent,
                                                    //   theme.textTheme.titleSmall?.color?.withValues(alpha: 0.5)??Colors.transparent,
                                                    // ] :
                                                    [
                                                      AppColors.primaryColor,
                                                      AppColors.orange,
                                                    ]
                                                ),
                                                shape: BoxShape.circle
                                            ),
                                            child: ClipRRect(
                                              child:
                                              // index==4?
                                              // Icon(Icons.add,size: 40.w,):
                                              Image.asset('assets/images/user_avatar.png',
                                                height: 40.w,
                                                width: 40.w,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(devices[index].name??'Device ${index+1}',
                                              style: theme.textTheme.bodySmall,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  }
                              ),
                            ),
                          ],
                        );
                      }
                      return SizedBox.shrink();
                    },

                  ),
                  SizedBox(height: 20.h,),

                  BlocBuilder<WatchlistCubit, WatchListState>(
                    builder: (context,state){
                      if(state is WatchListLoaded){
                        if(state.data.isNotEmpty) {
                          return PortraitVideoCardList(
                          title: 'Watchlist',
                          contentList: state.data.map((e)=>HomeContentModel(
                              contentId: e.contentId, contentTitle: e.title, posterImg: e.posterImage, contentType: e.contentType)).toList(),
                        );
                        }
                      }
                      else if(state is WatchListLoading){
                        return PortraitVideoCardListShimmer();
                      }
                      return SizedBox.shrink();
                    },
                  ),

                  SizedBox(height: 20.h,),
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
                ],
              )
              else
                _notLoggedIn(context: context, theme: theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _notLoggedIn({required BuildContext context, required ThemeData theme})=>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/popcorn.png',
            height: 200.h,
          ),
          SizedBox(height: 24.h),
          Text(
            'Log in to start watching!',
            style: theme.textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 5.h),
          Opacity(
            opacity: 0.7,
            child: Text(
              'Pick up right where you left off and explore personalized recommendations — all in one place.',
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 32.h),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: CommonBtn(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (builder)=>Login()));
                },
                text: 'Log In',
                gradient: LinearGradient(
                    colors: [
                      AppColors.primaryColor,
                      AppColors.orange,
                    ]
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),
        ],
      );

}
