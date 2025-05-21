import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:maengBook/provider/weatherNewsProvider.dart';
import 'package:provider/provider.dart';
import 'package:maengBook/provider/calculatorProvider.dart';
import 'dart:math';
import '../model/model.dart';

const int closeKey = 100;
const int minimizeKey = 101;
const int maximizeKey = 102;

/* DeviceInfo
 * getHeight()
 * getWidth()
 * getSize()
 * getDeviceInfo()
 * */

/* WindowControls
 * initialization()
 * getLayoutRandomOffset()
 * getMenuOffset()
 * btnHoverMenu()
 * btnHover()
 * btnClick()
 *
 * */

Model model = Model();

class Util {
  String nowDateyyyyMMdd() {
    return DateFormat('yyyyMMdd').format(DateTime.now());
  }

  String nowTime() {
    return DateFormat('HHmm').format(DateTime.now());
  }

  String nowTimemm() {
    return DateFormat('mm').format(DateTime.now());
  }

  String nowTimeHHmm() {
    return DateFormat('HHmm').format(DateTime.now());
  }

  String nowTimeHH() {
    return DateFormat('HH').format(DateTime.now());
  }
  String nowFullDateTime(){
    return DateTime.now().toString();
  }
  DateTime parseDateTime(String yyyyMMdd, String HHmm) {
    return DateTime.parse(
      '${yyyyMMdd.substring(0, 4)}-${yyyyMMdd.substring(4, 6)}-${yyyyMMdd.substring(6, 8)} ${HHmm.substring(0, 2)}:${HHmm.substring(2, 4)}',
    );
  }
}

class DeviceInfo {
  /// 화면 세로값 가져 오기
  double getHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// 화면 가로값 가져 오기
  double getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// 화면 가로값 세로값 가져 오기
  Size getSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  /// 플랫폼 상태 데이터
  Future<void> initPlatformState() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    final deviceInfo = await deviceInfoPlugin.deviceInfo;
    Model().setDeviceData = deviceInfo.data;
    print('ddd1: ${Model().getDeviceData}');
    print(readAndroidBuildData(deviceInfo));
    Model().setDeviceData = readAndroidBuildData(deviceInfo);
    print('ddd2: ${Model().getDeviceData}');
  }

  Map<String, dynamic> readAndroidBuildData(BaseDeviceInfo data) {
    // print('dddd4: ${Model().getDeviceData}');
    Model().setDeviceData = data.data;
    print('ddd3: ${Model().getDeviceData}');
    return <String, dynamic>{
      'model': data.data['model'],
    };
  }
}

class WindowControls with ChangeNotifier {
  // 1. 윈더우 컨트롤 마우스 호버시 메뉴 아이콘 노출
  // 2. 윈도우 컨트롤 마우스 1.5초 호버시 메뉴 노툴
  // 3. 윈도우 컨트롤 빨간버튼 노란버튼 초록버튼 관련 이벤트

  Key key = const ValueKey(0);
  bool hover = false;

  /// 초기화
  void initialization(BuildContext context, String iconName) {
    key = const ValueKey(0);
    hover = false;
    // 계산기 내용 초기화
    if (iconName == '계산기') {
      final provider = Provider.of<CalculatorViewProvider>(context, listen: false);
      provider.cleanBtn(); // cleanBtn 호출하여 초기화
    }
  }

  /// 랜덤 좌표값 리턴
  Offset getLayoutRandomOffset(BuildContext context, String iconName, double left, double top) {
    Random random = Random();
    Offset randomOffset = const Offset(0, 0);
    double x = random.nextDouble() * (DeviceInfo().getWidth(context) - left);
    double y = random.nextDouble() * (DeviceInfo().getHeight(context) - top - 40); // 40:상태창
    randomOffset = Offset(x, y + 40); // 40:상태창

    return randomOffset;
  }

  /// 메뉴 좌표값 리턴 (윈도우 컨트롤)
  Offset getMenuOffset(BuildContext context) {
    RenderBox renderBox;
    Offset position = const Offset(0, 0); //초기화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      renderBox = context.findRenderObject() as RenderBox;
      position = renderBox.localToGlobal(Offset.zero); // (0, 0)은 위젯의 좌측 상단
    });
    return position + const Offset(0, 5);
  }

  /// hover 1.5ms 후 menu 띄우기
  void btnHoverMenu({
    required Key key,
    required BuildContext context,
    String? str,
  }) {
    this.key = key;

    switch ((key as ValueKey).value) {
      case closeKey:
        //close
        break;
      case minimizeKey:
        break;
      case maximizeKey:
        break;
    }

    notifyListeners();
  }

  /// hover
  void btnHover({
    required BuildContext context,
    required bool hover,
    required Model model,
  }) {
    this.hover = hover;
    notifyListeners();
  }

  /// click
  void btnClick({
    required Key key,
    required BuildContext context,
    required String str,
    required String iconName,
    required Model model,
  }) {
    OverlayEntry? overlayEntry;
    switch (str) {
      case 'close':
        overlayEntry = model.getEntries[iconName];
        overlayEntry!.remove();
        model.getEntries.remove(iconName);
        initialization(context, iconName); // 초기화 (종료)

        break;
      case 'minimize':
        break;
      case 'maximize':
        break;
    }
  }
}

class ImagesGetInfo {
  int? imageWidth;
  int? imageHeight;

  // 이미지 크기 구하는 메소드
  Future<Map> getImageSize(String imagePath) async {
    Image imageInfo = Image.asset(imagePath);
    final ImageStream stream = imageInfo.image.resolve(const ImageConfiguration());

    stream.addListener(
      ImageStreamListener(
        (ImageInfo info, bool synchronousCall) {
          final size = info.image; // Image 객체
          print('>>>>> ${size.runtimeType}');
          imageWidth = size.width;
          imageHeight = size.height;
          // x = [imageWidth, imageHeight];
          print('imageW: $imageWidth, imageH: $imageHeight');
        },
      ),
    );
    return {
      'height': imageHeight,
      'width': imageWidth,
    };
  }
}
