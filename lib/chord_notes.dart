import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:chaquopy/chaquopy.dart';
import 'package:flutter/material.dart';
import './constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

Widget createNoteWidget(Point point, double top, double left, double width, double height) {
  return Positioned(
    left: point.x.toDouble() / 100 * width + left,
    top: point.y.toDouble() / 100 * height + top, // change - its always right after the appbar
    child: Container(
      width: WIDTH_NOTE,
      height: HEIGHT_NOTE,
      decoration: const BoxDecoration(
        shape: NOTE_SHAPE,
        color: COLOR_NOTE,
      ),
    ),
  );
}

List<Point> createPointsListFromJson(
    dynamic listOfNotesCoordinatesJson, double numOfNotes) {
  final List<Point> listOfCordNotesCoordinates = <Point>[];

  for (int i = 0; i < numOfNotes; i++) {
    final dynamic point = listOfNotesCoordinatesJson[i];
    final double x = double.parse(convertDynamicToDouble(point[X_JSON_KEY]).toStringAsFixed(2));
    final double y = double.parse(convertDynamicToDouble(point[Y_JSON_KEY]).toStringAsFixed(2));
    listOfCordNotesCoordinates.add(Point(x, y));
  }

  return listOfCordNotesCoordinates;
}

double convertDynamicToDouble(dynamic jsonVal) {
  return double.parse(jsonVal.toString());
}

List<Point> convJsonToListOfNotesCoordinates(String listOfNotesInfoStr) {
  final dynamic listOfNotesInfoJson = json.decode(listOfNotesInfoStr);

  final dynamic listOfNotesCoordinatesJson =
      listOfNotesInfoJson[NOTES_COORDINAES_JSON_KEY];
  final double numOfNotes =
      convertDynamicToDouble(listOfNotesInfoJson[NUM_NOTES_JSON_KEY]);

  return createPointsListFromJson(listOfNotesCoordinatesJson, numOfNotes);
}


Future<String> fetchNotesInfoByPathOfFrame(String framePath, String pathToSaveFrame) async {
  print("C1");
  File(framePath).copy(pathToSaveFrame);
  print("C3");
  if(Chaquopy == null)
  {
    print("NULLLLLL!!!!!");
  }
  var outputMap = await Chaquopy.executeCode("script.py");
  print("C4");
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

Future<List<Widget>> createNoteWidgetsByFrame(String framePath, String pathToSaveFrame, double top,
    double left, double width, double height) async {
  print("B1");
  print(framePath);
  String listOfNotesInfoStr = await fetchNotesInfoByPathOfFrame(framePath, pathToSaveFrame);
  print("B2");
  listOfNotesInfoStr = listOfNotesInfoStr.replaceAll("\n", " ");
  print("stringC: " + listOfNotesInfoStr);
  List<Widget> listOfWidgets = [];
  if(listOfNotesInfoStr.contains(new RegExp(r'failed', caseSensitive: false)))
  {
    print("failed");
      //listOfWidgets.add(createTextWidget(listOfNotesInfoStr, Colors.red, 1));
  }
  else// TODO: Need to add after the image processing is ready
  {
    //listOfWidgets.add(createTextWidget(listOfNotesInfoStr, Colors.green, 1));
    listOfNotesInfoStr = cleanStringForJson(listOfNotesInfoStr);
    final List<Point> listOfNotesCoordinates =
        convJsonToListOfNotesCoordinates(listOfNotesInfoStr);
    listOfWidgets = createNoteWidgetsByListOfPoints(
        listOfNotesCoordinates, top, left, width, height);


   // print("Gallery: " + fileName.toString());
   // print("frame Path: " + framePath);
  }
  await ImageGallerySaver.saveFile(framePath);
  //String pathToSaveFrame = await getPathToSaveFrame();
  //listOfWidgets.add(createTextWidget(pathToSaveFrame, Colors.blue, 30));

  //listOfWidgets.add(createTextWidget(listOfNotesInfoStr, Colors.blue, 40));
  return listOfWidgets;
}

/*List<Widget> createNoteWidgetsByFrame(String framePath)
{
  return <Widget>[createNoteWidget(Point(1,2)), createNoteWidget((Point(50,40)))];
}*/

