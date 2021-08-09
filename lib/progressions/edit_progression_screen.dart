import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/search_box.dart';
import 'package:flutter_complete_guide/utils.dart';
import '../providers/progression.dart';
import '../providers/progressions.dart';
import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';
import 'package:provider/provider.dart';
import '../app_colors.dart' as appColors;

class EditProgressionScreen extends StatefulWidget {
  static const routeName = '/single-progression';

  @override
  _EditProgressionScreen createState() => _EditProgressionScreen();
}

class _EditProgressionScreen extends State<EditProgressionScreen> {
  final _nameFocusNode = FocusNode();
  final _intervalFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProgression = Progression(
    id: null,
    name: '',
    chords: [],
    interval: 5,
  );

  var _initValues = {
    'name': '',
    'intervals': '',
  };

  var _isInit = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final progressionId = ModalRoute.of(context).settings.arguments as int;
      if (progressionId != null) {
        _editedProgression = Provider.of<Progressions>(context, listen: false)
            .findById(progressionId);
        _initValues = {
          'name': _editedProgression.name,
          'interval': _editedProgression.interval.toString(),
        };
      }
      _isInit = false;
      super.didChangeDependencies();
    }
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _intervalFocusNode.dispose();
    super.dispose();
  }

  void _saveForm() {
    print(' saving ? ');
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    if (_editedProgression.id != null) {
      Provider.of<Progressions>(context, listen: false)
          .updateProgression(_editedProgression.id, _editedProgression);
    } else {
      Provider.of<Progressions>(context, listen: false)
          .addProgression(_editedProgression);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text('Edit Progression',
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
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      height: screenData.screenHeight * 0.1,
                      margin: EdgeInsets.all(30),
                      decoration: BoxDecoration(
                          color: Color(0x26FFFFFF),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white)),
                      width: 0.7 * screenData.screenWidth,
                      child: TextFormField(
                          style: TextStyle(
                              fontFamily: 'Roboto', fontSize: fontSize),
                          initialValue: _initValues['name'],
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_intervalFocusNode);
                          },
                          onSaved: (value) {
                            _editedProgression = Progression(
                                name: value,
                                id: _editedProgression.id,
                                chords: _editedProgression.chords,
                                interval: _editedProgression.interval);
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              filled: false,
                              labelText: _editedProgression.name == ''
                                  ? "Give it a name, if you want..."
                                  : _editedProgression.name,
                              labelStyle: TextStyle(
                                fontFamily: 'Roboto',
                                fontStyle: FontStyle.italic,
                                fontSize: fontSize,
                                color: Colors.white,
                              )))),
                  Column(
                    children: [
                      SearchBox(null, 0.7 * screenData.screenWidth),
                    ],
                  ),
                  Container(
                    height: screenData.screenHeight * 0.3,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: _editedProgression.chords
                            .map((chord) => Container(
                                width: chordBoxWidth,
                                height: chordBoxHeight,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.white12,
                                          offset: Offset(2, 2),
                                          blurRadius: 20)
                                    ],
                                    color: Color(0x60FFFFFF),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    border: Border.all(
                                        width: 2,
                                        color: Theme.of(context).primaryColor)),
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.all(10),
                                child: Text(
                                  chord.name,
                                  style: TextStyle(
                                      fontSize: 0.3 * chordBoxHeight,
                                      fontWeight: FontWeight.bold),
                                )))
                            .toList()),
                  ),
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Display each chord for',
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
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.white)),
                                child: TextFormField(
                                    style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: fontSize),
                                    initialValue: _initValues['interval'],
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.number,
                                    focusNode: _intervalFocusNode,
                                    onFieldSubmitted: (_) {
                                      _saveForm();
                                    },
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        // TODO: Add error
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      _editedProgression = Progression(
                                          name: _editedProgression.name,
                                          interval: int.parse(value),
                                          id: _editedProgression.id,
                                          chords: _editedProgression.chords);
                                    },
                                    decoration: InputDecoration(
                                        labelText: '4',
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
                                backgroundColor: MaterialStateProperty.all(
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
                                        fontSize: fontSize,
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
                                  fontSize: fontSize, color: Colors.white54))),
                    ],
                  ),
                ]),
          ),
        ),
      ),
    )); //should be: name input -> plan prog (search + grid) -> interval input -> save/back button
  }
}
