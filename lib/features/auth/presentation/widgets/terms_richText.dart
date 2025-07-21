import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shawn/core/common/state/data_state.dart';
import 'package:shawn/features/dashboard/model/app_details_model.dart';
import 'package:shawn/features/dashboard/presentation/cubit/app_details_cubit.dart';

import '../../../../show_webview.dart';

class TermsRichText extends StatelessWidget {
  final bool? isLogin;
  const TermsRichText({super.key, this.isLogin});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppDetailsCubit,DataState>(
      builder: (BuildContext context, DataState state) {
        return RichText(
          text: TextSpan(
              text: "By ${isLogin??false? 'logging in' : 'creating an account'}, you agree to the ${state is DataLoaded<AppDetailsModel>? state.data.appName:''}",
              style: Theme.of(context).textTheme.bodySmall,
              children: [
                TextSpan(
                    text: ' Terms of Use, '.toUpperCase(),
                    style: Theme.of(context).textTheme.bodySmall?.
                    copyWith(
                        color: Colors.blue
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap= (){
                        Navigator.push(context, MaterialPageRoute(builder: (builder)=>const ShowWebView(link: 'https://glowbal.co.uk/terms.html')));
                      }
                ),
                TextSpan(
                  text: 'acknowledge that you have read the',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                TextSpan(
                    text: ' Privacy Policy'.toUpperCase(),
                    style: Theme.of(context).textTheme.bodySmall?.
                    copyWith(
                        color: Colors.blue
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap= (){
                        Navigator.push(context, MaterialPageRoute(builder: (builder)=>const ShowWebView(link: 'https://glowbal.co.uk/privacy.html')));
                      }
                ),

                TextSpan(
                  text: ' and accept the',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                TextSpan(
                    text: ' End User License Agreement (EULA)'.toUpperCase(),
                    style: Theme.of(context).textTheme.bodySmall?.
                    copyWith(
                        color: Colors.blue
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap= (){
                        Navigator.push(context, MaterialPageRoute(builder: (builder)=>const ShowWebView(link: 'https://www.glowbal.co.uk/eula.html')));
                      }
                ),
              ]
          ),
        );
      },
    );
  }
}
