import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:maengBook/model/weatherNewsModel.dart';

import '../util/util.dart';

class WeatherNewsProvider with ChangeNotifier {
  final String _API_KEY = dotenv.env['API_KEY'] ?? 'default_api_key'; // api_Key
  final uri = 'http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtNcst?'; // url

  Future<void> fetchData() async {
    print('--------11');

    final headers = {'Content-Type': 'application/json'};
    String baseDate = Util().nowDate();
    String baseTime = Util().nowTime();
    final body = {
      'serviceKey': _API_KEY,
      'dataType': 'JSON',
      'base_date': baseDate,
      'base_time': baseTime,
      'nx': '59',
      'ny': '124',
    };
    getTest(url: uri, body: body).then((result) {
      print('getTEst::: ');
      print(result);
      // print(result.length);
      print(result['response']);
      print(result['response']['header']);
      print(result['response']['body']['items']);
    });
    // String urii = 'serviceKey=$_API_KEY&numOfRows&dataType=JSON&base_date=20250403&base_time=1200&nx=59&ny=124';
    // print('--------22');
    // final response = await http.get(Uri.parse(uri + urii));
    //
    // print('--------33');
    // if (response.statusCode == 200) {
    //   // 성공적으로 데이터를 받았을 때
    //   print('@@ Response body: ${response.body}');
    //
    //   print(json.decode(response.body));
    //
    //   var decodedJson = json.decode(response.body);
    //   print('******* ${WeatherApiResponse.fromJson(decodedJson).toJson()}');
    //   print('----------');
    // } else {
    //   // 요청이 실패했을 때
    //   print('Request failed with status : ${response.body}');
    //   print('@@ Request failed with status: ${response.statusCode}');
    // }
  }

// Future<void> bbb() async {
//   var client = http.Client();
//   try {
//     var response = await client.post(Uri.https('example.com', 'whatsit/create'), body: {'name': 'doodle', 'color': 'blue'});
//     var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
//     var uri = Uri.parse(decodedResponse['uri'] as String);
//     print(await client.get(uri));
//   } finally {
//     client.close();
//   }
// }
}
