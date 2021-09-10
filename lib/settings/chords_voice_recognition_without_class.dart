
import 'package:flutter_complete_guide/globals.dart' as globals;
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/cupertino.dart';

import '../chord_names.dart';

stt.SpeechToText _speech;
bool _isListening = false;
String _text = '';
double confidence = 1.0;

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
String chords_reg(String s){
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

/*
void _listen() async {
  if (!_isListening) {
    bool available = await _speech.initialize(
      onStatus: (val) => print('onStatus: $val'),
      onError: (val) => print('onError: $val'),
    );
    if (available) {
      globals.isMicTurnedOn = true;
      _isListening = true;
      _speech.listen( onResult: (val) => { print("a"), print("b")});
    }
  }
}
 */

void listenNew1() async {
  if(_speech == null)
  {
    _speech = stt.SpeechToText();
  }
  print("***********in listenNew1********************");
  if (!_isListening) {
    print("is not listening");
    bool available = await _speech.initialize(
      onStatus: (val) => print('onStatus: $val'),
      onError: (val) => print('onError: $val'),
    );
    print("available:::");
    print(available);
    if (available) {
      print("available");
      globals.isMicTurnedOn = true;
      _isListening = true;
      _speech.listen(
        onResult: (val) => {
          print("the result:"),
          print(val.recognizedWords)
          //doing_things(val)
        });
    }
  } else {
    print("is listening");
    _isListening = false;
    _speech.stop();
  }
}

void doing_things(val)
{
  print("before change: ");
  _text = chords_reg(val.recognizedWords);
  print("After change: " + _text);
  if(chordNamesList.contains(_text))
  {
    globals.chordIsValid=true;
    globals.chord=_text;
    print("chord " + _text + " exists");
    globals.voiceError = "";
  }
  else {
  globals.chordIsValid=false;
  print(_text + " isn't a valid chord");
  globals.voiceError = _text + " isn't a valid chord";
  }
  if(val.hasConfidenceRating && val.confidence > 0) {
    confidence = val.confidence;
  }
}
