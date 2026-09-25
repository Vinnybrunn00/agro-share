import 'package:flutter/material.dart';

abstract class NavigatorsApp {
  static Future<void> pushAndRemoveUntil(BuildContext context, Widget page) async {
    await Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => page),
      (route) => false,
    );
  }

  static Future<void> push(BuildContext context, Widget page) async {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }
}
