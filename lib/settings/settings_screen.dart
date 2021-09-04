import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/live_mode/scrollable_list.dart';
import 'package:flutter_complete_guide/models/chord.dart';
import 'package:flutter_complete_guide/utils.dart';

import 'chords_voice_recognition.dart';

class SettingsScreen extends StatelessWidget {
  List<Chord> _chordOptions = [];
  String chosenChord;

  _updateChosenChord(String chordName) {
    chosenChord = chordName;
    print(chosenChord);
  }

  @override
  Widget build(BuildContext context) {
    ScreenData screenData = ScreenData(context);
    _chordOptions = Chord.getChordOptions('');
    print(_chordOptions.length);
    return Scaffold(
        appBar: AppBar(), body: Container(
          child: 
            Container(
        height: screenData.screenHeight * 0.7,
        width: screenData.screenWidth * 0.2,
        alignment: Alignment.topRight,
        child: null)
          ));
  }
}
