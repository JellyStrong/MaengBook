import 'package:hive/hive.dart';

part 'deviceInfo.g.dart';

@HiveType(typeId: 1)
class DeviceInfoData {
  @HiveField(0)
  final String? type;
  @HiveField(1)
  final String? model;
  @HiveField(2)
  final String? modelName;
  @HiveField(3)
  final String? localizedModel;
  @HiveField(4)
  final String? platform;

  /// 생성자
  DeviceInfoData({
    this.type,
    this.model,
    this.modelName,
    this.localizedModel,
    this.platform,
  });

  /// JSON으로 변환하는 메서드 추가
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'model': model,
      'modelName': modelName,
      'localizedModel': localizedModel,
      'platform': platform,
    };
  }

  /// JSON에서 객체로 변환하는 메서드도 추가 가능
  factory DeviceInfoData.fromJson(Map<String, dynamic> json) {
    return DeviceInfoData(
      type: json['type'],
      model: json['model'],
      modelName: json['modelName'],
      localizedModel: json['localizedModel'],
      platform: json['platform'],
    );
  }
}
