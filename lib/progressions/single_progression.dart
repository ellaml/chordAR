import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/live_mode/camera.dart';
import 'package:flutter_complete_guide/live_mode/live_mode_screen.dart';
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
              onTap: () {
                globals.progressionMode = true;
                globals.currentProg =
                    Provider.of<Progressions>(context, listen: false)
                        .findById(id);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Camera();
                }));
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text(buttonLabel,
                    style: TextStyle(
                        fontSize: 0.3 * height,
                        fontWeight: FontWeight.bold,
                        color: appColors.buttonText),
                    textAlign: TextAlign.center),
              )),
          Row(
            children: [
              IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                        EditProgressionScreen.routeName,
                        arguments: id);
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
