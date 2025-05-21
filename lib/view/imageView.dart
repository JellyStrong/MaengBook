import 'package:flutter/material.dart';

class ImageView extends StatelessWidget {
  const ImageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset('');
  }
}
Widget imageView(String imagePath){
  return Image.asset(imagePath);
}