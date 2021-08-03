import 'package:flutter/material.dart';
import 'progression.dart';
import '../models/chord.dart';

class Progressions with ChangeNotifier {
  List<Progression> _items = [
  Progression(id: 1, chords:[ChordOption("Am"), ChordOption("F"), ChordOption("C"), ChordOption("G")], interval: 4, name: "Basic"),
  Progression(id: 2, chords:[ChordOption("E"), ChordOption("B"), ChordOption("A"), ChordOption("D")], interval: 3),
  Progression(id: 3, chords:[ChordOption("Em"), ChordOption("C"), ChordOption("D7"), ChordOption("A")], interval: 5, name:"Hey you"),
  Progression(id: 4, chords:[ChordOption("F#m"), ChordOption("Cm"), ChordOption("Bm"), ChordOption("B7")], interval: 4, name:"Boom")
  ];

  List<Progression> get items {
    return [..._items];
  }

  Progression findById(int id) {
    return _items.firstWhere((element) => element.id == id);
  }

  void addProgression(Progression progression) {
    final newProgression = Progression(
      id: idCounter,
      chords: progression.chords,
      interval: progression.interval,
      name: progression.name,
    );

    _items.add(newProgression);
    idCounter++;
    notifyListeners();
  }

  void removeProgression(int progId) {
    _items.removeWhere((element) => element.id == progId);
    notifyListeners();
  }

    void updateProgression(int id, Progression newProgression) {
    final progIndex = _items.indexWhere((prog) => prog.id == id);
    if (progIndex >= 0) {
      _items[progIndex] = newProgression;
      notifyListeners();
    } else {
      print('...');
    }
  }

  static int idCounter = 5;
}