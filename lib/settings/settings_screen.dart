import 'package:flutter/material.dart';

import 'chords_voice_recognition.dart';

class SettingsScreen extends StatelessWidget {

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
        body: Column(
            children: [
              Text("Settings"),
              Container(height: 100, child: SpeechScreen())
            ]
    ));
  }
}