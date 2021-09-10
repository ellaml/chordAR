import 'package:flutter/material.dart';
import '../helpers/db_helper.dart';

class UserPreferences with ChangeNotifier {
  String _colorCode;
  int _interval;

  String get colorCode {
    return _colorCode;
  }

  int get interval {
    return _interval;
  }

  void updateColor(String newColor) {
    _colorCode = newColor;
    notifyListeners();
    DBHelper.insert('user_preferences', {
      'id': 0,
      'color': _colorCode,
    });
  }

    void updateInterval(int newInterval) {
    _interval = newInterval;
    notifyListeners();
    DBHelper.insert('user_preferences', {
      'id': 0,
      'interval': _interval,
    });
  }

  Future<void> fetchPreferences() async {
    final dataList = await DBHelper.getData('user_preferences');
    _colorCode = dataList[0]['color'];
    _interval = dataList[0]['interval'];
    notifyListeners();
  }

}
