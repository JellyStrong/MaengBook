import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class WeatherDiaryProvider with ChangeNotifier {
  final String _API_KEY = dotenv.env['API_KEY'] ?? 'default_api_key';
  final uri = 'http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtNcst?';

  Future<void> fetchData() async {
    print('--------11');
    print(_API_KEY);
    final headers = {'Content-Type': 'application/json'};

    final body = {
      'serviceKey': _API_KEY,
      'dataType': 'JSON',
      'base_date': '20250331',
      'base_time': '1400',
      'nx': 59,
      'ny': 124,
    };
    const urii = 'serviceKey=U9FzBixE%2BnqZF9ErutaAK3l0l%2FywoRNfK3sfcFpuZPb1KdBfr5oDD5NJ9bVYdRjEJsAI%2FZirlaQGgZBfgYG7eA%3D%3D&numOfRows&dataType=JSON&base_date=20250401&base_time=1200&nx=59&ny=124';
    print('--------22');
    final rsss = await http.get(Uri.parse(uri + urii));

    print('--------33s');
    if (rsss.statusCode == 200) {
      // 성공적으로 데이터를 받았을 때
      print('@@ Response body: ${rsss.body}');

      // JSON 디코딩 (필요한 경우)
      // var data = jsonDecode(response.body);
      // print('Decoded JSON data: $data');
    } else {
      // 요청이 실패했을 때
      print('@@ Request failed with status: ${rsss.statusCode}');
    }
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
