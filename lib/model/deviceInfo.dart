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

  DeviceInfoData({
    this.model,
    this.modelName,
    this.localizedModel,
  });
}
