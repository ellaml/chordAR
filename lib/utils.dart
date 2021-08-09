import 'package:flutter/material.dart';

class ScreenData {
  MediaQueryData mediaQuery;
  double screenHeight;
  double screenWidth;
  bool isLandscape;
  bool isSmallLandscape;
  bool isBigLandscape;
  bool isBigPortrait;
  bool isBigDevice;

  ScreenData(context) {
    this.mediaQuery = MediaQuery.of(context);
    this.screenHeight = mediaQuery.size.height - 80;
    this.screenWidth = mediaQuery.size.width;
    this.isLandscape = mediaQuery.orientation == Orientation.landscape;
    this.isSmallLandscape = isLandscape && screenHeight < 500;
    this.isBigLandscape = isLandscape && screenHeight >= 500;
    this.isBigPortrait = !isLandscape && screenHeight > 900;
    this.isBigDevice = isBigLandscape || isBigPortrait;
  }
}
