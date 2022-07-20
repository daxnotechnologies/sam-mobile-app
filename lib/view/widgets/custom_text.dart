import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
   CustomText({
    Key? key,
    this.text,
    this.size,
    this.fontWeight,
    this.color = const Color.fromARGB(255, 17, 24, 51),
    this.overflow
  }) : super(key: key);

  final String? text;
  final double? size;
  final FontWeight? fontWeight;
  final Color? color;
  var overflow;
  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? '',
      textAlign: TextAlign.left,
      maxLines: 2,
      overflow: overflow??overflow,
      style: TextStyle(
        fontFamily: 'Satoshi',
        fontSize: size!,
        fontWeight: fontWeight ?? FontWeight.w400,
        color: color,
      ),
    );
  }
}
