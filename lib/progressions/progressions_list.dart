import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/progressions/edit_progression_screen.dart';
import 'package:flutter_complete_guide/progressions/single_progression.dart';
import '../search_box.dart';
import 'package:provider/provider.dart';
import '../providers/progressions.dart';
import '../providers/progression.dart';
import '../utils.dart';

class ProgressionsList extends StatefulWidget {
  @override
  _ProgressionsListState createState() => _ProgressionsListState();
}

class _ProgressionsListState extends State<ProgressionsList> {
  String selectedChord = '';
  String fullPath;
  List<Progression> displayedProgressions = [];

  @override
  void initState() {
    super.initState();
  }
  
  void _updateList(String chordName) {
    setState(() {
      displayedProgressions
          .map((progression) => progression.chords.contains(chordName));
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenData screenData = ScreenData(context);
    final progressionsData = Provider.of<Progressions>(context);
    final progressions = progressionsData.items;
    Container searchBoxContainer = Container(
        child: SearchBox(_updateList, screenData.screenWidth * 0.7));
    Container plusContainer = Container(
      height: screenData.screenHeight * 0.1,
        margin: EdgeInsets.all(20),
        alignment: Alignment.center,
        child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(EditProgressionScreen.routeName);
            },
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(child: Image.asset('assets/icons/plus64.png')),
              Container(
                  margin: EdgeInsets.all(20),
                  child: Text(
                    "Add new Progression",
                    style: TextStyle(
                      fontSize: 0.03 * screenData.screenHeight,
                      color: Colors.white),
                  ))
            ])));
    Container listContainer = Container(
      height: screenData.screenHeight * 0.6,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: progressions
              .map((progression) => SingleProgression(
                  progression.name == ''
                      ? progression.chords.map((e) => e.name).toString()
                      : progression.name,
                 progression.id, 0.7 * screenData.screenWidth, 0.1 * screenData.screenHeight))
              .toList(),
        ),
      ),
    );
    return Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          searchBoxContainer,
          screenData.isSmallLandscape
              ? Row(
                  children: [
                    Container(
                      height: screenData.screenHeight * 0.6,
                      width: screenData.screenWidth * 0.6,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: progressions
                              .map((progression) => SingleProgression(
                                  progression.name == ''
                                      ? progression.chords
                                          .map((e) => e.name)
                                          .toString()
                                      : progression.name,
                                  progression.id, 0.7 * screenData.screenWidth, 0.1 * screenData.screenHeight))
                              .toList(),
                        ),
                      ),
                    ),
                    plusContainer,
                  ],
                )
              : Column(
                  children: [
                    listContainer,
                    plusContainer,
                  ],
                )
        ]);
  }
}