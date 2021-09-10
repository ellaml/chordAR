
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/live_mode/camera.dart';
import 'package:flutter_complete_guide/globals.dart' as globals;
//List<Widget> listOfCordPointWidgets = [];

class LiveModeScreen extends StatelessWidget {
  static const routeName = '/live-mode';
 @override
  Widget build(BuildContext context) {
  final colorCode = ModalRoute.of(context).settings.arguments as int;
   globals.progressionMode=false;
   return Camera(colorCode);
  }
}