import 'package:flutter/material.dart';

class ScrollService {
  static final controller = ScrollController();

  static void scrollTo(double offset) {
    controller.animateTo(
      offset,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOut,
    );
  }
}
