import 'package:flutter/material.dart';

class WeatherDairyModel {
  final String? baseDate;
  final String? category;
  final int? nx;
  final int? ny;
  final String? obsrValue;

  /// 생성자
  WeatherDairyModel({
    this.baseDate,
    this.category,
    this.nx,
    this.ny,
    this.obsrValue,
  });

  /// JSON으로 변환하는 메서드 추가
  Map<String, dynamic> toJson() {
    return {
      'baseDate': baseDate,
      'category': category,
      'nx': nx,
      'ny': ny,
      'obsrValue': obsrValue,
    };
  }
}
