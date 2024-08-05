import 'package:flutter/material.dart';

class MyFullWidthContainer extends StatelessWidget {
  final String label;
  final Color bgColor;
  final Color borderColor;
  final Color textColor;
  final double textSize;

  MyFullWidthContainer({
    required this.label,
    required this.bgColor,
    required this.borderColor,
    required this.textColor,
    required this.textSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: textSize, color: textColor),
      ),
    );
  }
}
