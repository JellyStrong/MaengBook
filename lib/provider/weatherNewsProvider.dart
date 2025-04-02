import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:maengBook/model/weatherNewsModel.dart';

class WeatherNewsProvider with ChangeNotifier {
  final String _API_KEY = dotenv.env['API_KEY'] ?? 'default_api_key';
  final uri = 'http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtNcst?';

  Future<void> fetchData() async {
    print('--------11');
    final headers = {'Content-Type': 'application/json'};

    final body = {
      'serviceKey': _API_KEY,
      'dataType': 'JSON',
      'base_date': '20250331',
      'base_time': '1400',
      'nx': 59,
      'ny': 124,
    };
    String urii = 'serviceKey=$_API_KEY&numOfRows&dataType=JSON&base_date=20250402&base_time=1200&nx=59&ny=124';
    print('--------22');
    final response = await http.get(Uri.parse(uri + urii));

    print('--------33');
    if (response.statusCode == 200) {
      // 성공적으로 데이터를 받았을 때
      print('@@ Response body: ${response.body}');

      print(json.decode(response.body));

      var decodedJson = json.decode(response.body);
      print('******* ${WeatherApiResponse.fromJson(decodedJson).toJson()}');
      // print('>>> ${WeatherApiResponse.fromJson(decodedJson['response'])}');
      // var responses = WeatherApiResponse.fromJson(decodedJson['response']);
      print('----------');
      // print(responses);

      // JSON 디코딩 (필요한 경우)
      // var data = jsonDecode(response.body);
      // print('Decoded JSON data: $data');
    } else {
      // 요청이 실패했을 때
      print('Request failed with status : ${response.body}');
      print('@@ Request failed with status: ${response.statusCode}');
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
