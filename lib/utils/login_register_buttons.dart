import 'package:flutter/material.dart';
import 'package:assignment_2/utils/theme.dart';

// From one of the buttons in flutter documentation - https://flutter.dev/docs/development/ui/widgets/material#Buttons

MaterialButton longButtons(String title, Function fun,
    {Color color: const Color(0xfff4267B2), Color textColor: Colors.white}) {
  return MaterialButton(
    onPressed: fun,
    textColor: textColor,
    color: color,
    child: SizedBox(
      width: double.infinity,
      child: Text(
        title,
        textAlign: TextAlign.center,
      ),
    ),
    height: 45,
    minWidth: 600,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10))),
  );
}
