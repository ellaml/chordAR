import 'package:flutter/material.dart';

class Preference with ChangeNotifier {
  String id;
  String colorCode;
  int interval = 5; // seconds

  Preference({String id, int interval, String colorCode}){
    this.id = id;
    this.colorCode = colorCode;
    this.interval = interval;
  }

}