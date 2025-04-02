import 'package:flutter/material.dart';

class WeatherNewsModel {
  final String baseDate; //
  final String baseTime; //
  final String category; //
  final int nx; //
  final int ny; //
  final String obsrValue; //

  /// WeatherNewsModel 생성자
  WeatherNewsModel({
    required this.baseDate,
    required this.baseTime,
    required this.category,
    required this.nx,
    required this.ny,
    required this.obsrValue,
  });

  //
  /// JSON으로 변환하는 메서드 추가
  Map<String, dynamic> toJson() {
    return {
      'baseDate': baseDate,
      'baseTime': baseTime,
      'category': category,
      'nx': nx,
      'ny': ny,
      'obsrValue': obsrValue,
    };
  }

// JSON 데이터를 Dart 객체로 변환
  factory WeatherNewsModel.fromJson(Map<String, dynamic> json) {
    return WeatherNewsModel(
      baseDate: json['baseDate'],
      baseTime: json['baseTime'],
      category: json['category'],
      nx: json['nx'],
      ny: json['ny'],
      obsrValue: json['obsrValue'],
    );
  }
}

// 응답 본문 (body)
class WeatherResponseBody {
  final String dataType;
  final List<WeatherNewsModel> items;

  WeatherResponseBody({
    required this.dataType,
    required this.items,
  });

  // JSON 데이터를 Dart 객체로 변환
  factory WeatherResponseBody.fromJson(Map<String, dynamic> json) {
    print(json);
    var itemsJson = json['items']['item'] as List;
    print('dataTypeee : ${json['dataType']}');
    List<WeatherNewsModel> weatherItems = itemsJson.map((item) => WeatherNewsModel.fromJson(item)).toList();
    print('dataTypeee : ${json['dataType']}');

    return WeatherResponseBody(
      dataType: json['dataType'],
      items: weatherItems,
    );
  }
}

// 응답 헤더 (header)
class WeatherHeader {
  final String resultCode;
  final String resultMsg;

  WeatherHeader({
    required this.resultCode,
    required this.resultMsg,
  });

  // JSON 데이터를 Dart 객체로 변환
  factory WeatherHeader.fromJson(Map<String, dynamic> json) {
    print('@@@@@@@ ${json}');
    return WeatherHeader(
      resultCode: json['resultCode'],
      resultMsg: json['resultMsg'],
    );
  }
}

// 전체 응답 (response)
class WeatherApiResponse {
  final WeatherHeader header;
  final WeatherResponseBody body;
  final int pageNo;
  final int numOfRows;
  final int totalCount;

  WeatherApiResponse({
    required this.header,
    required this.body,
    required this.pageNo,
    required this.numOfRows,
    required this.totalCount,
  });

  /// JSON으로 변환하는 메서드 추가
  Map<String, dynamic> toJson() {
    return {
      'header': header,
      'body': body,
      'body': body,
      'pageNo': pageNo,
      'numOfRows': numOfRows,
      'totalCount': totalCount,
    };
  }


  // JSON 데이터를 Dart 객체로 변환
  factory WeatherApiResponse.fromJson(Map<String, dynamic> json) {
    print('1111------');
    // for (var entry in json.entries) {
    //   print('Key: ${entry.key}, Value: ${entry.value}');
    //   print('>>>>>>HEADER ${entry.value['header']}'); // result code 00
    //   print('>>>>>>BODY ${entry.value['body']}'); // data type totalCount
    //   print('>>>>>>ITEMS ${entry.value['body']['items']}'); // item
    //   print('>>>>>>ITEM ${entry.value['body']['items']['item']}');
    // }
    print('2222------');
    print('>>> ${json.values.length}');
    print('33333------');
    print('------');
    return WeatherApiResponse(
      header: WeatherHeader.fromJson(json['response']['header']),
      body: WeatherResponseBody.fromJson(json['response']['body']),
      pageNo: json['response']['body']['pageNo'],
      numOfRows: json['response']['body']['numOfRows'],
      totalCount: json['response']['body']['totalCount'],
    );
  }
}
