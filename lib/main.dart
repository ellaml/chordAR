import 'package:flutter/material.dart';
import 'main_menu/main_menu.dart';
import 'settings/settings_screen.dart';
import 'app_colors.dart' as appColors;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
    // Define the default brightness and colors.
    brightness: Brightness.dark,
    accentColor: Colors.white,
    primaryColor: Colors.purple[400],
    backgroundColor: Color(0xFF2E2D3B),
    // Define the default font family.
    dialogBackgroundColor: Color(0xFF2E2D3B),
    scaffoldBackgroundColor: Color(0xFF2E2D3B),
    fontFamily: 'Segoe UI',

    // Define the default TextTheme. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
    textTheme: const TextTheme(
      headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
    ),
  ),
      home: HomePage(),
    );
  }
}

  void openSettings(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) {
        return SettingsScreen();
      },
    ));
  }

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          actions: [
            Flexible(
                flex: 1,
                child: GestureDetector(
                  onTap: () => openSettings(context),
                    child: Container(
                  color: appColors.backgroundColor,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.all(10),
                          height: 32,
                          width: 32,
                          child:
                              Image.asset('assets/icons/settings-purple32.png'))
                    ],
                  ),
                ))),
          ],
        ),
        body: MainMenu());
  }
}
