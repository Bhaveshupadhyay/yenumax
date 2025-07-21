import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class DeviceDetails{
  static final _info = DeviceInfoPlugin();
  
  static Future<String?> getDeviceId() async {

    if (Platform.isAndroid) {
      final android = await _info.androidInfo;
      return android.id;
    } else if (Platform.isIOS) {
      final ios = await _info.iosInfo;
      return ios.identifierForVendor;
    } else {
      return null;
    }
  }

  static Future<String?> getDeviceName() async {
    if (Platform.isAndroid) {
      final android = await _info.androidInfo;
      return android.model; // e.g., "Pixel 6"
    } else if (Platform.isIOS) {
      final ios = await _info.iosInfo;
      return ios.name; // e.g., "John’s iPhone"
    } else {
      final generic = await _info.deviceInfo;
      return generic.data['model']?.toString();
    }
  }
}