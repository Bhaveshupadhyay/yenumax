import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shawn/core/common/state/data_state.dart';
import 'package:shawn/core/common/widgets/common_btn.dart';
import 'package:shawn/core/theme/app_color.dart';
import 'package:shawn/features/dashboard/model/app_details_model.dart';
import 'package:shawn/features/dashboard/presentation/cubit/app_details_cubit.dart';
import 'package:shawn/features/payment/presentation/screens/payment_screen.dart';

class SubscriptionExpired extends StatelessWidget {
  const SubscriptionExpired({super.key});

  @override
  Widget build(BuildContext context) {
    final theme= Theme.of(context);

    return BlocBuilder<AppDetailsCubit,DataState>(
      builder: (BuildContext context, DataState state) {
        if(state is DataLoaded<AppDetailsModel>){
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                spacing: 5.h,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Subscribe to enjoy',
                    style: theme.textTheme.titleMedium,
                  ),
                  Text(state.data.appName,
                    style: theme.textTheme.titleMedium,
                  ),
                ],
              ),
              CommonBtn(
                  text: 'Subscribe',
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (builder)=>PaymentScreen()));
                  },
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryColor,
                    AppColors.orange,
                  ]
                ),
              )
            ],
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
