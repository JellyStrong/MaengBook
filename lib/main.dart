import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:siiimple/provider/deviceInfoProvider.dart';
import 'model/deviceInfo.dart';
import 'provider/calculatorViewProvider.dart';
import 'util/util.dart';
import 'view/macWallPaperView.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(DeviceInfoDataAdapter()); // 어댑터 등록
  runApp(const RunApp());
}

void saveDeviceInfoData(BuildContext context) async {
  DeviceInfo().getDeviceInfo(context).then((result) async {
    var box = await Hive.openBox<DeviceInfoData>('deviceInfoBox');
    DeviceInfoData deviceInfoData = DeviceInfoData(model: result['model']);

    await box.put('deviceInfoBox', deviceInfoData);
  });
}

class RunApp extends StatefulWidget {
  /// RunApp({super.key, required this.box});
  const RunApp({super.key});

  @override
  State<RunApp> createState() => _RuntAppState();
}

class _RuntAppState extends State<RunApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DeviceInfoProvider().deviceInfo(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // widget.box.clear();
    super.dispose();
    DeviceInfoProvider().disposeBox();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []); // 상태바 숨기기
    // 상태바 보이기
    // SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => CalculatorViewProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => WindowControls(),
        ),
        // ChangeNotifierProvider(create: (BuildContext context)=> ),
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
