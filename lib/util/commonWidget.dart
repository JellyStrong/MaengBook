import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import '../model/deviceInfo.dart';
import '../provider/deviceInfoProvider.dart';
import '../model/model.dart';
import '../provider/macWallPaperProvider.dart';
import '../util/util.dart';
import 'util.dart';

/* WindowControlsBtn
 * windowControlsBtn()
 * buttons()
 *
 * */

/* IconWidget
 * myImage()
 * myApp()
 *
 * */

class WindowControlsBtn {
  /// window control 버튼 이벤트 관련 (공통)
  Widget windowControlsBtn({
    required BuildContext context,
    required ValueKey valueKey,
    required WindowControls provider,
    required String iconName,
    Map<String, dynamic>? overlayEntry,
    required IconData icon,
    required Color color,
    required String str,
    required OverlayEntry overlay,
  }) {
    return InkWell(
      onTap: () {
        context.read<WindowControls>().btnClick(
              key: valueKey,
              context: context,
              iconName: iconName,
              str: str,
              model: model,
            );
      },
      onHover: (hover) {
        //TODO: 현재 3초뒤 메뉴 띄우기 기능 잠시 중단 24.12.28
        // Future.delayed(
        //   const Duration(milliseconds: 1500),
        //   () {
        //     if (context.mounted) {
        //       context.read<WindowControls>().btnHoverMenu(
        //             key: valueKey,
        //             context: context,
        //           );
        //     }
        //   },
        // );
      },
      child: Stack(
        key: valueKey,
        children: [
          Container(
            height: 14,
            width: 14,
            decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(7)), color: color),
            child: Visibility(
              visible: provider.hover,
              child: Icon(
                icon,
                size: 12,
              ),
            ),
          ),

          // menu
          Transform.translate(
            offset: WindowControls().getMenuOffset(context),
            child: Visibility(
              visible: valueKey == provider.key,
              child: Container(
                height: 20,
                width: 3,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// window control 버튼 그리기 (빨,노,초) (공통)
  Widget buttons(OverlayEntry overlay, String iconName) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8.0),
      child: SizedBox(
        height: 15,
        width: 60,
        child: Consumer<WindowControls>(
          builder: (context, provider, child) {
            return InkWell(
              onTap: () {},
              onHover: (hover) {
                //TODO: hover 기능이 없는 터치기반 플랫폼은 디폴트 아이콘 보여주기
                context.read<WindowControls>().btnHover(
                      context: context,
                      hover: hover,
                      model: model,
                    );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  windowControlsBtn(
                    context: context,
                    valueKey: const ValueKey(100),
                    provider: provider,
                    iconName: iconName,
                    icon: Icons.close_rounded,
                    color: Colors.red,
                    str: 'close',
                    overlay: overlay,
                  ),
                  windowControlsBtn(
                    context: context,
                    valueKey: const ValueKey(101),
                    provider: provider,
                    iconName: iconName,
                    icon: Icons.remove_rounded,
                    color: Colors.yellow,
                    str: 'minimize',
                    overlay: overlay,
                  ),
                  windowControlsBtn(
                    context: context,
                    valueKey: const ValueKey(102),
                    provider: provider,
                    iconName: iconName,
                    icon: Icons.add_rounded,
                    color: Colors.green,
                    str: 'maximize',
                    overlay: overlay,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class IconWidget {
  Widget myImage({
    required BuildContext context,
    required Widget child,
    required String iconPath,
    required String iconName,
    required double maxWidth,
    required double maxHeight,
    List<Widget>? entry,
    Color? backGround,
  }) {
    // Future와 then을 사용하여 비동기 처리
    ImagesGetInfo().getImageSize(iconPath).then((result) {
      print('result: $result');
    }).catchError((error) {
      print("오류 발생: $error");
    });
    return Image.asset(iconPath);
  }

  void contentType(String type) {
    switch (type) {
      case 'app':
        break;
      case 'image':
        break;
    }
  }

  /// 브라우저(틀) 사이즈 리턴
  bool sizez(BuildContext context, String path) {
    double deviceWidth = DeviceInfo().getWidth(context);
    double deviceHeight = DeviceInfo().getHeight(context);
    bool sizeSHow = false;
    Map<dynamic, dynamic> imageInfo = {};
    // Future와 then을 사용하여 비동기 처리
    ImagesGetInfo().getImageSize(path).then((result) {
      print('result: $result');
      imageInfo = result;
    }).catchError((error) {
      print("오류 발생: $error");
    });

    if (500 > imageInfo['imageWidth']) {
      // 기본 500 200
      sizeSHow = true;
    }
    if (200 > imageInfo['imageHeight']) {
      sizeSHow = true;
      // 가로가 길면
    }
    return sizeSHow;
  }

  /// 이미지일 경우 해당
  Widget myPicture({
    required BuildContext context,
    required Widget child,
    required String iconPath,
    required String iconName,
    required double maxWidth,
    required double maxHeight,
    // required String type,
    List<Widget>? entry,
    Color? backGround,
  }) {
    // Future와 then을 사용하여 비동기 처리
    ImagesGetInfo().getImageSize(iconPath).then((result) {
      print('result: $result');
    }).catchError((error) {
      print("오류 발생: $error");
    });

    print('iconPath:$iconPath, iconName:$iconName, maxWidth:$maxWidth, maxHeight:$maxHeight ');
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
                        constraints: BoxConstraints(maxWidth: 500, maxHeight: 200),
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

  /// 일반적인 앱일 경우 해당
  Widget myApp({
    required BuildContext context,
    required Widget child,
    required String iconPath,
    required String iconName,
    required double maxWidth,
    required double maxHeight,
    List<Widget>? entry,
    Color? backGround,
  }) {
    print('iconPath:$iconPath, iconName:$iconName, maxWidth:$maxWidth, maxHeight:$maxHeight ');
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
