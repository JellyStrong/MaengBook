import 'package:flutter/material.dart';
import 'package:maengBook/model/deviceInfo.dart';
import 'package:maengBook/provider/deviceInfoProvider.dart';

class MacWallPaperViewProvider with ChangeNotifier {
  Map<String, dynamic> platform = {};

  void getPlatform() {
    DeviceInfoProvider().selectDeviceInfo().then((result) {
      print(result);
      platform = result!;
      notifyListeners();
    });
  }
}
