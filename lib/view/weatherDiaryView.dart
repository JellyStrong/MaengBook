import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget weatherDiaryView() {
  TextEditingController memoController;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  return Expanded(
    child: Column(
      children: [
        const Text(
          '20도',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
            color: Colors.blue,
          ),
        ),
        const Text(
          '오늘의 날씨는',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
            color: Colors.blue,
          ),
        ),
        const Text(
          '최저 9도 최고 21도',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
            color: Colors.blue,
          ),
        ),
        SizedBox(
          width: 300,
          height: 300,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: '일기 쓰는중.',
                  ),
                ),
                TextFormField(
                  maxLines: 1,
                  decoration: InputDecoration(),
                ),
                TextFormField(
                  maxLines: 1,
                  decoration: InputDecoration(),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget myText({required String str, String? emphasisStr, String? bold, double? fontSize, Color? color}) {
  return Align(
    alignment: Alignment.topLeft,
    child: Text(
      str,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: bold == 'bold' ? FontWeight.bold : null,
        color: color ?? Colors.black,
      ),
    ),
  );
}
