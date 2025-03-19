import 'package:flutter/material.dart';
import 'package:maengBook/model/deviceInfo.dart';
import 'package:maengBook/provider/deviceInfoProvider.dart';

class MacWallPaperViewProvider with ChangeNotifier{
DeviceInfoData? deviceInfoData =  DeviceInfoProvider().selectDeviceInfo();

  void byPlatform(){
    print('>>>>>> ${deviceInfoData?.toJson()}');
    notifyListeners();
  }
}
/// 1. platform 에 따른 화면 비율
/// 2.