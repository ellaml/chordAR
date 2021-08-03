// import 'package:flutter/material.dart';
// import 'package:flutter_complete_guide/search_box.dart';
// import '../models/chord.dart';

// class Progression {
//   int id;
//   String name;
//   List<ChordOption> chords;
//   int interval = 5; // seconds

//   Progression(this.chords, this.interval, [String name]){
//     this.id = idCounter;
//     if (name == null){
//       this.name = this.chords.map((e) => e.name).toString();
//     }
//     else{
//       this.name = name;
//     }
//     idCounter++;
//   }

//   static int idCounter = 1;
// }

// List<Progression> mock_progressions = 
// [
//   Progression([ChordOption("Am"), ChordOption("F"), ChordOption("C"), ChordOption("G")], 4,"Basic"),
//   Progression([ChordOption("E"), ChordOption("B"), ChordOption("A"), ChordOption("D")], 3),
//   Progression([ChordOption("Em"), ChordOption("C"), ChordOption("D7"), ChordOption("A")], 5,"Hey you"),
//   Progression([ChordOption("F#m"), ChordOption("Cm"), ChordOption("Bm"), ChordOption("B7")], 4, "Boom"),
// ];