// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deviceInfo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DeviceInfoDataAdapter extends TypeAdapter<DeviceInfoData> {
  @override
  final int typeId = 1;

  @override
  DeviceInfoData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DeviceInfoData(
      device: fields[0] as String?,
      OS: fields[1] as String?,
      model: fields[2] as String?,
      modelName: fields[3] as String?,
      localizedModel: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DeviceInfoData obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.device)
      ..writeByte(1)
      ..write(obj.OS)
      ..writeByte(2)
      ..write(obj.model)
      ..writeByte(3)
      ..write(obj.modelName)
      ..writeByte(4)
      ..write(obj.localizedModel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceInfoDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
