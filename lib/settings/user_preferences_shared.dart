import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  final String _kColorCode = "color";
  final String _kDefaultInterval = "interval";

  Future<int> getDefaultInterval() async {
	final SharedPreferences prefs = await SharedPreferences.getInstance();

  	return prefs.getInt(_kDefaultInterval) ?? 5;
  }

  Future<bool> setDefaultInterval(int value) async {
	final SharedPreferences prefs = await SharedPreferences.getInstance();

	return prefs.setInt(_kDefaultInterval, value);
  }

  Future<int> getColorCode() async {
	final SharedPreferences prefs = await SharedPreferences.getInstance();

	return prefs.getInt(_kColorCode) ?? 0xFF80ffd4;
  }

  Future<bool> setColorCode(int value) async {
	final SharedPreferences prefs = await SharedPreferences.getInstance();

	return prefs.setInt(_kColorCode, value);
  }
}