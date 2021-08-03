import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/progressions/edit_progression_screen.dart';
import 'package:flutter_complete_guide/progressions/single_progression.dart';
import '../search_box.dart';
import 'package:provider/provider.dart';
import '../providers/progressions.dart';
import '../providers/progression.dart';

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

  // didChangeDependencie() {
  //   displayedProgressions =  Provider.of<Progressions>(context).items;
  // }

  void _updateList(String chordName) {
    setState(() {
      displayedProgressions
          .map((progression) => progression.chords.contains(chordName));
    });
  }

  @override
  Widget build(BuildContext context) {
    final progressionsData = Provider.of<Progressions>(context);
    final progressions = progressionsData.items;
    return Container(
        child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
          Container(
              margin: EdgeInsets.only(bottom: 20),
              child: SearchBox(_updateList)),
          Expanded(
              flex: 3,
              child: Column(children: [
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: progressions
                        .map((progression) => SingleProgression(
                            progression.name == ''
                                ? progression.chords
                                    .map((e) => e.name)
                                    .toString()
                                : progression.name,
                            progression.id))
                        .toList(),
                  ),
                ),
                Container(
                    color: Theme.of(context).backgroundColor,
                    margin: EdgeInsets.all(20),
                    alignment: Alignment.center,
                    child: GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(EditProgressionScreen.routeName);
                        },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  child:
                                      Image.asset('assets/icons/plus64.png')),
                              Container(
                                  margin: EdgeInsets.all(20),
                                  child: Text(
                                    "Add new Progression",
                                    style: TextStyle(color: Colors.white),
                                  ))
                            ])))
              ]))
        ]));
  }
}


/*
SearchBox(_updateChord)

searchedChord
*/