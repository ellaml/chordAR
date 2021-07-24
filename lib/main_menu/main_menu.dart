import 'package:flutter/material.dart';
import 'menu_button.dart';
import '../chord_bank/chord_bank_screen.dart';
import '../progressions/progressions_screen.dart';
import '../live_mode/live_mode_screen.dart';
import '../app_colors.dart' as appColors;
class MainMenu extends StatelessWidget {


  MainMenu();

  @override
  Widget build(BuildContext context) {
  return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
                flex: 3,
                child: Container(
                  color: appColors.backgroundColor,
                  padding: EdgeInsets.only(bottom: 30),
                  width: double.infinity,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                            height: 130,
                            margin: EdgeInsets.only(bottom: 30),
                            child: Image.asset('assets/images/logo.png',
                                fit: BoxFit.cover)),
                        Text(
                          'ChordAR',
                          style: TextStyle(
                              fontSize: 45,
                              color: Colors.white,
                              shadows: <Shadow>[
                                Shadow(
                                    color: appColors.lightPurpleShadow,
                                    offset: Offset(2, 2),
                                    blurRadius: 8)
                              ]),
                        )
                      ]),
                )),
            Flexible(
                flex: 3,
                child: Container(
                    color: appColors.backgroundColor,
                    width: double.infinity,
                    child: Column(children: <Widget>[
                      MenuButton(ChordBankScreen(), 'assets/icons/open-book64.png', 'Chord Bank'),
                      MenuButton(LiveModeScreen(), 'assets/icons/camera64.png', 'Live Mode'),
                      MenuButton(ProgressionsScreen(), 'assets/icons/process64.png','Progressions'),
                    ])))
          ],
        );
  }
}