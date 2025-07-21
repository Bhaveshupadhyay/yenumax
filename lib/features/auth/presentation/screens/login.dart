import 'package:shawn/core/common/widgets/common_textfield.dart';
import 'package:shawn/core/constant/login_device_reason_code.dart';
import 'package:shawn/core/service/network_api.dart';
import 'package:shawn/features/auth/presentation/screens/register.dart';

import '../../../../core/constant/image_constant.dart';
import '../../../../core/utils/custom_snackbar.dart';
import '../../cubit/auth_cubit.dart';
import '../widgets/auth_btn.dart';
import '../widgets/bottom_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../main.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

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

                  // const TopText(text1: 'Log', text2: 'In'),
                  Text('Hey there,',
                    style: textTheme.bodyMedium?.copyWith(
                        fontSize: 15.sp
                    ),
                  ),
                  SizedBox(height: 5.h,),
                  Text('Welcome Back',
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

                  SizedBox(height: 20.h,),
                  Text('Forgot your password?',
                    style: textTheme.bodySmall?.copyWith(
                        fontSize: 14.sp,
                        decoration: TextDecoration.underline
                    ),),
                  SizedBox(height: 50.h,),
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
              BlocConsumer<AuthCubit,AuthState>(
                builder: (context,state){
                  if(state is AuthLoading){
                    return const CircularProgressIndicator();
                  }
                  return AuthBtn(
                      text: 'Login',
                      width: double.infinity,
                      onTap: (){
                        FocusManager.instance.primaryFocus?.unfocus();
                        context.read<AuthCubit>().login(_emailController.text, _passController.text);
                      }
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

              // SizedBox(height: 10.h,),
              // const TermsRichText(),
              BottomRichText(
                text1: "Don't have an account?",
                text2: "Sign up",
                onTap: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder)=>const Register()));
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
