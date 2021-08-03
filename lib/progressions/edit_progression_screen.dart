import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/search_box.dart';
import '../providers/progression.dart';
import '../providers/progressions.dart';
import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';
import 'package:provider/provider.dart';
//import 'package:drag_and_drop_gridview/devdrag.dart';
import '../app_colors.dart' as appColors;
//import 'plan_progression.dart';

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
    return FocusWatcher(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        centerTitle: true,
        title: Text('Edit Progression',
            style: TextStyle(fontSize: 24, color: Colors.white)),
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
                    width: 300,
                    child: TextFormField(
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
                            border:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            filled: false,
                            labelText: _editedProgression.name == ''
                                ? "Give it a name, if you want..."
                                : _editedProgression.name,
                            labelStyle: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.white,
                                fontSize: 18)))),
                Column(
                  children: [
                    SearchBox(null),
                  ],
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _editedProgression.chords
                        .map((chord) => Container(
                            width: 60,
                            height: 50,
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
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )))
                        .toList()),
//                 })))//PlanProgression(_editedProgression.chords),
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Display each chord for',
                                style: TextStyle(fontSize: 18, shadows: [
                                  Shadow(
                                      color: Color(0xFFE5C4E9),
                                      offset: Offset(2, 2),
                                      blurRadius: 10)
                                ])),
                            Container(
                              width: 50,
                              height: 40,
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Color(0x26FFFFFF),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.white)),
                              child: TextFormField(
                                  // max input 2 chars
                                  initialValue: _initValues['interval'],
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.number,
                                  focusNode: _intervalFocusNode,
                                  onFieldSubmitted: (_) {
                                    _saveForm();
                                  },
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter a price.';
                                    }
                                    if (double.tryParse(value) == null) {
                                      return 'Please enter a valid number.';
                                    }
                                    if (double.parse(value) <= 0) {
                                      return 'Please enter a number greater than zero.';
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
                                          color: Colors.white, fontSize: 5))),
                            ),
                            Text('seconds',
                                style: TextStyle(fontSize: 18, shadows: [
                                  Shadow(
                                      color: Color(0xFFE5C4E9),
                                      offset: Offset(2, 2),
                                      blurRadius: 10)
                                ])),
                          ]),
                    ),
                    Container(
                        width: 128,
                        height: 46,
                        alignment: Alignment.bottomCenter,
                        color: Color(0x00FFFFFF),
                        margin: EdgeInsets.all(10),
                        child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Color(0x00FFFFFF)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: appColors.borderPurple,
                                          width: 1,
                                          style: BorderStyle.solid),
                                      borderRadius: BorderRadius.circular(10))),
                            ),
                            onPressed: _saveForm, //save prog
                            child: Container(
                                child: Text(
                              'Save',
                              style: TextStyle(
                                  fontSize: 18,
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
                                fontSize: 18, color: Colors.white54))),
                  ],
                ),
              ]),
        ),
      ),
    )); //should be: name input -> plan prog (search + grid) -> interval input -> save/back button
  }
}
