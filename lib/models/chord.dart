class Chord {
  final String name;

  Chord(this.name);

  static List<Chord> getChordOptions(String query) {
    return [
      'A',
      'A7',
      'Ab',
      'Am',
      'B',
      'B7',
      'Bb'
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
      'Eb',
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
      'Gm',
      'G#m'
    ]
        .where((chordName) =>
            chordName.toLowerCase().contains(query.toLowerCase()))
        .map((chordName) => Chord(chordName))
        .toList();
  }

  static String getChordPosition(String chordName) {
    String position;
    switch (chordName) {
      case 'A':
        position = "x,0,2,2,2,0";
        break;
      case 'A7':
        position = "x,0,2,0,2,0";
        break;
      case 'Ab':
        position = "4,6,6,5,4,4";
        break;
      case 'Am':
        position = "x,0,2,2,1,0";
        break;
      case 'B':
        position = "x,2,4,4,4,2";
        break;
      case 'B7':
        position = "x,2,1,2,0,2";
        break;
      case 'Bb':
        position = "x,1,3,3,3,1";
        break;
      case 'Bb7':
        position = "x,1,3,1,3,1";
        break;
      case 'Bbm':
        position = "x,1,3,3,2,1";
        break;
      case 'Bm':
        position = "x,2,4,4,3,2";
        break;
      case 'C':
        position = "x,3,2,0,1,0";
        break;
      case 'C#m':
        position = "x,4,6,6,5,4";
        break;
      case 'C7':
        position = "x,3,2,3,1,0";
        break;
      case 'Cm':
        position = "x,3,5,5,4,3";
        break;
      case 'D':
        position = "x,x,0,2,3,2";
        break;
      case 'D7':
        position = "x,x,0,2,1,2";
        break;
      case 'Db':
        position = "x,4,3,1,2,1";
        break;
      case 'Dm':
        position = "x,x,0,2,3,1";
        break;
      case 'Eb':
        position = "x,x,1,3,4,3";
        break;
      case 'E':
        position = "0,2,2,1,0,0";
        break;
      case 'E7':
        position = "0,2,0,1,0,0";
        break;
      case 'Eb7':
        position = "x,x,1,0,2,3";
        break;
      case 'Em':
        position = "0,2,2,0,0,0";
        break;
      case 'F':
        position = "x,x,3,2,1,1";
        break;
      case 'F#':
        position = "x,x,4,3,2,2";
        break;
      case 'F#m':
        position = "2,4,4,2,2,2";
        break;
      case 'F7':
        position = "1,3,1,2,1,1";
        break;
      case 'Fm':
        position = "x,3,0,1,1,1";
        break;
      case 'G':
        position = "3,2,0,0,0,3";
        break;
      case 'G7':
        position = "3,2,0,0,0,1";
        break;
      case 'Gm':
        position = "3,1,0,0,3,3";
        break;
      case 'G#m':
        position = "4,6,6,4,4,4";
        break;
      default:
        position = "";
        break;
    }
    return position;
  }
}
