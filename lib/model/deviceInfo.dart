import 'package:hive/hive.dart';

part 'deviceInfo.g.dart';

@HiveType(typeId: 1)
class DeviceInfoData {
  @HiveField(0)
  final String? model;
  @HiveField(1)
  final String? modelName;
  @HiveField(2)
  final String? localizedModel;
  @HiveField(3)
  final String? platform;

  // 생성자
  DeviceInfoData({
    this.model,
    this.modelName,
    this.localizedModel,
    this.platform,
  });

  // JSON으로 변환하는 메서드 추가
  Map<String, dynamic> toJson() {
    return {
      'model': model,
      'modelName': modelName,
      'localizedModel': localizedModel,
      'platform': platform,
    };
  }

  // JSON에서 객체로 변환하는 메서드도 추가 가능
  factory DeviceInfoData.fromJson(Map<String, dynamic> json) {
    return DeviceInfoData(
      model: json['model'],
      modelName: json['modelName'],
      localizedModel: json['localizedModel'],
      platform: json['platform'],
    );
  }
}
