import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class WeathergifView extends StatefulWidget {
  const WeathergifView({super.key});

  @override
  State<WeathergifView> createState() => _WeathergifViewState();
}

class _WeathergifViewState extends State<WeathergifView> {
  late VideoPlayerController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = VideoPlayerController.asset('assets/image/weather/weather_video.mov')..initialize();
    controller.setLooping(true);
    controller.play();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 700, height: 450, child: VideoPlayer(controller));
  }
}
