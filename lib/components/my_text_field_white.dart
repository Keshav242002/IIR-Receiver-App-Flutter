import 'package:flutter/material.dart';
import '../../../utils/constants.dart';

// ignore: camel_case_types
class MyTextFieldWhite extends StatelessWidget {
  final Icon displayIcon;
  final String displayLabel;
  final Function onChanged;
  final bool isLast;
  final bool isNumber;
  final bool isPassword;
  final TextEditingController controller;

  const MyTextFieldWhite(
      {super.key,
      required this.displayIcon,
      required this.isPassword,
      required this.controller,
      required this.isNumber,
      required this.isLast,
      required this.displayLabel,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: TextField(
          style: const TextStyle(color: kColorText),
          decoration: InputDecoration(
            prefixIcon: displayIcon,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue),
              borderRadius: BorderRadius.circular(5),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue),
              borderRadius: BorderRadius.circular(5),
            ),
            enabled: true,
            labelText: displayLabel,
            labelStyle: const TextStyle(color: Colors.blueGrey),
          ),
          onChanged: (_) => onChanged,
          obscureText: isPassword,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          textInputAction: isLast ? TextInputAction.done : TextInputAction.next,
          controller: controller,
          onSubmitted: (_) => isLast
              ? FocusScope.of(context).unfocus()
              : FocusScope.of(context).nextFocus()),
    );
  }
}
