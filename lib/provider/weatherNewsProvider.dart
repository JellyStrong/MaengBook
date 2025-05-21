import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:maengBook/model/weatherNewsModel.dart';
import 'package:maengBook/util/regExp.dart';

import '../util/util.dart';

class WeatherNewsProvider with ChangeNotifier {
  final String _API_KEY = dotenv.env['API_KEY'] ?? 'default_api_key'; // api_Key
  bool loading1 = false;
  bool loading2 = false;

  //초단기실황조회
  final ultraSrtNcst = 'http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtNcst?'; // url
  //단기예보조회
  final vilageFcst = 'http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst?'; // url

  dynamic ultraSrtNcstItem;

  Map<String, Map<String, dynamic>> test = {};
  dynamic vilageFcstItem;
  List<dynamic> filtered = [];
  List<dynamic> hour24Data = [];

  List<String> time = [];
  List<String> tmp = [];
  List<String> sky = [];
  List<String> pop = [];
  List<String> pty = [];

  /// ultraSrtNcst (초단기실황)
  /// vilageFcst (단기예보)
  // 최신데이터 갱신 느낌
  Map<String, dynamic> baseData({required String type, String? day}) {
    Map<String, dynamic> data = {'baseDate': '', 'baseTime': ''};
    switch (type) {
      case 'ultraSrtNcst':
        int nowTimeHHmm = int.parse(Util().nowTimeHHmm());
        String timeHH = Util().nowTimeHH();
        if (int.parse('${timeHH}10') <= nowTimeHHmm) {
          data['baseDate'] = Util().nowDateyyyyMMdd();
          data['baseTime'] = '${timeHH}00';
        } else {
          if (timeHH == '00') {
            // 한시간 빼기
            // 전날로 조회
            DateTime oneHourBefore = DateTime.parse(Util().nowDateyyyyMMdd()).subtract(const Duration(hours: 1));

            data['baseDate'] = DateFormat('yyyyMMdd').format(oneHourBefore);
            data['baseTime'] = '${(DateFormat('HH').format(oneHourBefore))}00';
          } else {
            // 한시간 빼기
            data['baseDate'] = Util().nowDateyyyyMMdd();
            data['baseTime'] = '${int.parse(timeHH) - 1}00';
          }
        }
        break;
      case 'vilageFcst':
        // TMN : 최저기온 / TMX : 최고기온
        // 1: 오늘 / 2: 내일, 모레, 글피 / 3: 그글피
        List<String> fixedTime1_TMN = ['0200'];
        List<String> fixedTime1_TMX = ['0200', '0500', '0800', '1100'];
        List<String> fixedTime2 = ['0200', '0500', '0800', '1100', '1400', '1700', '2000', '2300']; // 발표시각
        List<String> fixedTime3 = ['2000', '2300'];
        int timeHHmm = int.parse((Util().nowTimeHHmm()));
        String timeHH = (Util().nowTimeHH());

        for (int i = 0; i < fixedTime2.length; i++) {
          // 제공시간(발표시간+10분)이 현재시간보다 시간이 덜 흘렸을때 의 조건 추가
          // 단기예보는 1시간후의 데이터부터 조회해줌 // 그리하여 baseTime == nowTimeHH 의 조건 추가
          if (int.parse(fixedTime2[i]) + 10 >= timeHHmm || fixedTime2[i] == '${timeHH}00') {
            int beforeIndex = (i - 1 + fixedTime2.length) % fixedTime2.length;
            if (i <= 0) {
              // fiexedTime[0]일경우 전날로 baseDate 설정 ex) 2025-04-18 02:01:00 -> 2025-04-17
              DateTime oneDaysBefore = DateTime.parse(Util().nowDateyyyyMMdd()).subtract(const Duration(days: 1));
              data['baseDate'] = DateFormat('yyyyMMdd').format(oneDaysBefore);
            } else {
              data['baseDate'] = Util().nowDateyyyyMMdd();
            }

            // baseTime 설정 ex) 제공시간은 발표시간 + 10 이라 그 이후에만 가능. 그전까진 전의 발표시간을 이용
            data['baseTime'] = fixedTime2[beforeIndex];
            break;
          } else {
            // 제공시간보다(발표시간+10) 보다 현재시간이 더 시간이 흘렀을때
            data['baseDate'] = Util().nowDateyyyyMMdd();
            data['baseTime'] = fixedTime2[i];
          }
        }
    }

    return data;
  }

  ///초단기실황조회
  Future<void> getUltraSrtNcst() async {
    Map<String, dynamic> baseVal = baseData(type: 'ultraSrtNcst');
    final body = {
      'serviceKey': _API_KEY, // KEY
      'dataType': 'JSON',
      'numOfRows': '299', // 로우값
      'base_date': baseVal['baseDate'], // baseDate
      'base_time': baseVal['baseTime'], // baseTime
      'nx': '59', // x
      'ny': '124', // y
    };
    getHttp(url: ultraSrtNcst, body: body).then((result) {
      ultraSrtNcstItem = result['response']['body']['items']['item'];
      loading1 = true;
      notifyListeners();
    });
  }

  ///단기예보조회
  Future<void> getVilageFcst() async {
    Map<String, dynamic> baseVal = baseData(type: 'vilageFcst');
    final body = {
      'serviceKey': _API_KEY,
      'dataType': 'JSON',
      'numOfRows': '1100',
      'base_date': baseVal['baseDate'],
      'base_time': baseVal['baseTime'],
      'nx': '59',
      'ny': '124',
      'pageNo': '1',
    };

    getHttp(url: vilageFcst, body: body).then((result) {
      vilageFcstItem = result['response']['body']['items']['item'];
      loading2 = true;

      hour24Data = filterForecastForDay(
        items: vilageFcstItem,
        desiredCategories: [
          'POP', // 강수 확률
          'PTY', // 강수 형태
          'PCP', // 1시간 강수량
          'SKY', // 하늘 상태
          'TMP', // 1시간 기온
        ],
        dateTime: Util().parseDateTime(Util().nowDateyyyyMMdd(), '${Util().nowTimeHH()}00'),
      );
      filtered = filterForecastForDay(
        items: vilageFcstItem,
        desiredCategories: [
          'REH', // 습도
          'POP', // 강수 확률
          'PTY', // 강수 형태
          'PCP', // 1시간 강수량
          'SKY', // 하늘 상태
          'VEC', // 풍향
          'WSD', // 풍속
          'TMN', // 최저 기온
          'TMX', // 최고 기온
          'TMP', // 1시간 기온
        ],
        dateTime: Util().parseDateTime(Util().nowDateyyyyMMdd(), '${Util().nowTimeHH()}00'),
      );
      hour24Weather(items: filtered, desiredCategories: ['POP', 'SKY', 'TMP', 'PTY']);
      notifyListeners();
    });
  }

  void todayWeather() {
    // 오늘날씨
    // 현재기온, 구름상태, 최고/최저기온
  }

  /// 오늘부터 24시간후
  void hour24Weather({required List<dynamic> items, required List<String> desiredCategories}) {
    DateTime hour24Later = DateTime.now().add(const Duration(hours: 24));

    List<dynamic> a = items.where((item) {
      final day = Util().parseDateTime(item['fcstDate'], item['fcstTime']);
      final isBefore = hour24Later == day || hour24Later.isAfter(day); // 오늘 ~ 내일까지
      final categoryMatch = desiredCategories.contains(item['category']);
      return categoryMatch && isBefore;
    }).toList();
    List<String> fcstTime = [];
    String hh = '';
    for (int i = 0; i < a.length; i++) {
      hh = a[i]['fcstTime'].substring(0, a[i]['fcstTime'].length - 2);

      fcstTime.add(hh.replaceAll(MyRegExp.pointLeftDelZero, ''));

      if (a[i]['category'] == 'TMP') {
        tmp.add(a[i]['fcstValue']);
      }

      if (a[i]['category'] == 'SKY') {
        sky.add(a[i]['fcstValue']);
      }
      if (a[i]['category'] == 'POP') {
        pop.add(a[i]['fcstValue']);
      }

      if (a[i]['category'] == 'PTY') {
        pty.add(a[i]['fcstValue']);
      }
    }
    time = fcstTime.toSet().toList();

    notifyListeners();
  }

  void day10Weather() {}

  List<dynamic> filterForecastForDay({
    required List<dynamic> items,
    required List<String> desiredCategories,
    DateTime? dateTime,
  }) {
    dynamic a;
    if (dateTime != null) {
      a = items.where((item) {
        final day = Util().parseDateTime(item['fcstDate'], item['fcstTime']);
        final isBefore = dateTime == day || dateTime.isBefore(day); // 오늘 또는 그 이상
        final categoryMatch = desiredCategories.contains(item['category']);
        return categoryMatch && isBefore;
      }).toList();
    } else {
      a = items.where((item) {
        final categoryMatch = desiredCategories.contains(item['category']);
        return categoryMatch;
      }).toList();
    }

    print('a : $a');
    return a;
  }
}
