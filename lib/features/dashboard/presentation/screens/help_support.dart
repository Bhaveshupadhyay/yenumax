import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shawn/core/common/state/data_state.dart';
import 'package:shawn/core/common/widgets/common_app_bar.dart';
import 'package:shawn/core/common/widgets/common_divider.dart';
import 'package:shawn/core/service/token_api.dart';
import 'package:shawn/core/theme/app_color.dart';
import 'package:shawn/features/dashboard/model/app_details_model.dart';
import 'package:shawn/features/dashboard/presentation/cubit/app_details_cubit.dart';
import 'package:shawn/features/dashboard/presentation/widgets/logout_bottom_sheet.dart';
import 'package:shawn/features/subscription/presentation/cubit/subscription_cubit.dart';
import 'package:shawn/features/subscription/presentation/screens/subscription_page.dart';
import 'package:shawn/main.dart';

class HelpSupport extends StatelessWidget {
  const HelpSupport({super.key});

  @override
  Widget build(BuildContext context) {
    final theme= Theme.of(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (create)=>AppDetailsCubit()..loadAppData())
      ],
      child: Scaffold(
        appBar: CommonAppBar(
          title: 'Help & Support',
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h,horizontal: 20.w),
            child: Column(
              children: [
                if(TokenApi.isUserLoggedIn())
                  BlocBuilder<SubscriptionCubit,SubscriptionState>(
                    builder: (context, state) {
                      if(state is SubscriptionLoaded){
                        if(state.subscriptionModel.isSubActive) {
                          return Column(
                            children: [
                              _setting(
                                  icon: Icons.person_2_rounded,
                                  title: 'Subscription',
                                  subTitle: 'Subscription Details & Device Manager',
                                  theme: theme,
                                onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (builder)=>SubscriptionPage(
                                        subscription: state.subscriptionModel,
                                        onCancel: (){

                                        }))
                                    );
                                }
                              ),
                              CommonDivider(verticalSpacing: 10.h,),
                            ],
                          );
                        }
                      }
                      return SizedBox.shrink();
                    },
                  ),

                _setting(
                    icon: Icons.question_mark_rounded,
                    title: 'Help & Support',
                    subTitle: 'Help Center',
                    theme: theme
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BlocBuilder<AppDetailsCubit,DataState>(
          builder: (context,state) {
            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if(TokenApi.isUserLoggedIn())
                    InkWell(
                    onTap: (){
                      showLogoutBottomSheet(
                          context: context,
                          onLogout: () async {
                            await TokenApi().deleteCookie();
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder)=>const MyHomePage()),(Route<dynamic> route) => false);
                          },
                          theme: theme
                      );
                    },
                    child: Text('Log Out',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.primaryColor
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h,),
                  Row(
                    spacing: 10.w,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Privacy Policy',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.textTheme.titleSmall?.color?.withValues(alpha: 0.6),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Icon(Icons.circle, size: 5.sp,),
                      Text('Subscriber Agreement',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.textTheme.titleSmall?.color?.withValues(alpha: 0.6),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h,),
                  if(state is DataLoaded<AppDetailsModel>)
                    Text('App Version ${state.data.version}',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.textTheme.titleSmall?.color?.withValues(alpha: 0.6),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                ],
              ),
            );
          }
        )
      ),
    );
  }

  Widget _setting({required IconData icon, required String title,
    required String subTitle,VoidCallback? onTap,required ThemeData theme})=>
      InkWell(
        onTap: onTap,
        child: Row(
          spacing: 10.w,
          children: [
            Icon(icon),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                    style: theme.textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(subTitle,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.textTheme.titleSmall?.color?.withValues(alpha: 0.6),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios,size: 20.sp,)
          ],
        ),
      );
}
