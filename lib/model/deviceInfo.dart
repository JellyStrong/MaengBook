import 'package:hive/hive.dart';

part 'deviceInfo.g.dart';

@HiveType(typeId: 1)
class DeviceInfoData {
  @HiveField(0)
  final String? device;
  @HiveField(1)
  final String? OS;
  @HiveField(2)
  final String? model;
  @HiveField(3)
  final String? modelName;
  @HiveField(4)
  final String? localizedModel;

  /// 생성자
  DeviceInfoData({
    this.device,
    this.OS,
    this.model,
    this.modelName,
    this.localizedModel,
  });

  /// JSON으로 변환하는 메서드 추가
  Map<String, dynamic> toJson() {
    return {
      'device': device,
      'OS': OS,
      'model': model,
      'modelName': modelName,
      'localizedModel': localizedModel,
    };
  }

  /// JSON에서 객체로 변환하는 메서드도 추가 가능
  factory DeviceInfoData.fromJson(Map<String, dynamic> json) {
    return DeviceInfoData(
      device: json['device'],
      OS: json['OS'],
      model: json['model'],
      modelName: json['modelName'],
      localizedModel: json['localizedModel'],
    );
  }
}
