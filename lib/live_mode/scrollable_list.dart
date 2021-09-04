import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/chord.dart';
import 'package:flutter_complete_guide/utils.dart';
import '../app_colors.dart' as appColors;

class ScrollableList extends StatefulWidget {
  final Function callBack;
  final Function closeListCallBack;

  const ScrollableList(this.callBack, this.closeListCallBack);

  @override
  State<StatefulWidget> createState() {
    return _ScrollableListState();
  }
}

class _ScrollableListState extends State<ScrollableList> {
  List<Chord> _chordOptions = [];
  String chosenChord;

  @override
  void initState() {
    setState(() => _chordOptions = Chord.getChordOptions(''));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenData screenData = ScreenData(context);
    double chordBoxWidth = screenData.isBigDevice ? 90 : 60;
    double chordBoxHeight = screenData.isBigDevice ? 70 : 50;

    return Container(
        padding: EdgeInsets.all(5),
        constraints: new BoxConstraints(
          maxHeight: screenData.screenHeight * 0.85,
        ),
        decoration: BoxDecoration(
          color: appColors.backgroundColor,
          boxShadow: [
            BoxShadow(
                color: appColors.notesWidgetGlow,
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(2, 2))
          ],
          borderRadius: BorderRadius.circular(10),
          //boxShadow: [BoxShadow(color: appColors.lightPurpleShadow, blurRadius: 1, offset: Offset(2,2))],
          border: Border.all(color: appColors.borderPurple, width: 2),
        ),
        child: Column(children: [
          Container(
              height: screenData.screenHeight * 0.75,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                    children: _chordOptions
                        .map((chordOption) => GestureDetector(
                            onTap: () => {
                                  chosenChord = chordOption.name,
                                  widget.callBack(chordOption.name),
                                },
                            child: Container(
                                width: chordBoxWidth,
                                height: chordBoxHeight,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    boxShadow: chosenChord == chordOption.name
                                        ? [
                                            BoxShadow(
                                                color: Colors.white12,
                                                offset: Offset(2, 2),
                                                blurRadius: 20)
                                          ]
                                        : null,
                                    color: this.chosenChord == chordOption.name
                                        ? Color(0x60FFFFFF)
                                        : null,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    border: Border.all(
                                        width: 2,
                                        color: appColors.borderPurple)),
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.all(10),
                                child: Text(
                                  chordOption.name,
                                  style: TextStyle(
                                      fontSize: 0.3 * chordBoxHeight,
                                      fontWeight: FontWeight.bold),
                                ))))
                        .toList()),
              )),
          GestureDetector(
              onTap: () => widget.closeListCallBack(),
              child: RotationTransition(
                  turns: new AlwaysStoppedAnimation(90 / 360),
                  child: Container(
                      height: 30,
                      width: 30,
                      margin: EdgeInsets.all(10),
                      child: Image.asset('assets/icons/back-white64.png'))))
        ]));
  }
}
