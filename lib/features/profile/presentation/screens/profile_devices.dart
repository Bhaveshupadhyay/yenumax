import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shawn/core/common/widgets/loader.dart';
import 'package:shawn/core/constant/login_device_reason_code.dart';
import 'package:shawn/core/theme/app_color.dart';
import 'package:shawn/core/utils/custom_snackbar.dart';
import 'package:shawn/features/profile/presentation/cubits/device_cubit.dart';
import 'package:shawn/features/profile/presentation/screens/edit_profile_device.dart';
import 'package:shawn/features/profile/presentation/widgets/profile_avatar.dart';

import '../../../../main.dart';

class ProfileDevices extends StatelessWidget {
  final bool canAutoChangePage;
  const ProfileDevices({super.key, this.canAutoChangePage=false});

  @override
  Widget build(BuildContext context) {
    final theme= Theme.of(context);
    
    return BlocProvider(
      create: (BuildContext context)=>DeviceCubit()..getAllDevices(),
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: Column(
            spacing: kToolbarHeight,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Center(
                      child: Text('Edit Profile',
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: ()=>Navigator.pop(context),
                        child: Text('Cancel',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: AppColors.orange
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),

              Expanded(
                child: Center(
                  child: BlocConsumer<DeviceCubit,ConnectedDeviceState>(
                    builder: (context, state) {
                      if(state is ConnectedDeviceLoaded){
                        final devices= state.connectedDevices.devices;
                        return LayoutBuilder(
                            builder: (context,constraints) {
                              final width= constraints.maxWidth;
                              // final height= constraints.maxHeight;
                              final itemWidth= width/2;
                              final itemHeight= 150.w;

                              return GridView.builder(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 20.h,
                                    childAspectRatio: itemWidth/itemHeight
                                ),
                                itemBuilder: (context,index){
                                  return Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                                    child: Column(
                                      children: [
                                        Stack(
                                          children: [
                                            ProfileAvatar(),
                                            Positioned.fill(
                                              child: IconButton(
                                                onPressed: () {
                                                  Navigator.push(context, MaterialPageRoute(builder: (builder)=>EditProfileDevice(
                                                    deviceId: devices[index].deviceId,
                                                    name: devices[index].name,
                                                    updateDevices: (){
                                                      context.read<DeviceCubit>().getAllDevices();
                                                    },
                                                  )));
                                                },
                                                icon: Icon(Icons.edit),
                                                color: Colors.white,
                                                iconSize: 40.w,
                                              ),
                                            )
                                          ],
                                        ),
                                        Expanded(
                                          child: Text(devices[index].name??(devices[index].deviceId== state.myDeviceId?'My Device': 'Device ${index+1}'),
                                            style: theme.textTheme.titleMedium,
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                itemCount: devices.length,
                              );
                            }
                        );
                      }
                      else if(state is ConnectedDeviceLoading){
                        return Center(child: Loader(),);
                      }
                      return SizedBox.shrink();
                    },
                    listener: (context, state) {
                      if(state is ConnectedDeviceLoaded){
                        final connectDevices= state.connectedDevices;
                        if(canAutoChangePage){
                          if(connectDevices.reasonCode== LoginDeviceReasonCode.deviceLoginSuccessful){
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder)=>MyHomePage()),(Route<dynamic> route) => false);
                          }
                          else{
                            CustomSnackBar.show(context: context, message: state.connectedDevices.msg);
                          }
                        }
                      }
                    },

                  )
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
