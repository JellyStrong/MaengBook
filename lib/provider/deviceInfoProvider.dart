import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:maengBook/model/deviceInfo.dart';

class DeviceInfoProvider {
  Box<DeviceInfoData> deviceInfoBox = Hive.box('deviceInfoBox');
  late DeviceInfoData deviceInfoData = DeviceInfoData();

  /// 디바이스 정보 불러오기
  Future<Map<String, dynamic>> getDeviceInfo(BuildContext context) async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    Map<String, dynamic> result = {};

    /// Android
    if (Theme.of(context).platform == TargetPlatform.android) {
      AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      result = androidInfo.data;
      result.addAll({
        'device': 'android',
        'OS': 'android',
      });
    }

    /// iOS
    else if (Theme.of(context).platform == TargetPlatform.iOS) {
      IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
      result = iosInfo.data;
      result.addAll({
        'device': 'macIntel',
        'OS': 'ios',
      });
    }

    /// fuchsia
    else if (Theme.of(context).platform == TargetPlatform.fuchsia) {
      WebBrowserInfo fuchsiaInfo = await deviceInfoPlugin.webBrowserInfo;
      result = fuchsiaInfo.data;
      result.addAll({
        'device': 'fuchsia',
        'OS': 'web',
      });
    }

    /// macIntel
    else if (Theme.of(context).platform == TargetPlatform.macOS) {
      WebBrowserInfo macIntel = await deviceInfoPlugin.webBrowserInfo;
      result = macIntel.data;
      result.addAll({
        'device': 'macIntel',
        'OS': 'web',
      });
    }

    /// window
    else if (Theme.of(context).platform == TargetPlatform.windows) {
      WebBrowserInfo webInfo = await deviceInfoPlugin.webBrowserInfo;
      result = webInfo.data;
      result.addAll({
        'device': 'windows',
        'OS': 'web',
      });
    } else {
      print('getDeviceInfo() error!!!');
    }
    print('getDeviceInfo() result : $result');
    return result;
  }

  /// DeviceInfoData 저장
  Future<void> insertDeviceInfo(BuildContext context) async {
    await getDeviceInfo(context).then((result) {
      deviceInfoData = DeviceInfoData(
        device: result['device'],
        OS: result['OS'],
        model: result['model'],
        modelName: result['modelName'],
        localizedModel: result['localizedModel'],

      );
      deviceInfoBox.put('deviceInfoBox', deviceInfoData);
    });
  }

  /// 디바이스 정보 조회
  Future<Map<String, dynamic>?> selectDeviceInfo() async {
    return deviceInfoBox.get('deviceInfoBox')?.toJson();
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
