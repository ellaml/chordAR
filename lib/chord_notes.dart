import 'dart:convert';
import 'dart:io';
import 'dart:math';
//import 'package:gallery_saver/gallery_saver.dart'; //TODO
import 'package:camera/camera.dart';
import 'package:chaquopy/chaquopy.dart';
import 'package:flutter/material.dart';
import './constants.dart';
import 'package:path_provider/path_provider.dart';

Widget createNoteWidget(Point point)
{
  return Positioned(
    left: point.x.toDouble() ,
    top: point.y.toDouble() ,
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

List<Point> createPointsListFromJson(dynamic listOfNotesCoordinatesJson, int numOfNotes)
{
  final List<Point> listOfCordNotesCoordinates = <Point>[];

  for(int i=0; i< numOfNotes; i++){
    final dynamic point = listOfNotesCoordinatesJson[i];
    final int x = convertDynamicToInt(point[X_JSON_KEY]);
    final int y = convertDynamicToInt(point[Y_JSON_KEY]);
    listOfCordNotesCoordinates.add(Point(x,y));
  }

  return listOfCordNotesCoordinates;
}

int convertDynamicToInt(dynamic jsonVal)
{
  return int.parse(jsonVal.toString());
}

List<Point> convJsonToListOfNotesCoordinates(String listOfNotesInfoStr)
{
  final dynamic listOfNotesInfoJson = json.decode(listOfNotesInfoStr);

  final dynamic listOfNotesCoordinatesJson = listOfNotesInfoJson[NOTES_COORDINAES_JSON_KEY];
  final int numOfNotes = convertDynamicToInt(listOfNotesInfoJson[NUM_NOTES_JSON_KEY]);

  return createPointsListFromJson(listOfNotesCoordinatesJson, numOfNotes);
}

Future<String> getPathToSaveFrame()
async {
  String dirPath = await getApplicationDocumentsDirectory().then((Directory dir) => dir.path);
  List<String> folders = dirPath.split("/");
  String newPath="";

  for(int i=1; i < folders.length; i++)
  {
    String folder = folders[i];
    if(folder != "app_flutter") {
      newPath += "/" + folder;
    }
    else {
      break;
    }
  }
  newPath += "/files/chaquopy/AssetFinder/app/d.jpeg";
  print("newPath:" + newPath);
  return newPath;
}

Future<String> fetchNotesInfoByPathOfFrame(String framePath) async {

  //String path = await getPathToSaveFrame(); //TODO
  //File(framePath).copy(path); //TODO
  //GallerySaver.saveImage(path); //TODO
  var outputMap = await Chaquopy.executeCode("script.py");
  print(outputMap['textOutputOrError'].toString());
  return outputMap['textOutputOrError'].toString();
}

List<Widget> createNoteWidgetsByListOfPoints(List<Point> listOfNotesCoordinates)
{
  final List<Widget> listOfWidgets = [];
  for(final Point point in listOfNotesCoordinates)
  {
    listOfWidgets.add(createNoteWidget(point));
  }
  return listOfWidgets;
}

Widget createTextWidget(String error, Color color, double height )
{
  return RichText(
    text: TextSpan(
      text: error,
      style: TextStyle(height: height, fontSize: 15, color: color, fontWeight: FontWeight.bold),
    ),
  );
}

String cleanStringForJson(String str)
{
  return str.replaceAll(RegExp(r'^.*?{"notes_coordinates"'), '{"notes_coordinates"');
}

Future<List<Widget>> createNoteWidgetsByFrame(String framePath)
async {
  String listOfNotesInfoStr = await fetchNotesInfoByPathOfFrame(framePath);
  listOfNotesInfoStr = listOfNotesInfoStr.replaceAll("\n", " ");
  print("stringC: " + listOfNotesInfoStr);
  List<Widget> listOfWidgets = [];
  if(listOfNotesInfoStr.contains(new RegExp(r'failed', caseSensitive: false)))
  {
      listOfWidgets.add(createTextWidget(listOfNotesInfoStr, Colors.red, 1));
  }
  else// TODO: Need to add after the image processing is ready
  {
    listOfWidgets.add(createTextWidget(listOfNotesInfoStr, Colors.green, 1));
    listOfNotesInfoStr = cleanStringForJson(listOfNotesInfoStr);
    final List<Point> listOfNotesCoordinates = convJsonToListOfNotesCoordinates(listOfNotesInfoStr);
    listOfWidgets = createNoteWidgetsByListOfPoints(listOfNotesCoordinates);
  }
  String pathToSaveFrame = await getPathToSaveFrame();
  listOfWidgets.add(createTextWidget(pathToSaveFrame, Colors.blue, 30));
  return listOfWidgets;
}

/*List<Widget> createNoteWidgetsByFrame(String framePath)
{
  return <Widget>[createNoteWidget(Point(1,2)), createNoteWidget((Point(50,40)))];
}*/

