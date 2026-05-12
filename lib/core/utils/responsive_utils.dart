import 'package:flutter/material.dart';

enum DeviceType { mobile, tablet, desktop }

class ResponsiveUtils {
  ResponsiveUtils._();

  static const double mobileBreakpoint  = 600;
  static const double tabletBreakpoint  = 1024;
  static const double desktopBreakpoint = 1440;

  static DeviceType getDeviceType(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w < mobileBreakpoint)  return DeviceType.mobile;
    if (w < tabletBreakpoint)  return DeviceType.tablet;
    return DeviceType.desktop;
  }

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileBreakpoint;

  static bool isTablet(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return w >= mobileBreakpoint && w < tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletBreakpoint;

  /// Safe horizontal padding that leaves at least 16 px on each side.
  static double getHorizontalPadding(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w < mobileBreakpoint)  return 16;
    if (w < tabletBreakpoint)  return 40;
    if (w < desktopBreakpoint) return 72;
    return ((w - 1280) / 2 + 72).clamp(72, 240);
  }

  static double getMaxWidth(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return w > 1280 ? 1280.0 : w;
  }

  static double fontSize(BuildContext context,
      {required double mobile, required double tablet, required double desktop}) {
    switch (getDeviceType(context)) {
      case DeviceType.mobile:  return mobile;
      case DeviceType.tablet:  return tablet;
      case DeviceType.desktop: return desktop;
    }
  }

  /// Linearly scale a value between two breakpoints.
  static double lerp(BuildContext context,
      {required double min, required double max,
       double fromWidth = mobileBreakpoint, double toWidth = desktopBreakpoint}) {
    final w = MediaQuery.of(context).size.width.clamp(fromWidth, toWidth);
    return min + (max - min) * ((w - fromWidth) / (toWidth - fromWidth));
  }

  static int gridCrossAxisCount(BuildContext context,
      {int mobile = 1, int tablet = 2, int desktop = 3}) {
    switch (getDeviceType(context)) {
      case DeviceType.mobile:  return mobile;
      case DeviceType.tablet:  return tablet;
      case DeviceType.desktop: return desktop;
    }
  }

  /// Section vertical padding — smaller on narrow screens
  static double sectionVPadding(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w < mobileBreakpoint) return 64;
    if (w < tabletBreakpoint) return 80;
    return 100;
  }
}
