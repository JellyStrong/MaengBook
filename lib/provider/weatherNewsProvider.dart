import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:maengBook/model/weatherNewsModel.dart';

import '../util/util.dart';

class WeatherNewsProvider with ChangeNotifier {
  final String _API_KEY = dotenv.env['API_KEY'] ?? 'default_api_key'; // api_Key
  bool loding1 = false;
  bool loding2 = false;

  //초단기실황조회
  final ultraSrtNcst = 'http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtNcst?'; // url
  //단기예보조회
  final vilageFcst = 'http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst?'; // url

  dynamic ultraSrtNcstItem;

  dynamic vilageFcstItem;

  /// ultraSrtNcst (초단기실황)
  /// vilageFcst (단기예보)
  Map<String, dynamic> baseData({required String type}) {
    Map<String, dynamic> data = {'baseDate': '', 'baseTime': ''};
    switch (type) {
      case 'ultraSrtNcst':
        int nowTimeHHmm = int.parse(Util().nowTimeHHmm());
        String timeHH = Util().nowTimeHH();
        if (int.parse('${timeHH}10') <= nowTimeHHmm) {
          data['baseDate'] = Util().nowDateyyyyMMdd();
          data['baseTime'] = '${timeHH}00';
        } else {
          // 한시간 빼기
          if (timeHH == '00') {
            //전날로 조회
            DateTime oneHourBefore = DateTime.parse(Util().nowDateyyyyMMdd()).subtract(const Duration(hours: 1));

            data['baseDate'] = DateFormat('yyyyMMdd').format(oneHourBefore);
            data['baseTime'] = '${(DateFormat('HH').format(oneHourBefore))}00';
          } else {
            data['baseDate'] = Util().nowDateyyyyMMdd();
            data['baseTime'] = '${int.parse(timeHH) - 1}00';
          }
        }
        break;
      case 'vilageFcst':
        List<String> fixedTime = ['0200', '0500', '0800', '1100', '1400', '1700', '2000', '2300']; // 발표시각
        int timeHHmm = int.parse((Util().nowTimeHHmm()));

        for (int i = 0; i < fixedTime.length; i++) {
          // 발표시각보다 지금시간이 더 흘렸을때
          // +10은 제공 시간
          if (int.parse(fixedTime[i]) + 10 >= timeHHmm) {
            int beforeIndex = (i - 1 + fixedTime.length) % fixedTime.length; // 순환 인덱싱
            if (i <= 0) {
              // fiexedTime[0]일경우 전날로 baseDate 설정 ex) 2025-04-18 02:01:00 -> 2025-04-17
              DateTime oneDaysBefore = DateTime.parse(Util().nowDateyyyyMMdd()).subtract(const Duration(days: 1));
              data['baseDate'] = DateFormat('yyyyMMdd').format(oneDaysBefore);
            } else {
              data['baseDate'] = Util().nowDateyyyyMMdd();
            }

            // baseTime 설정 ex) 제공시간은 발표시간 + 10 이라 이후에만 가능. 그전까진 전의 발표시간을 이용
            data['baseTime'] = fixedTime[beforeIndex];
            break;
          } else {
            data['baseDate'] = Util().nowDateyyyyMMdd();
            data['baseTime'] = fixedTime[i];
          }
        }
    }

    return data;
  }

  ///초단기실황조회
  Future<void> getUltraSrtNcst() async {
    final body = {
      'serviceKey': _API_KEY,
      'dataType': 'JSON',
      'numOfRows': '299',
      'base_date': baseData(type: 'ultraSrtNcst')['baseDate'],
      'base_time': baseData(type: 'ultraSrtNcst')['baseTime'],
      'nx': '59',
      'ny': '124',
    };
    getHttp(url: ultraSrtNcst, body: body).then((result) {
      ultraSrtNcstItem = result['response']['body']['items']['item'];
      loding1 = true;
      notifyListeners();
    });
  }

  ///단기예보조회
  Future<void> getVilageFcst() async {
    final body = {
      'serviceKey': _API_KEY,
      'dataType': 'JSON',
      'numOfRows': '299',
      'base_date': baseData(type: 'vilageFcst')['baseDate'],
      'base_time': baseData(type: 'vilageFcst')['baseTime'],
      'nx': '59',
      'ny': '124',
      'pageNo': '1',
    };

    getHttp(url: vilageFcst, body: body).then((result) {
      vilageFcstItem = result['response']['body']['items']['item'];
      loding2 = true;
      notifyListeners();
      final filtered = filterForecastForDay(
        vilageFcstItem,
        Util().nowDateyyyyMMdd().toString(),
        ['T1H', 'POP', 'SKY'],
      );
      // 출력 확인
      for (var item in filtered) {
        print('${item['fcstDate']} - ${item['fcstTime']} - ${item['category']}: ${item['fcstValue']}');
      }
    });
  }

  List<dynamic> filterForecastForDay(
    List<dynamic> items,
    String date,
    List<String> desiredCategories,
  ) {
    final aa = items.where((item) {
      final categoryMatch = desiredCategories.contains(item['category']);
      return categoryMatch;
    }).toList();
    return aa;
  }
}
