import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/chord.dart';
import 'package:flutter_complete_guide/search_box.dart';
import 'package:flutter_complete_guide/utils.dart';
import '../providers/progression.dart';
import '../providers/progressions.dart';
import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';
import 'package:provider/provider.dart';
import '../app_colors.dart' as appColors;
import 'draggable_chord_grid.dart';

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
  List<Chord> finalChords = [];
  bool isSaveDisabled = true;

  var _initValues = {
    'name': '',
    'interval': '5',
    'chords': []
  };

  var _isInit = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final progressionId = ModalRoute.of(context).settings.arguments as String;
      if (progressionId != null) {
        Progression existing = Provider.of<Progressions>(context, listen: false)
            .findById(progressionId);
        _editedProgression.id = existing.id;
        _editedProgression.interval = existing.interval;
        _editedProgression.name = existing.name;
        _editedProgression.chords = [...existing.chords];
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
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    if (_editedProgression.id != null) {
      _editedProgression.chords.removeLast(); // remove dummy with plus
      Provider.of<Progressions>(context, listen: false)
          .updateProgression(_editedProgression.id, _editedProgression);
    } else {
      _editedProgression.chords.removeLast();
      Provider.of<Progressions>(context, listen: false)
          .addProgression(_editedProgression);
    }
    Navigator.of(context).pop();
  }

  void _addChordToGrid(String chordName) {
    setState(() {
      _editedProgression.chords.last = (Chord(chordName));
    });
  }

  void _deleteChord(int index) {
    setState(() {
      _editedProgression.chords.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenData screenData = ScreenData(context);
    double fontSize = screenData.isBigDevice ? 26 : 18;
    double chordBoxWidth = screenData.isBigDevice ? 90 : 60;
    double chordBoxHeight = screenData.isBigDevice ? 70 : 50;
    isSaveDisabled = _editedProgression.chords.length < 1 || _editedProgression.chords[0].name == "dummy";
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
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
                      SearchBox(_addChordToGrid, 0.7 * screenData.screenWidth),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    child: DraggableChordGrid(_editedProgression.chords, chordBoxWidth,
                        chordBoxHeight, _deleteChord, screenData.isBigLandscape? 6 : (screenData.isBigDevice || screenData.isLandscape? 4 : (screenData.isLandscape? 4: 3))),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
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
                                        labelText: '5',
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
                                            color: isSaveDisabled? Colors.black38 : appColors.borderPurple,
                                            width: 1,
                                            style: BorderStyle.solid),
                                        borderRadius:
                                            BorderRadius.circular(10))),
                              ),
                              onPressed: isSaveDisabled? null : _saveForm, //save prog
                              child: Container(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    'Save',
                                    style: TextStyle(
                                        fontSize: fontSize*1.6,
                                        fontWeight: FontWeight.bold,
                                        color: isSaveDisabled? Colors.black26 : appColors.buttonText),
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
    )); 
  }
}
