import 'package:flutter/material.dart';
import '../models/chord.dart';

class Progression with ChangeNotifier {
  String id;
  String name;
  List<ChordOption> chords;
  int interval = 5; // seconds

  Progression({String id, List<ChordOption> chords, int interval, String name = ''}){
    this.id = id;
    this.chords = chords;
    this.interval = interval;
    this.name = name;
  }

}