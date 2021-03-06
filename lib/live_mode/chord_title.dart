import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../app_colors.dart' as appColors;

class ChordTitle extends StatefulWidget {
  String title = '';
  bool isFirst = true;
  @override
  _ChordTitle createState() => _ChordTitle();

  ChordTitle(String title) {
    this.title = title;
  }
}

class _ChordTitle extends State<ChordTitle> {
  @override
  Widget build(BuildContext context) {
    if (widget.title != "") {
      return Positioned(
          left: 100,
          top: 30,
          child: SizedBox(
              child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: appColors.backgroundColor,
                border: Border.all(color: appColors.notesWidgetColor),
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                      color: appColors.notesWidgetGlow,
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(2, 2))
                ]),
            child: DefaultTextStyle(
              style: const TextStyle(
                fontSize: 50,
                fontFamily: 'BankGothicLight',
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 7.0,
                    color: Colors.white,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: Text(widget.title, style: colorizeTextStyle),
            ),
          )));
    }
    else {
      return Container(width: 0,height: 0,);
    }
  }

  void updateTitle() {
    setState(() {
      widget.isFirst = false;
    });
  }

  List<Color> colorizeColors = [
    appColors.borderPurple,
    appColors.lightPurpleShadow,
  ];

  static const colorizeTextStyle = TextStyle(
      fontSize: 50.0,
      fontFamily: 'BankGothicMedium', 
      shadows: [
        Shadow(
          blurRadius: 7.0,
          color: Colors.white,
          offset: Offset(0, 0),
        )
      ]);
}
