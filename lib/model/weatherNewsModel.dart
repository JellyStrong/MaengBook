import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// WeatherNewsModel
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

  /// JSON 데이터를 Dart 객체로 변환
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

Future<Map<String, dynamic>> getTest({required String url, required Map<String, dynamic> body}) async {
  String makeBody = '';
  for (var entry in body.entries) {
    makeBody += '${entry.key}=${entry.value}';
    makeBody += '&';
  }
  print('makeBody = $makeBody');
  final response = await http.get(Uri.parse(url + makeBody));

  if (response.statusCode == 200) {
    print('response1 : ${jsonDecode(response.body)}');
    print('response2 : ${response.body.runtimeType}');
    print('response3 : ${jsonDecode(response.body).runtimeType}');
    var ddd = jsonDecode(response.body);
    print('TEST: ${jsonDecode(response.body)}');

    var bbb = WeatherApiResponse.fromJson(ddd).toJson();
    print(' 22222 ${bbb['header']}');
    print(' 33333 ${bbb['body']}');
    print(' 44444 ${bbb['pageNo']}');
    print(' 55555 ${bbb['numOfRows']}');
    print(' 66666 ${bbb['totalCount']}');
  }else{
    print(response.body);
  }
  return jsonDecode(response.body);
}

/// 응답 본문 (body)
class WeatherResponseBody {
  final String dataType;
  final List<WeatherNewsModel> items;

  WeatherResponseBody({
    required this.dataType,
    required this.items,
  });

  // JSON 데이터를 Dart 객체로 변환
  factory WeatherResponseBody.fromJson(Map<String, dynamic> json) {
    var itemsJson = json['items']['item'] as List;
    List<WeatherNewsModel> weatherItems = itemsJson.map((item) => WeatherNewsModel.fromJson(item)).toList();

    return WeatherResponseBody(
      dataType: json['dataType'],
      items: weatherItems,
    );
  }
}

/// 응답 헤더 (header)
class WeatherHeader {
  final String resultCode;
  final String resultMsg;

  WeatherHeader({
    required this.resultCode,
    required this.resultMsg,
  });

  // JSON 데이터를 Dart 객체로 변환
  factory WeatherHeader.fromJson(Map<String, dynamic> json) {
    return WeatherHeader(
      resultCode: json['resultCode'],
      resultMsg: json['resultMsg'],
    );
  }
}

/// 전체 응답 (response)
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
      'pageNo': pageNo,
      'numOfRows': numOfRows,
      'totalCount': totalCount,
    };
  }

  /// JSON 데이터를 Dart 객체로 변환
  factory WeatherApiResponse.fromJson(Map<String, dynamic> json) {
    print('111111');
    print(json);
    return WeatherApiResponse(
      header: WeatherHeader.fromJson(json['response']['header']),
      body: WeatherResponseBody.fromJson(json['response']['body']),
      pageNo: json['response']['body']['pageNo'],
      numOfRows: json['response']['body']['numOfRows'],
      totalCount: json['response']['body']['totalCount'],
    );
  }
}
