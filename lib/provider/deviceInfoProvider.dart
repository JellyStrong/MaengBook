import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:siiimple/model/deviceInfo.dart';

class DeviceInfoProvider {
  late Box<DeviceInfoData> deviceInfoBox; //device info Box //box name 과 keys name 동일

  /// 디바이스 정보 불러오기
  Future<Map<String, dynamic>> getDeviceInfo(BuildContext context) async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    Map<String, dynamic> info = {};

    /// Android
    if (Theme.of(context).platform == TargetPlatform.android) {
      AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      info = androidInfo.data;
    }

    /// iOS
    else if (Theme.of(context).platform == TargetPlatform.iOS) {
      IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
      info = iosInfo.data;
    }

    /// fuchsia
    else if (Theme.of(context).platform == TargetPlatform.fuchsia) {
      WebBrowserInfo fuchsiaInfo = await deviceInfoPlugin.webBrowserInfo;
      info = fuchsiaInfo.data;
    }

    /// macOS
    else if (Theme.of(context).platform == TargetPlatform.macOS) {
      WebBrowserInfo macOsInfo = await deviceInfoPlugin.webBrowserInfo;
      info = macOsInfo.data;
      // macOsInfo.appName;
    }

    /// window
    else if (Theme.of(context).platform == TargetPlatform.windows) {
      WebBrowserInfo webInfo = await deviceInfoPlugin.webBrowserInfo;
      info = webInfo.data;
    } else {
      info = {
        'error': 'Unknown Model',
      };
    }
    return info;
  }

  /// Hive Box open 열기
  Future<void> openBox() async {
    deviceInfoBox = await Hive.openBox<DeviceInfoData>('deviceInfoBox');
  }

  /// DeviceInfoData 저장
  void deviceInfo(BuildContext context) {
    openBox();
    getDeviceInfo(context).then((result) async {
      var box = await Hive.openBox<DeviceInfoData>('deviceInfoBox');
      DeviceInfoData deviceInfoData = DeviceInfoData(model: result['model']);

      await box.put('deviceInfoBox', deviceInfoData);
    });
  }

  /// DeviceInfoData 정보 조회
  DeviceInfoData? selectDeviceInfo() {
    openBox();
    return deviceInfoBox.get('deviceInfoBox'); // deviceInfoBox 조회
  }

  ///
  void disposeBox(){
    deviceInfoBox.clear();
  }
}
