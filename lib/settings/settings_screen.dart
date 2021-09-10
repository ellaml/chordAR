import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/user_preferences.dart';
import 'package:flutter_complete_guide/utils.dart';
import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../app_colors.dart' as appColors;

class SettingsScreen extends StatefulWidget {
  static const routeName = '/single-progression';

  @override
  _SettingsScreen createState() => _SettingsScreen();
}

class _SettingsScreen extends State<SettingsScreen> {
  final _form = GlobalKey<FormState>();
  var _editedColor = null;
  var _editedInterval = null;

  final _colorCode = null;
  final _defaultInterval = null;

  var _initValues = {'color': '', 'interval': '5'};

  var _isInit = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      //String existingColor = Provider.of<UserPreferences>(context, listen: false).colorCode;
      //int existingInterval = Provider.of<UserPreferences>(context, listen: false).interval;
      _editedColor = null; //existingColor;
      _editedInterval = null; //existingInterval;
      _initValues = {
        'color': _editedColor,
        'interval': _editedInterval,
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
    Provider.of<UserPreferences>(context, listen: false).updateColor(_editedColor);
    Provider.of<UserPreferences>(context, listen: false).updateInterval(_editedInterval);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    Future preferences =  Provider.of<UserPreferences>(context).fetchPreferences();
    Widget buildColorPicker() => BlockPicker(
          pickerColor: appColors.borderPurple,
          availableColors: [
            appColors.buttonBackground,
            appColors.notesWidgetColor,
            appColors.borderPurple,
            appColors.lightPurpleShadow,
            appColors.notesWidgetGlow,
            appColors.notesWidgetLight
          ],
          onColorChanged: (color) => _editedColor = color,
        );

    ScreenData screenData = ScreenData(context);

    double fontSize = screenData.isBigDevice ? 26 : 18;
    double chordBoxWidth = screenData.isBigDevice ? 90 : 60;
    double chordBoxHeight = screenData.isBigDevice ? 70 : 50;
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
                child: SingleChildScrollView(
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(children: [Text("Select the color for the fingers indication"), buildColorPicker()]),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(20),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Deafult Interval for progressions',
                                        style: TextStyle(
                                            fontSize: fontSize,
                                            shadows: [
                                              Shadow(
                                                  color: Color(0xFFE5C4E9),
                                                  offset: Offset(2, 2),
                                                  blurRadius: 10)
                                            ])),
                                    Container(
                                      width: chordBoxHeight,
                                      height: chordBoxHeight,
                                      margin: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: Color(0x26FFFFFF),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border:
                                              Border.all(color: Colors.white)),
                                      child: TextFormField(
                                          style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: fontSize),
                                          initialValue:
                                              _initValues[_editedInterval],
                                          textInputAction: TextInputAction.next,
                                          keyboardType: TextInputType.number,
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              // TODO: Add error
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            _editedInterval = value;
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
                                        style: TextStyle(
                                            fontSize: fontSize,
                                            shadows: [
                                              Shadow(
                                                  color: Color(0xFFE5C4E9),
                                                  offset: Offset(2, 2),
                                                  blurRadius: 10)
                                            ])),
                                  ]),
                            ),
                            Container(
                                alignment: Alignment.bottomCenter,
                                color: Color(0x00FFFFFF),
                                margin: EdgeInsets.all(10),
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Color(0x00FFFFFF)),
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: appColors.borderPurple,
                                                  width: 1,
                                                  style: BorderStyle.solid),
                                              borderRadius:
                                                  BorderRadius.circular(10))),
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
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.transparent)),
                                onPressed: null,
                                child: Text('Cancel',
                                    style: TextStyle(
                                        fontSize: fontSize,
                                        color: Colors.white54))),
                          ],
                        ),
                      ]),
                ),
              ),
            )));
  }
}
