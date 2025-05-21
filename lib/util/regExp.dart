class MyRegExp {
  MyRegExp._();

  /// 소수점 아래 부터 0만 있는지 확인
  // static RegExp pointRightDelZero = RegExp(r'\.?0+$'); //as
  static RegExp pointRightDelZero = RegExp(r'(\.0+$)|(\.[0-9]*[1-9])0+$');

  /// 선행 0을 제거
  static RegExp pointLeftDelZero = RegExp(r'^0+(?=\d)');

  /// 이미 점이 있으면 점 입력을 막는 정규식
  // 점이 있는지 확인
  static RegExp noMorePoint = RegExp(r'(?<=\.\d*)\.');

  /// 연산자 확인
  static RegExp operators = RegExp(r'[+\−×\÷]'); //calculation code

  /// 등호 확인
  static RegExp result = RegExp(r'=$');

  /// 숫자값 확인
  static RegExp num = RegExp(r'[0-9]$');
}

extension StringExtension on String {
  bool get isOperator {
    return MyRegExp.operators.hasMatch(this); // String
  }

  bool get isNumber {
    return MyRegExp.num.hasMatch(this); // String
  }

  bool get isReturn {
    return MyRegExp.result.hasMatch(this); // String
  }
}
