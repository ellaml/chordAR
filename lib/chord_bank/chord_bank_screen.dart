import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/utils.dart';
import 'chord_search.dart';
import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';

class ChordBankScreen extends StatelessWidget {
  static const routeName = '/chord-bank';
  @override
  Widget build(BuildContext context) {
    ScreenData screenData = ScreenData(context);
    return FocusWatcher(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: Theme.of(context).backgroundColor,
              centerTitle: true,
              title: Text("Chord Bank",
                  style: TextStyle(
                      fontSize: screenData.isBigDevice ? 32 : 24,
                      color: Colors.white)),
              leading: IconButton(
                  icon: Icon(Icons.chevron_left_rounded),
                  iconSize: 40,
                  onPressed: () => Navigator.pop(context)),
              automaticallyImplyLeading: true,
              elevation: 0,
            ),
            body: ChordSearch()));
  }
}
