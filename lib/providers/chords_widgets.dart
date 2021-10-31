import 'package:flutter/material.dart';

class ChordWidgets extends ChangeNotifier { // create a common file for data
  List<Widget> _listOfChordPointWidgets = [];

  List<Widget> get listOfChordPointWidgets => _listOfChordPointWidgets;

  void setListOfChordPointWidgets(List<Widget> list) {
    _listOfChordPointWidgets = list;
    notifyListeners();
  }
}