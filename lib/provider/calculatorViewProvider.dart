import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maengBook/util/regExp.dart';

class CalculatorViewProvider with ChangeNotifier {
  Key eventKey = const ValueKey(0); // 클릭 버튼에 대한 key
  Key operatorKey = const ValueKey(0); // 연산자에 대한 key
  String screenStr = '0'; // 화면용
  String numA = ''; // 숫자A
  String numB = ''; // 숫자B
  String operator = ''; // 연산자
  bool beforeReturn = false; // 전의 기호가 등호(=) 였는지

  /// 초기화
  void initialization() {
    screenStr = '0';
    numA = '';
    numB = '';
    operator = '';
    beforeReturn = false;
    operatorKey = const ValueKey(0);
    notifyListeners();
  }

  /// 숫자 입력
  void clickButton(String str) {
    HapticFeedback.vibrate(); // 모바일 진동
    if (str.isNumber) {
      if (beforeReturn) {
        numB = '';
        beforeReturn = false;
      }
      if (operator.isEmpty && !beforeReturn) {
        print('6.');
        numA += str; // A에 값 저장
        screenStr = numA.replaceAll(MyRegExp.pointLeftDelZero, '');
      } else if (operator.isNotEmpty) {
        print('7.');

        numB += str; // B에 값 저장
        screenStr = numB.replaceAll(MyRegExp.pointLeftDelZero, '');
      }
    } else {
      if (str.isReturn) {
        beforeReturn = true;
        print('1.');
        if (numA.isNotEmpty && numB.isNotEmpty) {
          print('2.');
          calculation(operator, double.parse(numA), double.parse(numB), true);
          //일단 가지고있으면 b의값을 가지고 있기
          if (str.isReturn) operatorKey = const ValueKey(0);
        } else if (numA.isNotEmpty && numB.isEmpty) {
          print('3.');
          calculation(operator, double.parse(numA), double.parse(numA), true);

          if (str.isReturn) operatorKey = const ValueKey(0);
        }
      } else if (str.isOperator) {
        print('4.');

        if (numA.isNotEmpty && numB.isNotEmpty && !beforeReturn) {
          print('5.');
          calculation(operator, double.parse(numA), double.parse(numB));
        }
        if (beforeReturn) {
          numB = screenStr;
        }
        operator = str; // 연산자 저장
      } else {
        if (operator.isEmpty) {
          screenStr = decorateStr(str, screenStr);
          numA = screenStr;
        } else {
          screenStr = decorateStr(str, screenStr);
          numB = screenStr;
          print(numB);
        }
      }
    }

    notifyListeners();
  }

  /// 연산자 성형 및 AC
  String decorateStr(String deco, String num) {
    String decoStr = '0'; // return

    switch (deco) {
      case 'AC':
        cleanBtn();
        break;
      case '⁺⧸₋':
        decoStr = (double.parse(num) * -1).toString().replaceAll(MyRegExp.pointRightDelZero, '');
        break;
      case '%':
        decoStr = (double.parse(num) * 0.01).toString().replaceAll(MyRegExp.pointRightDelZero, '');
        break;

      case '.':
        decoStr = (num + '.').replaceAll(MyRegExp.noMorePoint, '');
        break;
    }
    print(decoStr);
    return decoStr;
  }

  /// 버튼 선택 색상
  void clickBtnChangeColor(Key key) {
    eventKey = key;
    notifyListeners();
  }

  /// 버튼 선택 테두리
  void clickBtnChangeBorder(Key key) {
    operatorKey = key;
    notifyListeners();
  }

  /// 화면,숫자,연산자 데이터 지우기
  void cleanBtn() {
    initialization();
    notifyListeners();
  }

  /// 계산 하기
  void calculation(String operator, double a, double b, [bool saveNumB = false]) {
    print('식: $a $operator $b ');
    beforeReturn = saveNumB;
    switch (operator) {
      case '+':
        screenStr = (a + b).toString().replaceAll(MyRegExp.pointRightDelZero, '');
        numA = screenStr;
        numB = saveNumB ? b.toString() : '';
        break;
      case '−':
        screenStr = (a - b).toString().replaceAll(MyRegExp.pointRightDelZero, '');
        numA = screenStr;
        numB = saveNumB ? b.toString() : '';
        break;
      case '×':
        screenStr = (a * b).toString().replaceAll(MyRegExp.pointRightDelZero, '');
        numA = screenStr;
        numB = saveNumB ? b.toString() : '';
        break;
      case '÷':
        screenStr = (a / b).toString().replaceAll(MyRegExp.pointRightDelZero, '');
        numA = screenStr;
        numB = saveNumB ? b.toString() : '';
        break;
    }
    notifyListeners();
  }
}
