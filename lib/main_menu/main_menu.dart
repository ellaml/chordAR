import 'package:flutter/material.dart';
import 'menu_button.dart';
import '../chord_bank/chord_bank_screen.dart';
import '../progressions/progressions_screen.dart';
import '../live_mode/live_mode_screen.dart';
import '../app_colors.dart' as appColors;
import '../utils.dart';

class MainMenu extends StatelessWidget {
  MainMenu();

  @override
  Widget build(BuildContext context) {
    ScreenData screenData = ScreenData(context);
    double buttonsContainerHeight = screenData.isSmallLandscape
        ? screenData.screenHeight
        : 0.5 * screenData.screenHeight;
    double buttonHeight = 0.27 * buttonsContainerHeight;
    double buttonWidth = screenData.isLandscape
        ? 0.4 * screenData.screenWidth
        : 0.7 * screenData.screenWidth;
    final logo = Container(
        height: 0.32 * screenData.screenHeight,
        child: Image.asset('assets/logo/cut-logo.png', fit: BoxFit.cover));
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (!(screenData.isSmallLandscape))
          Container(
              height: 0.45 * screenData.screenHeight,
              child: Container(
                color: appColors.backgroundColor,
                padding: EdgeInsets.only(bottom: 20),
                width: double.infinity,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      logo,
                      Text(
                        'ChordAR',
                        style: TextStyle(
                          fontFamily: 'BankGothicMedium',
                          fontSize: 0.06 * screenData.screenHeight,
                          color: Colors.white,
                        ),
                      )
                    ]),
              )),
        Container(
            height: buttonsContainerHeight,
            width: screenData.screenWidth,
            child: Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                  MenuButton(
                      //ChordBankScreen(),
                      ChordBankScreen.routeName,
                      ('assets/icons/open-book' +
                          (screenData.isBigDevice ? '128' : '64') +
                          '.png'),
                      'Chord Bank',
                      buttonHeight,
                      buttonWidth),
                  MenuButton(
                      LiveModeScreen.routeName,
                      //LiveModeScreen(),
                      ('assets/icons/camera' +
                          (screenData.isBigDevice ? '128' : '64') +
                          '.png'),
                      'Live Mode',
                      buttonHeight,
                      buttonWidth),
                  MenuButton(
                      ProgressionsScreen.routeName,
                      //ProgressionsScreen(),
                      ('assets/icons/process' +
                          (screenData.isBigDevice ? '128' : '64') +
                          '.png'),
                      'Progressions',
                      buttonHeight,
                      buttonWidth),
                ])))
      ],
    );
  }
}
