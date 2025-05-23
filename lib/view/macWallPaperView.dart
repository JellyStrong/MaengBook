import 'package:flutter/material.dart';
import 'package:maengBook/view/weatherNewsView.dart';
import 'package:maengBook/view/weathergifView.dart';
import 'package:provider/provider.dart';
import 'package:maengBook/provider/macWallPaperProvider.dart';
import 'package:maengBook/util/util.dart';
import 'package:maengBook/util/commonWidget.dart';
import 'calculatorView.dart';

class MacWallPaperView extends StatelessWidget {
  const MacWallPaperView({super.key});

  @override
  Widget build(BuildContext context) {
    //  context.read<MacWallPaperViewProvider>().getPlatform();
    return Material(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.black45,
          //TODO: 현재 시간에 따른 배경 이미지 변경 (예정)
          image: DecorationImage(
            image: AssetImage('assets/image/bg/macOS-Big-Sur-Daylight-Wallpaper_01.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              /// 상단 상태바
              Container(color: Colors.grey[700], width: DeviceInfo().getWidth(context), height: 40),
              Positioned(
                top: 40,
                child: Row(
                  children: [
                    Consumer<MacWallPaperViewProvider>(
                      builder: (BuildContext context, MacWallPaperViewProvider provider, Widget? child) {
                        return Column(
                          children: [
                            IconWidget().myApp(
                              context: context,
                              child: const Calculatorview(),
                              iconPath: 'assets/image/icon/calculator.png',
                              iconName: '계산기',
                              maxWidth: 233,
                              maxHeight: 323,
                              backGround: Colors.blue,
                            ),

                            IconWidget().myApp(
                              context: context,
                              child: const WeatherNewsView(),
                              iconPath: 'assets/image/icon/weather.png',
                              iconName: '날씨',
                              maxWidth: 1100,
                              maxHeight: 650,
                            ),
                            IconWidget().myApp(
                              context: context,
                              child: const WeathergifView(),
                              iconPath: 'assets/image/icon/weathergif.png',
                              iconName: '날씨gif',
                              maxWidth: 700,
                              maxHeight: 500,
                            )
                            // IconWidget().myPicture(
                            //   context: context,
                            //   child: imageView('assets/image/icon/test02.png'),
                            //   iconName: '이미지 테스트',
                            //   iconPath: 'assets/image/icon/test02.png',
                            //   maxWidth: 200,
                            //   maxHeight: 200,
                            //   backGround: Colors.blue,
                            // ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 7,
                left: (DeviceInfo().getWidth(context) * 0.5) - (250 * 0.5),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    color: Colors.grey[300],
                  ),
                  padding: const EdgeInsets.all(9),
                  width: 250,
                  height: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(13)),
                          color: Colors.red,
                        ),
                        width: 50,
                        height: 50,
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(13)),
                          color: Colors.purple,
                        ),
                        width: 50,
                        height: 50,
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(13)),
                          color: Colors.green,
                        ),
                        width: 50,
                        height: 50,
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(13)),
                          color: Colors.orange,
                        ),
                        width: 50,
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget myApp({
    required BuildContext context,
    required Widget child,
    required String iconPath,
    required String iconName,
    required double maxWidth,
    required double maxHeight,
    String? device,
    String? os,
    String? type,
    List<Widget>? entry,
    Color? backGround,
  }) {
    return Container(
      margin: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              OverlayEntry? overlayEntry;
              if (!model.getEntries.containsKey(iconName)) {
                Offset randomOffset = WindowControls().getLayoutRandomOffset(
                  context,
                  iconName,
                  maxWidth,
                  maxHeight,
                );
                overlayEntry = OverlayEntry(builder: (BuildContext context) {
                  return Positioned(
                    left: randomOffset.dx,
                    top: randomOffset.dy,
                    child: Material(
                      color: Colors.transparent, //뒷배경투명하게
                      child: Container(
                        /// 앱 틀
                        constraints: BoxConstraints(maxWidth: maxWidth, maxHeight: maxHeight),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(13),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(100),
                                blurRadius: 20.0,
                                spreadRadius: 5.0,
                                offset: const Offset(0, 10),
                              ),
                            ],
                            color: backGround ??= Colors.white),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 공통 윈도우 컨트롤
                            WindowControlsBtn().buttons(overlayEntry!, iconName),
                            // 컨텐츠
                            child,
                          ],
                        ),
                      ),
                    ),
                  );
                });
                model.addEntry(iconName, overlayEntry);
                Overlay.of(context).insert(overlayEntry);
              }
            },
            // 앱 아이콘 박스
            child: SizedBox(
              width: 70,
              height: 70,
              child: Image.asset(
                iconPath,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 5),
          // 앱 아이콘 제목
          Text(
            iconName,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white, shadows: [
              Shadow(
                color: Colors.black.withAlpha(100),
                blurRadius: 2.0,
                offset: const Offset(0, 2),
              )
            ]),
          ),
        ],
      ),
    );
  }
}
