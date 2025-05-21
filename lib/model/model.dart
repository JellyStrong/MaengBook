import 'package:flutter/cupertino.dart';

/// device Info
class Model {
  // 외부에서 직접 인스턴스를 생성할 수 없도록 private 생성자 사용
  // 싱클톤 패턴 적용
  //static final Model _instance = Model._internal();
  //Model model = Model();
  //Model._internal();

  //factory Model() => _instance;

  Map<String, dynamic> _deviceData = <String, dynamic>{};
  Map<String, OverlayEntry> _entries = <String, OverlayEntry>{};

  /// getter
  Map<String, dynamic> get getDeviceData => _deviceData;

  Map<String, OverlayEntry> get getEntries => _entries;

  /// setter
  set setDeviceData(Map<String, dynamic> v) => _deviceData = v;

  set setEntries(Map<String, OverlayEntry> v) => _entries = v;

  /// entry 추가하기
  void addEntry(String key, OverlayEntry overlayEntry) {
    setEntries = {...getEntries, key: overlayEntry};
    print('overlayEntry : $_entries');
  }
}
