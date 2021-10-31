import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/chord_bank/chord_bank_screen.dart';
import 'package:flutter_complete_guide/live_mode/live_mode_screen.dart';
import 'package:flutter_complete_guide/progressions/progressions_screen.dart';
import 'package:flutter_complete_guide/settings/user_preferences_shared.dart';
import 'package:flutter_complete_guide/utils.dart';
import 'main_menu/main_menu.dart';
import 'settings/settings_screen.dart';
import 'package:provider/provider.dart';
import 'progressions/edit_progression_screen.dart';
import 'app_colors.dart' as appColors;
import 'providers/progressions.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Progressions(),
      child: MaterialApp(
        theme: ThemeData(
          // Define the default brightness and colors.
          brightness: Brightness.dark,
          accentColor: Colors.white,
          primaryColor: Colors.purple[400],
          backgroundColor: Color(0xFF2E2D3B),
          // Define the default font family.
          dialogBackgroundColor: Color(0xFF2E2D3B),
          scaffoldBackgroundColor: Color(0xFF2E2D3B),
          fontFamily: 'BankGothicLight',

          // Define the default TextTheme. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: const TextTheme(
            headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
            bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          ),
        ),
        home: HomePage(),
        routes: {
          ChordBankScreen.routeName: (ctx) => ChordBankScreen(),
          LiveModeScreen.routeName: (ctx) => LiveModeScreen(),
          ProgressionsScreen.routeName: (ctx) => ProgressionsScreen(),
          EditProgressionScreen.routeName: (ctx) => EditProgressionScreen(),
        },
      ),
    );
  }
}

void openSettings(BuildContext context, int interval, int color) {
  Navigator.push(context, MaterialPageRoute(
    builder: (_) {
      return SettingsScreen(color, interval);
    },
  ));
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenData screenData = ScreenData(context);
    final appBar = AppBar(
      automaticallyImplyLeading: true,
      elevation: 0,
      actions: [
        Flexible(
            flex: 1,
            child: GestureDetector(
                onTap: () async {
                  UserPreferences prefs = UserPreferences();
                  int interval = await prefs.getDefaultInterval();
                  int color = await prefs.getColorCode();
                  openSettings(context, interval, color);
                  },
                child: Container(
                  color: appColors.backgroundColor,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.all(10),
                          height: screenData.isBigDevice ? 64 : 32,
                          width: screenData.isBigDevice ? 64 : 32,
                          child: Image.asset('assets/icons/settings' +
                              (screenData.isBigDevice ? '64' : '32') +
                              '.png'))
                    ],
                  ),
                ))),
      ],
    );
    return Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: false,
        appBar: appBar,
        body: MainMenu());
  }
}
