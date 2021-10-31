import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:chaquopy/chaquopy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/chord.dart';
import 'package:flutter_complete_guide/settings/user_preferences_shared.dart';
import './constants.dart';
import 'package:path_provider/path_provider.dart';
import './app_colors.dart' as appColors;
import 'package:flutter_complete_guide/globals.dart' as globals;

Widget createNoteWidget(Point point, double topAdd, double leftAdd,
    double width, double height, int colorCode) {
  print(colorCode);
  return Positioned(
    left: point.x.toDouble() * width + leftAdd, //new_left,
    top: point.y.toDouble() *
        height, //new_top, // change - its always right after the appbar
    child: Container(
      width: SIZE_NOTE,
      height: SIZE_NOTE,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1.5),
          shape: NOTE_SHAPE,
          color: Color(colorCode),
          boxShadow: [
            BoxShadow(
              color: appColors.notesWidgetLight,
              blurRadius: 4,
              spreadRadius: 1,
              offset: Offset(
                0.7,
                0.7,
              ),
            ),
          ]),
    ),
  );
}

List<Point> createPointsListFromJson(
    dynamic listOfNotesCoordinatesJson, double numOfNotes) {
  final List<Point> listOfChordNotesCoordinates = <Point>[];

  for (int i = 0; i < numOfNotes; i++) {
    final dynamic point = listOfNotesCoordinatesJson[i];
    final double x = double.parse(
        convertDynamicToDouble(point[X_JSON_KEY]).toStringAsFixed(2));
    final double y = double.parse(
        convertDynamicToDouble(point[Y_JSON_KEY]).toStringAsFixed(2));
    print("\n createPointsListFromJson    x: " + x.toString() + " y: " + y.toString() + "\n");
    listOfChordNotesCoordinates.add(Point(x, y));
  }

  return listOfChordNotesCoordinates;
}

double convertDynamicToDouble(dynamic jsonVal) {
  return double.parse(jsonVal.toString());
}

List<Point> convJsonToListOfNotesCoordinates(dynamic listOfNotesInfoJson) {
  final dynamic listOfNotesCoordinatesJson =
      listOfNotesInfoJson[NOTES_COORDINAES_JSON_KEY];
  final double numOfNotes =
      convertDynamicToDouble(listOfNotesInfoJson[NUM_NOTES_JSON_KEY]);
  return createPointsListFromJson(listOfNotesCoordinatesJson, numOfNotes);
}

Future<String> getBasePathToSaveFrame() async {
  String dirPath = await getApplicationDocumentsDirectory()
      .then((Directory dir) => dir.path);
  List<String> folders = dirPath.split("/");
  String newPath = "";

  for (int i = 1; i < folders.length; i++) {
    String folder = folders[i];
    if (folder != "app_flutter") {
      newPath += "/" + folder;
    } else {
      break;
    }
  }
  newPath += "/files/chaquopy/AssetFinder/app/";
  return newPath;
}

Future<String> getPathToSaveFrame() async {
  String newPath = await getBasePathToSaveFrame();
  newPath += FRAME_FILE_NAME;
  print("newPath:" + newPath);
  return newPath;
}

Future<void> saveChordPositionInFile(String chordName) async {
  String newPath = await getBasePathToSaveFrame();
  newPath += POSITION_FILE_NAME;
  print("newPath:" + newPath);
  final file = File('$newPath');
  file.writeAsString(chordName + ':' + Chord.getChordPosition(chordName));
  return;
}

Future<String> fetchNotesInfoByPathOfFrame(
    String framePath, String chordName) async {
  String path = await getPathToSaveFrame();
  await saveChordPositionInFile(chordName);
  File(framePath).copy(path);
  var outputMap = await Chaquopy.executeCode("script.py");
  print(outputMap['textOutputOrError'].toString());
  return outputMap['textOutputOrError'].toString();
}

List<Widget> createNoteWidgetsByListOfPoints(List<Point> listOfNotesCoordinates,
    double top, double left, double width, double height, int colorCode) {
  final List<Widget> listOfWidgets = [];
  for (final Point point in listOfNotesCoordinates) {
    listOfWidgets
        .add(createNoteWidget(point, top, left, width, height, colorCode));
  }
  return listOfWidgets;
}

Widget createTextWidget(String error, Color color, double height) {
  return RichText(
    text: TextSpan(
      text: error,
      style: TextStyle(
          height: height,
          fontSize: 15,
          color: color,
          fontWeight: FontWeight.bold),
    ),
  );
}

String cleanStringForJson(String str) {
  return str.replaceAll(
      RegExp(r'^.*?{"notes_coordinates"'), '{"notes_coordinates"');
}

Future<List<Widget>> createNoteWidgetsByFrame(
    String chordName,
    String framePath,
    double top,
    double left,
    double width,
    double height,
    int colorCode) async {
  String listOfNotesInfoStr =
      await fetchNotesInfoByPathOfFrame(framePath, chordName);
  listOfNotesInfoStr = listOfNotesInfoStr.replaceAll("\n", " ");
  List<Widget> listOfWidgets = [];
  if (listOfNotesInfoStr.contains(new RegExp(r'failed', caseSensitive: false))) {
    print("failed");
  } else {
    listOfNotesInfoStr = cleanStringForJson(listOfNotesInfoStr);
    Map<String, dynamic> listOfNotesInfoJson = json.decode(listOfNotesInfoStr);
    final String chordName = listOfNotesInfoJson[CHORD_NAME_JSON_KEY];
    globals.chordTitle = chordName;
    final List<Point> listOfNotesCoordinates =
        convJsonToListOfNotesCoordinates(listOfNotesInfoJson);
    UserPreferences prefs = UserPreferences();
    int colorCodeForNotesWidgets = colorCode;
    listOfWidgets = createNoteWidgetsByListOfPoints(listOfNotesCoordinates, top,
        left, width, height, colorCodeForNotesWidgets);

  }
  return listOfWidgets;
}