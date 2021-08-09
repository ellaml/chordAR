import 'package:flutter/material.dart';
import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';
import '../utils.dart';
import 'progressions_list.dart';

class ProgressionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenData screenData = ScreenData(context);
    return FocusWatcher(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: Theme.of(context).backgroundColor,
              centerTitle: true,
              title: Text("Saved Progressions",
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
            body: ProgressionsList()));
  }
}
