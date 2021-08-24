import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/progressions/edit_progression_screen.dart';
import 'package:flutter_complete_guide/progressions/single_progression.dart';
import 'package:provider/provider.dart';
import '../providers/progressions.dart';
import '../utils.dart';

class ProgressionsList extends StatefulWidget {
  @override
  _ProgressionsListState createState() => _ProgressionsListState();
}

class _ProgressionsListState extends State<ProgressionsList> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenData screenData = ScreenData(context);
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
                        fontFamily: 'BankGothicLight',
                        fontSize: 0.05 * screenData.screenHeight,
                        color: Colors.white),
                  ))
            ])));

    FutureBuilder listScroll = FutureBuilder(
        future: Provider.of<Progressions>(context, listen: false)
            .fetchAndSetProgs(),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Consumer<Progressions>(
                    builder: (context, progressions, ch) =>
                        progressions.items.length <= 0
                            ? Container()
                            : ListView.builder(
                                itemCount: progressions.items.length,
                                itemBuilder: (context, i) => SingleProgression(
                                    progressions.items[i].name == ''
                                        ? progressions.items[i].chords
                                            .map((e) => e.name)
                                            .toString()
                                        : progressions.items[i].name,
                                    progressions.items[i].id,
                                    0.7 * screenData.screenWidth,
                                    (screenData.isSmallLandscape ? 0.16 : 0.1) *
                                        screenData.screenHeight))));

    return Container(
      padding: EdgeInsets.all(15),
      child: screenData.isSmallLandscape
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    width: 0.53 * screenData.screenWidth, child: listScroll),
                plusContainer,
              ],
            )
          : Column(
              children: [
                Container(
                    width: screenData.screenWidth * 0.7,
                    height: screenData.screenHeight * 0.7,
                    child: listScroll),
                plusContainer,
              ],
            ),
    );
  }
}
