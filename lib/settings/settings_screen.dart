import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/globals.dart';
// import 'package:flutter_complete_guide/providers/user_preferences.dart';
import 'package:flutter_complete_guide/utils.dart';
import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../app_colors.dart' as appColors;
import 'package:shared_preferences/shared_preferences.dart';
import 'user_preferences_shared.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/single-progression';

  int color;
  int interval;

  SettingsScreen(this.color, this.interval);

  @override
  _SettingsScreen createState() => _SettingsScreen();
}

class _SettingsScreen extends State<SettingsScreen> {
  final _form = GlobalKey<FormState>();
  UserPreferences prefs = UserPreferences();
  int _editedColor = null;
  int _editedInterval = null;

  var _initValues = {'color': '', 'interval': '5'};

  var _isInit = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _editedColor = widget.color; 
      _editedInterval = widget.interval; 
      _initValues = {
        'color': _editedColor.toString(),
        'interval': _editedInterval.toString(),
      };
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    prefs.setColorCode(_editedColor);
    prefs.setDefaultInterval(_editedInterval);
    Navigator.of(context).pop();
  }

  static Widget layoutBuilder(
      BuildContext context, List<Color> colors, PickerItem child) {
    Orientation orientation = MediaQuery.of(context).orientation;

    return Container(
      width: orientation == Orientation.portrait ? 300.0 : 500.0,
      height: orientation == Orientation.portrait ? 360.0 : 100.0,
      child: GridView.count(
        crossAxisCount: orientation == Orientation.portrait ? 4 : 6,
        crossAxisSpacing: 6.0,
        mainAxisSpacing: 6.0,
        children: colors.map((Color color) => child(color)).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget buildColorPicker() => BlockPicker(
          layoutBuilder: layoutBuilder,
          pickerColor: Color(_editedColor),
          availableColors: [
            appColors.notesWidgetGlow,
            const Color(0xff4ceb34),
            const Color(0xfffff70a),
            const Color(0xffff8503),
            const Color(0xffed1337),
            const Color(0xffd934eb),
          ],
          onColorChanged: (color) => _editedColor = color.value,
        );

    ScreenData screenData = ScreenData(context);
    double intervalBoxWidth = screenData.isBigDevice ? 90 : 60;
    double intervalBoxHeight = screenData.isBigDevice ? 70 : 50;
    double fontSize = screenData.isBigDevice ? 26 : 18;
    return FocusWatcher(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        centerTitle: true,
        title: Text('Settings',
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
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _form,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(children: [
                Text("Select the color for the fingers indication",
                    style: TextStyle(fontSize: fontSize, shadows: [
                      Shadow(
                          color: Color(0xFFE5C4E9),
                          offset: Offset(2, 2),
                          blurRadius: 10)
                    ])),
                Container(
                    margin: EdgeInsets.all(40), child: buildColorPicker()),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Deafult Interval for progressions is',
                            style: TextStyle(fontSize: fontSize, shadows: [
                              Shadow(
                                  color: Color(0xFFE5C4E9),
                                  offset: Offset(2, 2),
                                  blurRadius: 10)
                            ])),
                        Container(
                          width: intervalBoxHeight,
                          height: intervalBoxHeight,
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Color(0x26FFFFFF),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white)),
                          child: TextFormField(
                              style: TextStyle(
                                  fontFamily: 'Roboto', fontSize: fontSize),
                              initialValue: _initValues['interval'],
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value.isEmpty) {
                                  // TODO: Add error
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _editedInterval = int.parse(value);
                              },
                              decoration: InputDecoration(
                                  labelText: 'interval',
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none),
                                  filled: false,
                                  labelStyle: TextStyle(
                                      fontFamily: 'Roboto',
                                      color: Colors.white,
                                      fontSize: fontSize))),
                        ),
                        Text('seconds',
                            style: TextStyle(fontSize: fontSize, shadows: [
                              Shadow(
                                  color: Color(0xFFE5C4E9),
                                  offset: Offset(2, 2),
                                  blurRadius: 10)
                            ])),
                      ]),
                )
              ]),
              Column(children: [Container(
                  alignment: Alignment.bottomCenter,
                  color: Color(0x00FFFFFF),
                  margin: EdgeInsets.all(10),
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Color(0x00FFFFFF)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            side: BorderSide(
                                color: appColors.borderPurple,
                                width: 1,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(10))),
                      ),
                      onPressed: _saveForm, //save prog
                      child: Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Save',
                            style: TextStyle(
                                fontSize: fontSize * 1.6,
                                fontWeight: FontWeight.bold,
                                color: appColors.buttonText),
                            textAlign: TextAlign.center,
                          )))),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.transparent)),
                  onPressed: null,
                  child: Text('Cancel',
                      style: TextStyle(
                          fontSize: fontSize, color: Colors.white54))),
            ],
          )]),
        ),
      ),
    ));
  }
}
