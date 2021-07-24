import 'package:flutter/material.dart';
import 'main_menu/main_menu.dart';
import 'settings/settings_screen.dart';
import 'app_colors.dart' as appColors;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
