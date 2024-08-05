import 'package:flutter/material.dart';

import '../utils/constants.dart';


class AppBarContainer extends StatelessWidget {
  const AppBarContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Colors.blue,
          Colors.black,
        ],
      )),
    );
  }
}
