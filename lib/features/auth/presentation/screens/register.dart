import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/widgets/common_textfield.dart';
import '../../../../core/constant/image_constant.dart';
import '../../../../core/constant/login_device_reason_code.dart';
import '../../../../core/service/network_api.dart';
import '../../../../core/utils/custom_snackbar.dart';
import '../../cubit/auth_cubit.dart';
import '../widgets/auth_btn.dart';
import '../widgets/bottom_rich_text.dart';
import '../widgets/terms_richText.dart';
import 'login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme= Theme.of(context);
    final textTheme= Theme.of(context).textTheme;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (create)=>PasswordCubit()),
        BlocProvider(create: (create)=>AuthCubit(api: DioApi())),
      ],
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20.h,),
              
                  Text('Hey there,',
                    style: textTheme.bodyMedium?.copyWith(
                        fontSize: 15.sp
                    ),
                  ),
                  SizedBox(height: 5.h,),
                  Text('Create an Account',
                    style: textTheme.titleMedium?.copyWith(
                        fontSize: 20.sp
                    ),
                  ),
                  SizedBox(height: 30.h,),
                  CommonTextField(
                    hintText: 'Email',
                    textEditingController: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixSvgIcon: SvgConstant.email,
                    bgColor: theme.textTheme.titleSmall?.color?.withValues(alpha: 0.15),
                  ),
                  SizedBox(height: 20.h,),
              
                  BlocBuilder<PasswordCubit,PasswordState>(
                    builder: (context,state){
                      return CommonTextField(
                        hintText: 'Password',
                        textEditingController: _passController,
                        isObscureText: state is PasswordInvisible,
                        suffixIcon: Icon(state is PasswordInvisible? Icons.visibility_off: Icons.visibility,
                          size: 22.sp,),
                        onIconTap: ()=>context.read<PasswordCubit>().toggle(),
                        keyboardType: TextInputType.text,
                        prefixSvgIcon: SvgConstant.lock,
                        bgColor: theme.textTheme.titleSmall?.color?.withValues(alpha: 0.15),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.h,horizontal: 20.w),
          child: Column(
            spacing: 20.h,
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              const TermsRichText(),

              BlocConsumer<AuthCubit,AuthState>(
                  builder: (context,state){
                   if(state is AuthLoading){
                      return const CircularProgressIndicator();
                    }
                    return SizedBox(
                      width: double.infinity,
                      child: AuthBtn(
                          text: 'Sign Up',
                          onTap: (){
                            FocusManager.instance.primaryFocus?.unfocus();
                            context.read<AuthCubit>().register(email: _emailController.text,
                                password:_passController.text);
                          }
                      ),
                    );
                  },
                listener: (context,state){
                  if(state is AuthSuccess){
                    final reasonCode= state.authModel.reasonCode;
                    LoginDeviceReasonCode.sendToPage(context: context, reasonCode: reasonCode??1);
                  }
                  else if(state is AuthFailed){
                    CustomSnackBar.show(context: context, message: state.errorMsg);
                  }
                },
              ),

              BottomRichText(
                text1: "Already have an account?",
                text2: "Log in",
                onTap: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder)=>const Login()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }
}
