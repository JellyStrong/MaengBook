import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:maengBook/provider/weatherNewsProvider.dart';
import 'package:provider/provider.dart';

// class WeatherNewsView extends StatefulWidget {
//   const WeatherNewsView({super.key});
//
//   @override
//   State<WeatherNewsView> createState() => _WeatherNewsViewState();
// }
//
// class _WeatherNewsViewState extends State<WeatherNewsView> {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Expanded(
//         child: Column(
//           children: [
//             const Text(
//               '시흥 5동',
//               style: TextStyle(
//                 fontSize: 20.0,
//               ),
//             ),
//             const Text(
//               '오늘의 날씨는',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 25.0,
//                 color: Colors.blue,
//               ),
//             ),
//             Consumer<WeatherNewsProvider>(builder: (context, provider, child) {
//               return Text(
//                 provider.ultraSrtNcstItem[3]['obsrValue'],
//                 // '',
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 40.0,
//                 ),
//               );
//             }),
//             Consumer<WeatherNewsProvider>(builder: (context, provider, child) {
//               return const Text(
//                 // provider.vilageFcstItem[3]['category'],
//                 '',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 40.0,
//                 ),
//               );
//             }),
//             const Text(
//               '최저 9도 최고 21도',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 25.0,
//                 color: Colors.blue,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class WeatherNewsView extends StatefulWidget {
  const WeatherNewsView({super.key});

  @override
  State<WeatherNewsView> createState() => _WeatherNewsViewState();
}

class _WeatherNewsViewState extends State<WeatherNewsView> {
  Future init(BuildContext context) async {
    // context.read<WeatherNewsProvider>().getVilageFcst();
    //
    // context.read<WeatherNewsProvider>().getUltraSrtNcst();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   context.read<WeatherNewsProvider>().getVilageFcst();
    //   context.read<WeatherNewsProvider>().getUltraSrtNcst();
    // });
  }

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
    if (!provider.loding1 || !provider.loding2) {
      return const Center(child: CircularProgressIndicator());
    }

    return Expanded(
      child: Column(
        children: [
          const Text(
            '시흥 5동',
            style: TextStyle(
              fontSize: 20.0,
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
          Consumer<WeatherNewsProvider>(builder: (context, provider, child) {
            return Text(
              provider.ultraSrtNcstItem[3]['obsrValue'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40.0,
              ),
            );
          }),
          Consumer<WeatherNewsProvider>(builder: (context, provider, child) {
            print(  '>>> ${provider.vilageFcstItem}');

            return  Text(
              // provider.vilageFcstItem[3]['category'],
              '',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40.0,
              ),
            );
          }),
          const Text(
            '최저 9도 최고 21도',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25.0,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
