import 'package:flutter/material.dart';
import '../search_box.dart';
import '../chord_names.dart' as chordNames;
import '../utils.dart';

class ChordSearch extends StatefulWidget {
  @override
  _ChordState createState() => _ChordState();
}

class _ChordState extends State<ChordSearch> {
  String selectedChord = '';
  String fullPath;

  void _updateChord(String chordName) {
    if (chordNames.chordNamesList.contains(chordName)) {
      setState(() {
        selectedChord = chordName;
        fullPath = 'assets/chords/' + chordName + '.png';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenData screenData = ScreenData(context);
    Expanded chordImage = Expanded(
        child: selectedChord == ''
            ? Container()
            : Container(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.white12,
                            offset: Offset(2, 2),
                            blurRadius: 20)
                      ],
                      color: Colors.white,
                      border: Border.all(width: 2, color: Colors.black)),
                  padding: EdgeInsets.symmetric(horizontal: 55, vertical: 25),
                  child: Container(
                      color: Colors.white,
                      height: (screenData.isBigDevice ? 1.5 : 1.0) * 275,
                      width: (screenData.isBigDevice ? 1.5 : 1.0) * 182,
                      margin: EdgeInsets.all(10),
                      child: Image.asset(this.fullPath)),
                )
              ])));
    return Container(
      child: screenData.isSmallLandscape
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    height: screenData.screenHeight * 0.5,
                    child:
                        SearchBox(_updateChord, screenData.screenWidth * 0.4)),
                chordImage
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SearchBox(_updateChord, screenData.screenWidth * 0.7),
                chordImage,
              ],
            ),
    );
  }
}