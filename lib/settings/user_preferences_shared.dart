import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app_colors.dart' as appColors;

class UserPreferences {
  ///
  /// Instantiation of the SharedPreferences library
  ///
  final String _kColorCode = "color";
  final String _kDefaultInterval = "interval";

  // / ------------------------------------------------------------
  // / Method that returns the user decision to allow notifications
  // / ------------------------------------------------------------
  Future<int> getDefaultInterval() async {
	final SharedPreferences prefs = await SharedPreferences.getInstance();

  	return prefs.getInt(_kDefaultInterval) ?? 5;
  }

  /// ----------------------------------------------------------
  /// Method that saves the user decision to allow notifications
  /// ----------------------------------------------------------
  Future<bool> setDefaultInterval(int value) async {
	final SharedPreferences prefs = await SharedPreferences.getInstance();

	return prefs.setInt(_kDefaultInterval, value);
  }

  /// ------------------------------------------------------------
  /// Method that returns the user decision on sorting order
  /// ------------------------------------------------------------
  Future<int> getColorCode() async {
	final SharedPreferences prefs = await SharedPreferences.getInstance();

	return prefs.getInt(_kColorCode) ?? 0xFF80ffd4;
  }

  /// ----------------------------------------------------------
  /// Method that saves the user decision on sorting order
  /// ----------------------------------------------------------
  Future<bool> setColorCode(int value) async {
	final SharedPreferences prefs = await SharedPreferences.getInstance();

	return prefs.setInt(_kColorCode, value);
  }
}