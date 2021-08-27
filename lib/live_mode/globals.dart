library my_prj.globals;
import 'package:json_annotation/json_annotation.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
//part 'globals.g.dart';

bool isLoggedIn = false;

@JsonSerializable(nullable: true)
class UpdatingDetails {
 // RenderBox renderBox;
  var cameraHeight;
  var cameraWidth;
  var topAddition;
  var leftAddition;
  var filePath;
  var pathToSaveFrame;
  //var cameraController;

  UpdatingDetails(screenWidth, cameraHeight, cameraWidth, topAddition, leftAddition, filePath, pathToSaveFrame)
  {
  //  this.renderBox = renderBox;
    this.cameraHeight = cameraHeight;
    this.cameraWidth = cameraWidth;
    this.topAddition = 80.0; //app bar
    this.leftAddition = (screenWidth - cameraWidth) / 2; // centered
    this.filePath = filePath;
    this.pathToSaveFrame = pathToSaveFrame;
   // this.cameraController = cameraController;
  }

  Map toJson() => {
    'cameraHeight': cameraHeight,
    'cameraWidth': cameraWidth,
    'topAddition': topAddition,
    'leftAddition': leftAddition,
    'filePath': filePath,
    'pathToSaveFrame': pathToSaveFrame
  };

  UpdatingDetails.fromJson(Map<String, dynamic> json)
      : cameraHeight = json['cameraHeight'],
        cameraWidth = json['cameraWidth'],
        topAddition = json['topAddition'],
        leftAddition = json['leftAddition'],
        filePath = json['filePath'],
        pathToSaveFrame = json['pathToSaveFrame'];

 /* const UpdatingDetails({
    this.renderBox
  });*/

  //factory UpdatingDetails.fromJson(Map<String, dynamic> json) => _$UpdatingDetailsFromJson(json);
  //Map<String, dynamic> toJson() => _$UpdatingDetailsToJson(this);

  /*@override
  String toString() =>
      'renderBox: $renderBox}';*/

}