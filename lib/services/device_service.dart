import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_udid/flutter_udid.dart';

class DeviceService {
  //static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();


  // static Future<String> getDeviceId() async {
  //   try {
  //     if (Platform.isAndroid) {
  //       final info = await _deviceInfo.androidInfo;
  //       return info.id; 
  //     } else if (Platform.isIOS) {
  //       final info = await _deviceInfo.iosInfo;
  //       return info.identifierForVendor ?? 'unknown-ios';
  //     }
  //   } catch (_) {}
  //   return 'unknown-device';
  // }
   static Future<String> getDeviceId() async {
    try {
      final udid = await FlutterUdid.udid;
      if (udid.isNotEmpty) return udid;
    } catch (_) {}

    final info = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final android = await info.androidInfo;
      return android.id;
    } else if (Platform.isIOS) {
      final ios = await info.iosInfo;
      return ios.identifierForVendor ?? 'unknown';
    }
    return 'unknown';
  }
}