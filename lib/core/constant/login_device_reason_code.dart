import 'package:flutter/material.dart';
import 'package:shawn/features/payment/presentation/screens/payment_screen.dart';
import 'package:shawn/features/profile/presentation/screens/profile_devices.dart';

import '../../main.dart';

class LoginDeviceReasonCode{
  static const Map<int, String> _reasonCode = {
    1: 'Successful!',
    2: 'Device limit reached for your current plan. Remove a device to continue watching.',
    3: 'You can\'t remove the currently logged in device, try removing another device.',
    4: 'No active plan found.',
  };

  static String getMessage(int code) {
    return _reasonCode[code] ?? 'Unknown reason code';
  }

  static const int deviceLoginSuccessful=1;
  static const int deviceLimitReached=2;
  static const int cannotRemoveDevice=3;
  static const int noActivePlan=4;

  static sendToPage({required BuildContext context,required int reasonCode}){
    if(reasonCode== deviceLoginSuccessful){
      _navigateToPage(context: context, page: MyHomePage());
    }
    else if(reasonCode== deviceLimitReached){
      _navigateToPage(context: context, page: ProfileDevices(canAutoChangePage: true,));
    }
    // else if(reasonCode== noMultipleDeviceSupport){
    //   _navigateToPage(context: context, page: ProfileDevices());
    // }
    else if(reasonCode== noActivePlan){
      _navigateToPage(context: context, page: PaymentScreen());
    }
  }

  static void _navigateToPage({required BuildContext context,required Widget page}){
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder)=>page),(Route<dynamic> route) => false);
  }
}