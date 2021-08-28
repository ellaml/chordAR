import 'package:flutter/material.dart';
import '../models/chord.dart';

class Progression with ChangeNotifier {
  String id;
  String name;
  List<Chord> chords;
  int interval = 5; // seconds

  Progression({String id, List<Chord> chords, int interval, String name = ''}){
    this.id = id;
    this.chords = chords;
    this.interval = interval;
    this.name = name;
  }

}