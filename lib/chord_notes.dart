import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:chaquopy/chaquopy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/globals.dart';
import 'package:flutter_complete_guide/models/chord.dart';
import './constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import './app_colors.dart' as appColors;

Widget createNoteWidget(
    Point point, double topAdd, double leftAdd, double width, double height) {
  return Positioned(
    left: point.x.toDouble() * width, //new_left,
    top: point.y.toDouble() *
        height, //new_top, // change - its always right after the appbar
    child: Container(
      width: SIZE_NOTE,
      height: SIZE_NOTE,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1.5),
          shape: NOTE_SHAPE,
          color: COLOR_NOTE,
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
  final dynamic listOfNotesCoordinatesJson = listOfNotesInfoJson[NOTES_COORDINAES_JSON_KEY];
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
  newPath += "c.jpeg";
  print("newPath:" + newPath);
  return newPath;
}

Future<void> saveChordPositionInFile(String chordName) async {
  String newPath = await getBasePathToSaveFrame();
  newPath += "position.txt";
  print("newPath:" + newPath);
  final file = File('$newPath');
  file.writeAsString(chordName + ':' + Chord.getChordPosition(chordName));
  // file.writeAsString(Chord.getChordPosition(chordName));
  //var syncPath = await newPath;
  //var exists =  await File(syncPath).exists();
  //final contents = await file.readAsString();
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
    double top, double left, double width, double height) {
  final List<Widget> listOfWidgets = [];
  for (final Point point in listOfNotesCoordinates) {
    listOfWidgets.add(createNoteWidget(point, top, left, width, height));
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
    double height) async {
  String listOfNotesInfoStr =
      await fetchNotesInfoByPathOfFrame(framePath, chordName);
  print("\n ================================= FLUTTER =================================\n");
  print(listOfNotesInfoStr);
  listOfNotesInfoStr = listOfNotesInfoStr.replaceAll("\n", " ");
  List<Widget> listOfWidgets = [];
  if (listOfNotesInfoStr
      .contains(new RegExp(r'failed', caseSensitive: false))) {
    print("failed");
    //listOfWidgets.add(createTextWidget(listOfNotesInfoStr, Colors.red, 1));
  } else // TODO: Need to add after the image processing is ready
  {
    //listOfWidgets.add(createTextWidget(listOfNotesInfoStr, Colors.green, 1));
    listOfNotesInfoStr = cleanStringForJson(listOfNotesInfoStr);
    print("\n listOfNotes: " + listOfNotesInfoStr + "\n");
    Map<String, dynamic> listOfNotesInfoJson = json.decode(listOfNotesInfoStr);
    final String chordName = listOfNotesInfoJson[CHORD_NAME_JSON_KEY];
    print("################ chordName: " + chordName + "###############");
    final List<Point> listOfNotesCoordinates =
        convJsonToListOfNotesCoordinates(listOfNotesInfoJson);
    listOfWidgets = createNoteWidgetsByListOfPoints(
        listOfNotesCoordinates, top, left, width, height);
  print("\n ================================= END =================================\n");

    //await ImageGallerySaver.saveFile(framePath);
    // print("Gallery: " + fileName.toString());
    // print("frame Path: " + framePath);
  }
  //await ImageGallerySaver.saveFile(framePath);
  //String pathToSaveFrame = await getPathToSaveFrame();
  //listOfWidgets.add(createTextWidget(pathToSaveFrame, Colors.blue, 30));

  //listOfWidgets.add(createTextWidget(listOfNotesInfoStr, Colors.blue, 40));
  return listOfWidgets;
}

/*List<Widget> createNoteWidgetsByFrame(String framePath)
{
  return <Widget>[createNoteWidget(Point(1,2)), createNoteWidget((Point(50,40)))];
}*/

