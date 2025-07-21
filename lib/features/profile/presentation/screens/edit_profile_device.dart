import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shawn/core/common/widgets/common_textfield.dart';
import 'package:shawn/core/utils/custom_snackbar.dart';
import 'package:shawn/features/profile/presentation/cubits/device_cubit.dart';
import 'package:shawn/features/profile/presentation/widgets/profile_avatar.dart';

import '../../../../core/common/widgets/loader.dart';
import '../../../../core/theme/app_color.dart';

class EditProfileDevice extends StatefulWidget {
  final String? name;
  final String deviceId;
  final void Function() updateDevices;
  const EditProfileDevice({super.key, this.name, required this.deviceId, required this.updateDevices,});

  @override
  State<EditProfileDevice> createState() => _EditProfileDeviceState();
}

class _EditProfileDeviceState extends State<EditProfileDevice> {

  final _nameController= TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if(widget.name!=null){
      _nameController.text= widget.name!;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme= Theme.of(context);

    return BlocProvider(
      create: (BuildContext context)=>DeviceCubit(),
      child: BlocConsumer<DeviceCubit,ConnectedDeviceState>(
        listener: (context, state) {
          if(state is ConnectedDeviceFailedToUpdateDetails){
            CustomSnackBar.show(context: context, message: state.failure.msg??'Error');
          }
          else if(state is ConnectedDeviceFailedToDelete){
            CustomSnackBar.show(context: context, message: state.failure.msg??'Error');
          }
          else if(state is ConnectedDeviceDetailsUpdated || state is ConnectedDeviceDetailsDeleted){
            widget.updateDevices();
            Navigator.pop(context);
          }
        },
        builder: (context,state){
          return Scaffold(
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
                        if(Navigator.canPop(context))
                          Align(
                            alignment: Alignment.centerLeft,
                            child: InkWell(
                                onTap: ()=>Navigator.pop(context),
                                child: Icon(Icons.arrow_back_ios,size: 20.sp,)
                            ),
                          ),
                        Center(
                          child: Text('Edit Profile',
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: state is ConnectedDeviceDetailsDeleting?
                          Loader():
                          InkWell(
                            onTap: (){
                              if(state is! ConnectedDeviceDetailsUpdating || state is! ConnectedDeviceDetailsUpdated){
                                context.read<DeviceCubit>().removeDevice(deviceId: widget.deviceId);
                              }
                            },
                            child: Text('Delete',
                              style: theme.textTheme.titleSmall?.copyWith(
                                  color: AppColors.red
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),

                  ProfileAvatar(),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: CommonTextField(
                      focusNode: _focusNode,
                      hintText: 'Profile Name',
                      textEditingController: _nameController,
                      keyboardType: TextInputType.text,
                      bgColor: theme.textTheme.titleSmall?.color?.withValues(alpha: 0.15),
                    ),
                  )

                ],
              ),
            ),
            floatingActionButton: state is ConnectedDeviceDetailsUpdating?
              Loader():
              GradientFab(
              onPressed: (){
                context.read<DeviceCubit>().updateDeviceDetails(deviceName: _nameController.text, deviceId: widget.deviceId);
              },
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}

class GradientFab extends StatelessWidget {
  final VoidCallback onPressed;

  const GradientFab({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56.w,
      height: 56.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor, // you can customize these
            AppColors.orange, // you can customize these
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent, // let gradient show through
        shape: CircleBorder(),
        child: InkWell(
          customBorder: CircleBorder(),
          onTap: onPressed,
          child: Center(
            child: Icon(
              Icons.check,
              color: Colors.white,
              size: 28.sp,
            ),
          ),
        ),
      ),
    );
  }
}

