import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:shawn/core/common/state/data_state.dart';
import 'package:shawn/core/common/widgets/loader.dart';
import 'package:shawn/core/constant/login_device_reason_code.dart';
import 'package:shawn/core/theme/app_color.dart';
import 'package:shawn/features/payment/model/payment_model.dart';
import 'package:shawn/features/payment/presentation/cubits/payment_cubit.dart';
import 'package:shawn/features/payment/presentation/cubits/payment_link_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/utils/custom_snackbar.dart';
import '../../../subscription/presentation/cubit/subscription_cubit.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context)=> PaymentLinkCubit()..getPaymentLink()),
        BlocProvider(create: (BuildContext context)=> PaymentCubit()..connectAndRegister()),
      ],
        child: BlocListener<PaymentCubit,PaymentState>(
          listener: (context,state){
            if(state is PaymentSuccess){
              context.read<SubscriptionCubit>().getSubscription();
              LoginDeviceReasonCode.sendToPage(context: context, reasonCode: LoginDeviceReasonCode.deviceLoginSuccessful);
            }
          },
          child: Scaffold(
            body: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w,),
                    child: Row(
                      children: [
                        Expanded(child: Image.asset('assets/images/app_logo.png',height: 80.w,)),
                        Spacer(),
                        Text(
                          'HELP',
                          style: theme.textTheme.bodySmall,
                        ),
                        SizedBox(width: 20.w),
                        Text(
                          'SIGN OUT',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h,),
                  Expanded(
                    child: BlocConsumer<PaymentLinkCubit,DataState>(
                      builder: (context, state) {
                        if(state is DataLoaded<PaymentModel>){
                          return SingleChildScrollView(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Almost done!',
                                  style: theme.textTheme.headlineMedium,
                                ),
                                SizedBox(height: 25.h),
                                Text(
                                  'To activate your subscription and start streaming, please use the link below or check the email we just sent to:',
                                  style: theme.textTheme.bodyMedium,
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  state.data.email,
                                  style: theme.textTheme.titleMedium,
                                ),
                                SizedBox(height: 25.h),
                                Text(
                                  "You're only a couple of steps away from your favorite shows and movies.",
                                  style: theme.textTheme.bodyMedium,
                                ),
                                SizedBox(height: 5.h),
                                Center(child: Lottie.asset('assets/animations/web_search.json',)),
                                Text(
                                  'Paste this link in your browser to continue:',
                                  style: theme.textTheme.headlineSmall,
                                ),
                                SizedBox(height: 10.h),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        state.data.link,
                                        style: theme.textTheme.bodyMedium,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.copy, size: 20.sp),
                                      onPressed: () {
                                        Clipboard.setData(ClipboardData(text: state.data.link));
                                        CustomSnackBar.show(
                                          context: context,
                                          message: 'Link copied to clipboard',
                                          color: AppColors.green
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 25.h),
                                Center(
                                  child: TextButton.icon(
                                    icon: Icon(Icons.open_in_new, size: 20.sp),
                                    label: Text(
                                      'Open Email App',
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                    onPressed: () {
                                      _launchEmailApp(context);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        else if(state is DataLoading){
                          return Center(
                            child: const Loader(),
                          );
                        }
                        return SizedBox.shrink();
                      },
                      listener: (context, state) {  },

                    )
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }

  Future<void> _launchEmailApp(BuildContext context) async {
    final Uri emailUri = Uri(scheme: 'mailto');
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Could not open email app')),
      // );
    }
  }

}
