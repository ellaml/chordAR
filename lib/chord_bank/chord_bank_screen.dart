import 'package:flutter/material.dart';
import 'chord_search.dart';
import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';
import '../app_colors.dart' as appColors;

class ChordBankScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FocusWatcher(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: appColors.backgroundColor,
              centerTitle: true,
              title: Text("Chord Bank",
                  style: TextStyle(fontSize: 24, color: Colors.white)),
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
