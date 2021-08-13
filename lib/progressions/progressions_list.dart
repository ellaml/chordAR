import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/progressions/edit_progression_screen.dart';
import 'package:flutter_complete_guide/progressions/single_progression.dart';
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

  @override
  Widget build(BuildContext context) {
    ScreenData screenData = ScreenData(context);
    final progressionsData = Provider.of<Progressions>(context);
    final progressions = progressionsData.items;
    displayedProgressions = progressions;
    
    Container plusContainer = Container(
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
                        fontSize: 0.05 * screenData.screenHeight,
                        color: Colors.white),
                  ))
            ])));
    
    SingleChildScrollView listScroll = SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: progressions
            .map((progression) => SingleProgression(
                progression.name == ''
                    ? progression.chords.map((e) => e.name).toString()
                    : progression.name,
                progression.id,
                0.7 * screenData.screenWidth,
                (screenData.isSmallLandscape ? 0.16 : 0.1) *
                    screenData.screenHeight))
            .toList(),
      ),
    );
    
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(15),
        child: screenData.isSmallLandscape
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(width: 0.53 * screenData.screenWidth, child: listScroll),
                  plusContainer,
                ],
              )
            : Column(
                children: [
                  listScroll,
                  plusContainer,
                ],
              ),
      ),
    );
  }
}
