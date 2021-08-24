import 'package:flutter/material.dart';
import 'progression.dart';
import '../models/chord.dart';
import '../helpers/db_helper.dart';

class Progressions with ChangeNotifier {
  List<Progression> _items = [];

  List<Progression> get items {
    return [..._items];
  }

  Progression findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  void addProgression(Progression progression) {
    final newProgression = Progression(
      id: DateTime.now().toString(),
      chords: progression.chords,
      interval: progression.interval,
      name: progression.name,
    );

    _items.add(newProgression);
    idCounter++;
    notifyListeners();
    String chords = formatChordsForDb(newProgression.chords);
    DBHelper.insert('user_progressions', {
      'id': newProgression.id,
      'chords': chords,
      'interval': newProgression.interval,
      'name': newProgression.name
    });
  }

  void removeProgression(String progId) {
    _items.removeWhere((element) => element.id == progId);
    notifyListeners();
    DBHelper.remove('user_progressions', progId);
  }

  void updateProgression(String id, Progression newProgression) {
    final progIndex = _items.indexWhere((prog) => prog.id == id);
    if (progIndex >= 0) {
      _items[progIndex] = newProgression;
      notifyListeners();
      String chords = formatChordsForDb(newProgression.chords);
      DBHelper.insert('user_progressions', {
        'id': newProgression.id,
        'chords': chords,
        'interval': newProgression.interval,
        'name': newProgression.name
      });
    } else {
      print('progression was found when trying to update');
    }
  }

  Future<void> fetchAndSetProgs() async {
    final dataList = await DBHelper.getData('user_progressions');
    _items = dataList
        .map((item) => Progression(
            id: item['id'],
            name: item['name'],
            interval: item['interval'],
            chords: createListFromText(item['chords'])))
        .toList();
    notifyListeners();
  }

  List<ChordOption> createListFromText(String chordsAsText) {
    List<ChordOption> chords = (chordsAsText.split(',')).map((text) => ChordOption(text)).toList();
    return chords;
  }

  static int idCounter = 5;

  String formatChordsForDb(List<ChordOption> chords) {
    String chordsString = chords.map((e) => e.name).toList().toString();
    return chordsString.substring(1, chordsString.length - 1);
  }
}

/* mock progressions 
    Progression(id: 1, chords:[ChordOption("Am"), ChordOption("F"), ChordOption("C"), ChordOption("G")], interval: 4, name: "Basic"),
    Progression(id: 2, chords:[ChordOption("E"), ChordOption("B"), ChordOption("A"), ChordOption("D")], interval: 3),
    Progression(id: 3, chords:[ChordOption("Em"), ChordOption("C"), ChordOption("D7"), ChordOption("A")], interval: 5, name:"Hey you"),
    Progression(id: 4, chords:[ChordOption("F#m"), ChordOption("Cm"), ChordOption("Bm"), ChordOption("B7")], interval: 4, name:"Boom")
    */