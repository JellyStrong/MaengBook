import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:maengBook/provider/weatherNewsProvider.dart';
import 'package:provider/provider.dart';
import 'package:maengBook/provider/deviceInfoProvider.dart';
import 'model/deviceInfo.dart';
import 'provider/calculatorProvider.dart';
import 'provider/macWallPaperProvider.dart';
import 'util/util.dart';
import 'view/macWallPaperView.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Hive.initFlutter();
  Hive.registerAdapter(DeviceInfoDataAdapter()); // 어댑터 등록

  if (Hive.isBoxOpen('deviceInfoBox') == false) {
    await Hive.openBox<DeviceInfoData>('deviceInfoBox');
  }

  runApp(const RunApp());
}

class RunApp extends StatefulWidget {
  const RunApp({super.key});

  @override
  State<RunApp> createState() => _RuntAppState();
}

class _RuntAppState extends State<RunApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('initState');

    DeviceInfoProvider().insertDeviceInfo(context);
    test('날씨 테스트', () {
      print('ㅈ테스트중');
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    DeviceInfoProvider().disposeBox();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []); // 상태바 숨기기

    // SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values); // 상태바 보이기

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => CalculatorViewProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => WindowControls(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => MacWallPaperViewProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => WeatherNewsProvider(),
        ),
      ],
      child: const MaterialApp(
        // initialRoute: '/',
        // routes: MyRoute,
        home: MacWallPaperView(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
