import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/live_mode/live_mode_camera_preview.dart';

List<Widget> listOfCordPointWidgets = [];

class LiveModeScreen extends StatelessWidget {

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Text('Live Mode'),
          Camera(),
          ...listOfCordPointWidgets,
        ],
      )



    );
  }
}