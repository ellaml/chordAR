import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/live_mode/live_mode_camera_preview.dart';

class LiveModeScreen extends StatelessWidget {

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text('Live Mode'),
          LiveModeCameraPreview(),
          //...listOfCordPointWidgets,
        ],
      )



    );
  }
}