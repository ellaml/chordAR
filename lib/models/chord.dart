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
      'Bb',
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


static List<int> getChordBar(String chordName) {
    List<int> bar;
    switch (chordName) {
      case 'A':
        bar = [];
        break;
      case 'A7':
        bar = [];
        break;
      case 'Ab':
    		bar = [0,5];
        //position = "4,6,6,5,4,4";
        break;
      case 'Am':
        bar = [];
        break;
      case 'B':
		    bar = [1,5];
        //position = "x,2,4,4,4,2";
        break;
      case 'B7':
        bar = [];
        break;
      case 'Bb':
		    bar = [1,5];
        //position = "x,1,3,3,3,1";
        break;
      case 'Bb7':
		    bar = [1,5];
        //position = "x,1,3,1,3,1";
        break;
      case 'Bbm':
		    bar = [1,5];
        //position = "x,1,3,3,2,1";
        break;
      case 'Bm':
		    bar = [1,5];
        // position = "x,2,4,4,3,2";
        break;
      case 'C':
        bar = [];
        break;
      case 'C#m':
		    bar = [1,5];
        //position = "x,4,6,6,5,4";
        break;
      case 'C7':
		    bar = [];
        break;
      case 'Cm':
		    bar = [1,5];
        //position = "x,3,5,5,4,3";
        break;
      case 'D':
        bar = [];
        break;
      case 'D7':
        bar = [];
        break;
      case 'Db':
		    bar = [3,5];
        //position = "x,4,3,1,2,1";
        break;
      case 'Dm':
        bar = [];
        break;
      case 'Eb':
        bar = [];
        break;
      case 'E':
        bar = [];
        break;
      case 'E7':
        bar = [];
        break;
      case 'Eb7':
        bar = [];
        break;
      case 'Em':
        bar = [];
        break;
      case 'F':
		    bar = [4,5];
        // position = "x,x,3,2,1,1";
        break;
      case 'F#':
        bar = [];
        break;
      case 'F#m':
        bar = [0,5];
        break;
      case 'F7':
		    bar = [0,5];
        //position = "1,3,1,2,1,1";
        break;
      case 'Fm':
		    bar = [3,5]
        //position = "x,3,0,1,1,1";
        break;
      case 'G':
        bar = [];
        break;
      case 'G7':
        bar = [];
        break;
      case 'Gm':
        bar = [];
        break;
      case 'G#m':
    		bar = [0,5];
        // position = "4,6,6,4,4,4";
        break;
      default:
        bar = [];
        break;
    }
    return bar;
  }
}