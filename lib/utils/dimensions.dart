import 'package:flutter/material.dart';

class Dimens {
  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static double widthPercent(BuildContext context, double percent) =>
      screenWidth(context) * percent;

  static double heightPercent(BuildContext context, double percent) =>
      screenHeight(context) * percent;

  static const double paddingXS = 4;
  static const double paddingS = 8;
  static const double paddingM = 16;
  static const double paddingL = 24;
  static const double paddingXL = 32;

  static const double iconXS = 16;
  static const double iconS = 20;
  static const double iconM = 24;
  static const double iconL = 32;
  static const double iconXL = 48;

  static const double buttonHeight = 48;
  static const double buttonRadius = 12;

  static const double cardRadius = 16;
  static const double cardElevation = 4;

  static const double textSizeXS = 10;
  static const double textSizeS = 12;
  static const double textSizeM = 14;
  static const double textSizeL = 16;
  static const double textSizeXL = 20;
  static const double textSizeXXL = 24;
}