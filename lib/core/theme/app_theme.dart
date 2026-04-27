import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0B0B0F),
    textTheme: GoogleFonts.poppinsTextTheme(),
    primaryColor: Colors.white,
  );
}
