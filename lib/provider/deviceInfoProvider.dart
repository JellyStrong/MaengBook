import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
      info['platform'] = 'android';
      print('>>>>>> ${info}');
    }

    /// iOS
    else if (Theme.of(context).platform == TargetPlatform.iOS) {
      IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;

      info = iosInfo.data;
      info['platform'] = 'ios';
      print('>>>>>> ${info}');
    }

    /// fuchsia
    else if (Theme.of(context).platform == TargetPlatform.fuchsia) {
      WebBrowserInfo fuchsiaInfo = await deviceInfoPlugin.webBrowserInfo;
      info = fuchsiaInfo.data;
      info['platform'] = 'window';
      print('>>>>>> ${info}');
    }

    /// macIntel
    else if (Theme.of(context).platform == TargetPlatform.macOS) {
      WebBrowserInfo macIntel = await deviceInfoPlugin.webBrowserInfo;
      info = macIntel.data;
      info['platform'] = 'maxIntel';
      print('maxIntel ${info}');
    }

    /// window
    else if (Theme.of(context).platform == TargetPlatform.windows) {
      WebBrowserInfo webInfo = await deviceInfoPlugin.webBrowserInfo;
      info = webInfo.data;
      info['platform'] = 'window';
      print('>>>>>> ${info}');
    } else {
      info = {
        'error': 'Unknown Model',
      };
    }
    return info;
  }

  /// Hive Box open 열기
  Future<bool> openBox() async {
    if (!Hive.isBoxOpen('deviceInfoBox')) {
      await Hive.openBox<DeviceInfoData>('deviceInfoBox');
    } else {
      return false;
    }
    return true;
  }

  /// DeviceInfoData 저장
  Future<void> deviceInfo(BuildContext context) async {
    deviceInfoBox = Hive.box('deviceInfoBox');

    await getDeviceInfo(context).then((result) {
      print(result);
      DeviceInfoData deviceInfoData = DeviceInfoData(
        model: result['model'] ?? '',
        modelName: result['modelName'] ?? '',
        localizedModel: result['localizedModel'] ?? '',
        platform: result['platform'] ?? '',
      );
      deviceInfoBox.put('deviceInfoBox', deviceInfoData);

      DeviceInfoData? aaa = selectDeviceInfo();
      print('>>>>>> ${aaa?.platform}');
      print('>>>>>>${aaa?.toJson()}');
    });
  }

  /// DeviceInfoData 정보 조회
  DeviceInfoData? selectDeviceInfo() {
    deviceInfoBox = Hive.box('deviceInfoBox');
    print('deviceInfoBox :${deviceInfoBox.get('deviceInfoBox')}');

    return deviceInfoBox.get('deviceInfoBox'); // deviceInfoBox 조회
  }

  /// dispose
  void disposeBox() {
    deviceInfoBox.close();
  }

  /// delete
  void deleteBox() {
    deviceInfoBox.clear();
  }
}
