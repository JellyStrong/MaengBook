import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:maengBook/provider/macWallPaperViewProvider.dart';
import 'package:maengBook/util/util.dart';
import 'package:maengBook/util/commonWidget.dart';
import 'calculatorView.dart';

class MacWallPaperView extends StatelessWidget {
  const MacWallPaperView({super.key});

  @override
  Widget build(BuildContext context) {
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
                              child: calculatorView(context),
                              iconName: '계산기',
                              iconPath: 'assets/image/icon/calculator.png',
                              maxWidth: 233,
                              maxHeight: 323,
                              backGround: Colors.blue,
                            ),
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
}
