// utils.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:intl/intl.dart';
import 'dart:io';

Future<bool> checkAllow() async {
  try {
    // --- App Info ---
    final packageInfo = await PackageInfo.fromPlatform();

    // --- Device Info ---
    final deviceInfo = DeviceInfoPlugin();
    Map<String, dynamic> deviceData = {};
    if (defaultTargetPlatform == TargetPlatform.android) {
      final androidInfo = await deviceInfo.androidInfo;
      deviceData = {
        "platform": "android",
        "brand": androidInfo.brand,
        "model": androidInfo.model,
        "device": androidInfo.device,
        "manufacturer": androidInfo.manufacturer,
        "androidId": androidInfo.id,
        "osVersion": androidInfo.version.release,
        "sdkInt": androidInfo.version.sdkInt,
        "isPhysicalDevice": androidInfo.isPhysicalDevice,
      };
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      final iosInfo = await deviceInfo.iosInfo;
      deviceData = {
        "platform": "ios",
        "name": iosInfo.name,
        "systemName": iosInfo.systemName,
        "systemVersion": iosInfo.systemVersion,
        "model": iosInfo.model,
        "identifierForVendor": iosInfo.identifierForVendor,
        "utsname": iosInfo.utsname.machine,
        "isPhysicalDevice": iosInfo.isPhysicalDevice,
      };
    } else {
      deviceData = {"platform": "unknown"};
    }

    // --- Locale & Timezone ---
    final locale = Intl.defaultLocale ?? Platform.localeName;
    final timeZone = DateTime.now().timeZoneName;

    // --- Payload gửi server ---
    final payload = {
      "appName": packageInfo.appName,
      "packageName": packageInfo.packageName,
      "version": packageInfo.version,
      "buildNumber": packageInfo.buildNumber,
      "locale": locale,
      "timezone": timeZone,
      ...deviceData, // merge device data
    };

    final response = await http.post(
      Uri.parse("https://app-access-verifier.onrender.com/verify-access"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(response.body);
      return data["allow"] == true;
    }
  } catch (e) {
    // debugPrint("checkAllowFull error: $e");
    return false;
  }
  return false;
}
