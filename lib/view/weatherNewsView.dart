import 'dart:typed_data';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:maengBook/provider/weatherNewsProvider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

class WeatherNewsView extends StatefulWidget {
  const WeatherNewsView({super.key});

  @override
  State<WeatherNewsView> createState() => _WeatherNewsViewState();
}

class _WeatherNewsViewState extends State<WeatherNewsView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    /// 단기예보
    context.read<WeatherNewsProvider>().getVilageFcst();

    /// 초단기예보실황
    context.read<WeatherNewsProvider>().getUltraSrtNcst();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherNewsProvider>();
    // API통신 수행 중
    if (!provider.loading1 || !provider.loading2) {
      return const Center(child: CircularProgressIndicator());
    }
    final ScrollController scrollController = ScrollController();
    final GlobalKey listKey = GlobalKey();

    // WidgetsBinding.instance.addPostFrameCallback((_) {});
    double targetOffset = 0;
    bool leftMove;
    bool rightMove;
    void scrollByPage(String course) {
      final maxScroll = scrollController.position.maxScrollExtent; // 스크롤가능한 최대 길이(스크롤바의 활동 길이)
      final viewport = scrollController.position.viewportDimension; // 스크롤가능한 뷰(스크롤영역 레이아웃 길이)
      final totalWidth = maxScroll + viewport;

      if (course == '<') {
        targetOffset -= viewport;
        if (targetOffset < 0) {
          targetOffset = 0;
          leftMove = false;
        }
      } else if (course == '>') {
        targetOffset += viewport; //575
        if (targetOffset + viewport > totalWidth) {
          targetOffset = totalWidth - viewport;
          rightMove = false;
        }
      }
      scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn,
      );
    }

    return Expanded(
      child: Row(
        children: [
          Container(
            color: Colors.lightBlueAccent,
            width: 200,
            padding: const EdgeInsets.all(10),
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.blue[100 * ((index % 8) + 1)],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '서울',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '15:31',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '대체로 흐림',
                            style: TextStyle(
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '17도',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '최고 10도 / 최저 8도',
                            style: TextStyle(
                              fontSize: 9,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/image/weather/bg/sun.jpeg'), fit: BoxFit.cover),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 70),

                    /// 지역
                    const Text(
                      '시흥 5동',
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                    ),

                    /// 현재기온
                    Text(
                      provider.ultraSrtNcstItem[3]['obsrValue'],
                      style: const TextStyle(fontSize: 40.0, color: Colors.white),
                    ),

                    /// 하늘상태
                    Text(
                      skyStr(pty: provider.pty[0], sky: provider.sky[0]),
                      style: const TextStyle(fontSize: 15.0, color: Colors.white),
                    ),

                    /// 최고 최저 온도
                    const Text(
                      '최저 9도 최고 21도',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 70),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            print('클릭');
                            scrollByPage('<');
                          },
                          child: const Icon(
                            CupertinoIcons.chevron_compact_left,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        Container(
                          width: 595,
                          height: 140,
                          padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.5),
                            color: Colors.blue,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '맑은 상태가 하루 종일 이어지겠습니다. 돌풍의 풍속은 최대 5.6m/s 입니다.',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white,
                                ),
                              ),
                              const Divider(),
                              Expanded(
                                child: ListView.builder(
                                  // ListView.separated(
                                  // shrinkWrap: true,
                                  key: listKey,
                                  controller: scrollController,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: provider.time.length,
                                  // separatorBuilder: (context, index) => const SizedBox(width: 28),
                                  itemBuilder: (context, index) {
                                    return Container(
                                      width: 585 / 11,
                                      // color: index % 2 == 0 ? Colors.blue[100] : Colors.blue[50],
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            index == 0 ? '지금' : '${provider.time[index].toString()}시',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w900,
                                              fontSize: 13,
                                              color: Colors.white,
                                            ),
                                          ),
                                          skyIcons(provider: provider, index: index),
                                          Text(
                                            provider.tmp[index] + '°',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w900,
                                              fontSize: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            print('클릭');
                            scrollByPage('>');
                          },
                          child: const Icon(
                            CupertinoIcons.chevron_compact_right,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        basicBox(
                          width: 290,
                          height: 450,
                          title: '10일간의 일기예보',
                          icon: CupertinoIcons.calendar,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(),
                              Expanded(
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    final itemHeight = (constraints.maxHeight - (16 * 9)) / 10; // 16*9 = Divider()높이값
                                    return ScrollConfiguration(
                                      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                                      child: ListView.separated(
                                        separatorBuilder: (context, index) => const Divider(),
                                        itemCount: 10,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            height: itemHeight,
                                            color: Colors.blue[100 * ((index % 8) + 1)],
                                            child: Center(child: Text('Item $index')),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 15),
                        Column(
                          children: [
                            basicBox(
                              width: 295,
                              height: 295,
                              icon: CupertinoIcons.wind,
                              title: '바람지도',
                              child: Column(
                                children: [
                                  for (int i = 0; i < 10; i++) Text('아이템 $i'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                            basicBox(
                              width: 295,
                              height: 140,
                              icon: CupertinoIcons.calendar,
                              title: '대기질',
                              child: Column(
                                children: [
                                  Text('58'),
                                  Text('대기질'),
                                  Container(
                                    width: double.infinity,
                                    height: 10,
                                    color: Colors.red,
                                    child: Text(''),
                                  ),
                                  Text('현재의 대기질 지수는 58이며, 어제의 이시간과 비슷합니다.'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        basicBox(
                          width: 295,
                          height: 140,
                          icon: Icons.add,
                          title: '상현망간의 달',
                          child: Text('상현망간의 달'),
                        ),
                        const SizedBox(width: 15),
                        basicBox(
                          width: 295,
                          height: 140,
                          icon: Icons.add,
                          title: '바람',
                          child: Text('바 달'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        basicBox(width: 140, height: 140, icon: CupertinoIcons.sun_max_fill, title: '자외선 지수', child: Text('')),
                        const SizedBox(width: 15),
                        basicBox(width: 140, height: 140, icon: CupertinoIcons.sunset_fill, title: '일몰', child: Text('')),
                        const SizedBox(width: 15),
                        basicBox(width: 140, height: 140, icon: CupertinoIcons.thermometer, title: '체감 온도', child: Text('')),
                        const SizedBox(width: 15),
                        basicBox(width: 140, height: 140, icon: CupertinoIcons.drop_fill, title: '강수량', child: Text('')),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        basicBox(width: 140, height: 140, icon: CupertinoIcons.eye_solid, title: '가시거리', child: Text('')),
                        const SizedBox(width: 15),
                        basicBox(width: 140, height: 140, icon: CupertinoIcons.drop, title: '습도', child: Text('')),
                        const SizedBox(width: 15),
                        basicBox(width: 140, height: 140, icon: CupertinoIcons.wind, title: '기압', child: Text('')),
                        const SizedBox(width: 15),
                        basicBox(width: 140, height: 140, icon: CupertinoIcons.graph_square, title: '평균', child: Text('')),
                      ],
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      '시흥 5동 날씨',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget basicBox({
  required double width,
  required double height,
  required String title,
  required Widget child,
  required IconData icon,
}) {
  return Container(
    width: width,
    height: height,
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.circular(6.5),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 10,
              color: const Color(0x99FFFFFF),
            ),
            const SizedBox(width: 5),
            Text(
              title,
              style: const TextStyle(
                fontSize: 10,
                color: Color(0x99FFFFFF),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Expanded(child: child),
      ],
    ),
  );
}

String skyStr({required String sky, required String pty}) {
  if (pty != '0') {
    if (pty == '1') {
      return '비'; // 비
    } else if (pty == '2') {
      return '비/눈'; // 비/눈
    } else if (pty == '3') {
      return '눈'; // 눈
    } else if (pty == '4') {
      return '소나기'; // 소나기
    } else {
      return '';
    }
  } else {
    if (sky == '1') {
      return '맑음'; // 맑음
    } else if (sky == '3') {
      return '구름많음'; // 구름많음
    } else if (sky == '4') {
      return '흐림'; // 흐림
    } else {
      return '';
    }
  }
}

Icon skyIcon({required String sky, required String pty}) {
  print('sky: $sky, pty: $pty');
  if (pty != '0') {
    if (pty == '1') {
      return const Icon(CupertinoIcons.cloud_rain_fill, size: 16, color: Colors.white); // 비
    } else if (pty == '2') {
      return const Icon(CupertinoIcons.cloud_sleet_fill, size: 16, color: Colors.white); // 비/눈
    } else if (pty == '3') {
      return const Icon(CupertinoIcons.cloud_snow_fill, size: 16, color: Colors.white); // 눈
    } else if (pty == '4') {
      return const Icon(CupertinoIcons.cloud_heavyrain_fill, size: 16, color: Colors.white); // 소나기
    } else {
      return const Icon(CupertinoIcons.exclamationmark_triangle_fill, size: 16, color: Colors.white);
    }
  } else {
    if (sky == '1') {
      return const Icon(CupertinoIcons.sun_max_fill, size: 16, color: Colors.white); // 맑음
    } else if (sky == '3') {
      return const Icon(CupertinoIcons.cloud_sun_fill, size: 16, color: Colors.white); // 구름많음
    } else if (sky == '4') {
      return const Icon(CupertinoIcons.cloud_fill, size: 16, color: Colors.white); // 흐림
    } else {
      return const Icon(CupertinoIcons.exclamationmark_triangle_fill, size: 16, color: Colors.white);
    }
  }
}

Widget skyIcons({required WeatherNewsProvider provider, required int index}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      skyIcon(sky: provider.sky[index], pty: provider.pty[index]),
      if (provider.pty[index] != '0')
        Text(
          provider.pop[index] + '%',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
    ],
  );
}
