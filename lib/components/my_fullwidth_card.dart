import 'package:flutter/material.dart';

class MyFullWidthCard extends StatelessWidget {
  final String label;
  final Function onPressed;

  const MyFullWidthCard({
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: Card(
        margin: const EdgeInsets.all(5),
        elevation: 5,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          width: double.infinity,
          child: GestureDetector(
            child: Text(
              label,
              //style: kListNameStyle,
            ),
            onTap: () {
              return onPressed();
            },
          ),
        ),
      ),
    );
  }
}
