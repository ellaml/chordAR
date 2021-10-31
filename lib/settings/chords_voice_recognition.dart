import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/cupertino.dart';
import 'package:flutter_complete_guide/globals.dart' as globals;

import '../chord_names.dart';

class SpeechScreen extends StatefulWidget {
  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {

  stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = '';
  double _confidence = 1.0;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return AvatarGlow(
          animate: _isListening,
          glowColor: Theme.of(context).primaryColor,
          endRadius: 75.0,
          duration: const Duration(milliseconds: 2000),
          repeatPauseDuration: const Duration(milliseconds: 100),
          repeat: true,
          child: FloatingActionButton(
            onPressed: _listen,
            child: Icon(_isListening ? Icons.mic : Icons.mic_none),
          ),
        );
  }
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
  String chordsReg(String s){
    s = s.toLowerCase();
    s = s.replaceAll('.', '');
    s = s.replaceAll('-', '');
    s = s.replaceAll(RegExp('\\s+'), '');
    s = s.replaceAll(RegExp('sharp'), '#');
    if(s == "see")
    {
      s="C";
    }
    else if(s == "be")
    {
      s="B";
    }
    else if(s == "if")
    {
      s="F";
    }
    else
    {
      s = capitalize(s);
    }
    return s;
  }
  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        globals.isMicTurnedOn = true;
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            print("before change: " + val.recognizedWords);
            _text = chordsReg(val.recognizedWords);
            print("After change: " + _text);
            if(chordNamesList.contains(_text))
            {
              globals.chordIsValid=true;
              globals.chord=_text;
              globals.chordTitle=_text;
              print("chord " + _text + " exists");
              globals.voiceError = "";
            }
            else {
              globals.chordIsValid=false;
              print(_text + " isn't a valid chord");
              globals.voiceError = _text + " isn't a valid chord"; 
            }
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }
}
