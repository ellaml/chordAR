
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/live_mode/camera.dart';
import 'package:flutter_complete_guide/globals.dart' as globals;
//List<Widget> listOfCordPointWidgets = [];

class LiveModeScreen extends StatelessWidget {

 @override
  Widget build(BuildContext context) {
   globals.progressionMode=false;
   return Camera();
  }
}