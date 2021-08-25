class ChordOption {
  final String name;

  ChordOption(this.name);

  static List<ChordOption> getChordOptions(String query) {
    return [
      'A',
      'A7',
      'Ab',
      'Am',
      'B',
      'B7',
      'Bb7',
      'Bbm',
      'Bm',
      'C',
      'C#m',
      'C7',
      'Cm',
      'D',
      'D7',
      'Db',
      'Dm',
      'E flat',
      'E',
      'E7',
      'Eb7',
      'Em',
      'F',
      'F#',
      'F#m',
      'F7',
      'Fm',
      'G',
      'G7',
      'Gm'
    ]
        .where((chordName) =>
            chordName.toLowerCase().contains(query.toLowerCase()))
        .map((chordName) => ChordOption(chordName))
        .toList();
  }
}
