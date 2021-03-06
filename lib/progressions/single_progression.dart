import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/settings/user_preferences_shared.dart';
import 'package:flutter_complete_guide/live_mode/camera.dart';
import 'package:flutter_complete_guide/utils.dart';
import '../progressions/edit_progression_screen.dart';
import '../providers/progressions.dart';
import 'package:provider/provider.dart';
import '../app_colors.dart' as appColors;
import '../globals.dart' as globals;

class SingleProgression extends StatelessWidget {
  final String buttonLabel;
  final String id;
  final double width, height;

  SingleProgression(this.buttonLabel, this.id, this.width, this.height);

  @override
  Widget build(BuildContext context) {
    ScreenData screenData = ScreenData(context);
    return Container(
        width: width,
        height: height,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(0x00FFFFFF),
            border: Border.all(color: appColors.borderPurple)),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          GestureDetector(
              onTap: () async {
                globals.progressionMode = true;
                globals.currentProg =
                    Provider.of<Progressions>(context, listen: false)
                        .findById(id);
                UserPreferences prefs = UserPreferences();
                int colorCode = await prefs.getColorCode();
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Camera(colorCode);
                }));
              },
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Flexible(
                    child: Text(buttonLabel,
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        softWrap: false,
                        style: TextStyle(
                            fontSize: (screenData.isLandscape? 0.3 : 0.25) * height,
                            fontWeight: FontWeight.bold,
                            color: appColors.buttonText),
                        textAlign: TextAlign.center),
                  ))),
          Row(
            children: [
              IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    Navigator.of(context).pushNamed(
                        EditProgressionScreen.routeName,
                        arguments: [id, null]);
                  }),
              IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    Provider.of<Progressions>(context, listen: false)
                        .removeProgression(id);
                  }),
            ],
          ),
        ]));
  }
}
