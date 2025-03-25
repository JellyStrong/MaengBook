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
        'type': 'android',
        'platform': 'android',
      });
    }

    /// iOS
    else if (Theme.of(context).platform == TargetPlatform.iOS) {
      IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
      result = iosInfo.data;
      result.addAll({
        'type': 'macIntel',
        'platform': 'ios',
      });
    }

    /// fuchsia
    else if (Theme.of(context).platform == TargetPlatform.fuchsia) {
      WebBrowserInfo fuchsiaInfo = await deviceInfoPlugin.webBrowserInfo;
      result = fuchsiaInfo.data;
      result.addAll({
        'type': 'fuchsia',
        'platform': 'web',
      });
    }

    /// macIntel
    else if (Theme.of(context).platform == TargetPlatform.macOS) {
      WebBrowserInfo macIntel = await deviceInfoPlugin.webBrowserInfo;
      result = macIntel.data;
      result.addAll({
        'type': 'macIntel',
        'platform': 'web',
      });
    }

    /// window
    else if (Theme.of(context).platform == TargetPlatform.windows) {
      WebBrowserInfo webInfo = await deviceInfoPlugin.webBrowserInfo;
      result = webInfo.data;
      result.addAll({
        'type': 'windows',
        'platform': 'web',
      });
    } else {
      print('getDeviceInfo() error!!!');
    }
    print('getDeviceInfo() result : $result');
    return result;
  }

  /// 디바이스 정보 조회
  Future<Map<String, dynamic>?> selectDeviceInfo() async {
    return deviceInfoBox.get('deviceInfoBox')?.toJson();
  }

  /// DeviceInfoData 저장
  Future<void> insertDeviceInfo(BuildContext context) async {
    await getDeviceInfo(context).then((result) {
      deviceInfoData = DeviceInfoData(
        model: result['model'],
        modelName: result['modelName'],
        localizedModel: result['localizedModel'],
        platform: result['platform'],
      );
      deviceInfoBox.put('deviceInfoBox', deviceInfoData);
    });
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
