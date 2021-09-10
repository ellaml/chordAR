import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:camera/camera.dart' as camera;
import 'package:flutter/services.dart';
import 'package:flutter_complete_guide/chord_notes.dart';
import 'package:flutter_complete_guide/utils.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'globals.dart' as globals;
import 'globals.dart';
//import 'globals.dart';
import 'package:chaquopy/chaquopy.dart';

import 'package:flutter_isolate/flutter_isolate.dart';
const chordsFileName = "chords.txt";
CameraController controller;

enum CameraType
{
  ONE,
  TWO
}

selectCamera1(selectedCamera) async {
  var controller =
  CameraController(selectedCamera, ResolutionPreset.ultraHigh);

  await controller.initialize();
  return controller;
}

void updating(String a) async
{
  /*CameraController controller1;
  CameraDescription selectedCamera;
  CameraType cameraType;

  camera.availableCameras().then((data) {
      if (data.length >= 2) {
        print("two cameras");
        cameraType = CameraType.TWO;
        selectedCamera = data[1];
      }
      else {
        print("one camera");
        cameraType = CameraType.ONE;
        selectedCamera = data[0];
      }
      selectCamera1(selectedCamera).then((data) {
        controller = data;
        print("Cameraaa");
        controller.takePicture();
      });
    });

  if(cameraType == CameraType.TWO)
  {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }*/

  print("A1");
  var _timer = Timer.periodic(Duration(seconds: 3), (Timer t)
  {
    runScript();
    //controller1.takePicture();
  });
}

void runScript() async
{
  print("oron!!!!!");
  var outputMap = await Chaquopy.executeCode("script.py");
  print(outputMap['textOutputOrError'].toString());
}

//UpdatingDetails updatingDetails = UpdatingDetails();
/*
void updating(UpdatingDetails updatingDetails) async
{
  print("A1");
  final topAddition = updatingDetails.topAddition;
  print("topAddition!!!!" + topAddition.toString());
  final leftAddition = updatingDetails.leftAddition;
  final cameraWidth = updatingDetails.cameraWidth;
  final cameraHeight = updatingDetails.cameraHeight;
  final filePath = updatingDetails.filePath;
  final pathToSaveFrame = updatingDetails.pathToSaveFrame;
  final controller = updatingDetails.cameraController;
  XFile xfile = await controller.takePicture();
  print("A2");//
  FetchChordsNotesAsJsonToFile(xfile.path, pathToSaveFrame, topAddition, leftAddition, cameraWidth, cameraHeight);
  //listOfChordPointsWidgets = await createNoteWidgetsByFrame(xfile.path, topAddition, leftAddition, cameraWidth, cameraHeight);

  print("A4");
  await removeFile(filePath);
  print("A5");

  //return listOfChordPointsWidgets;
}*/

class Camera extends StatefulWidget {
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> with WidgetsBindingObserver {
  CameraController _controller;
  CameraDescription _selectedCamera;
  CameraType _cameraType;
  double screenWidth, screenHeight;
  final _stackKey = GlobalKey();
  Timer _timer;
  List<Widget> listOfChordPointsWidgets = [];

  void doSomething() async {
    final isolate = await FlutterIsolate.spawn(updating, "a");
  }
  void _updateListOfChordPointWidgets() async {
    print("in updateListOfChord");
    //UpdatingDetails updatingDetails;
    /*final RenderBox renderBox = this._stackKey.currentContext.findRenderObject();

    final cameraHeight = renderBox.size.height;
    final cameraWidth = renderBox.size.width;
    String pathToSaveFrame = await getPathToSaveFrame();
    final topAddition = 80.0; //app bar
    final leftAddition = (this.screenWidth - cameraWidth) / 2; // centered
    updatingDetails = UpdatingDetails(_controller, screenWidth, cameraHeight, cameraWidth, topAddition, leftAddition, pathToSaveFrame, pathToSaveFrame);
    print("before isolate");
    //final isolate = await FlutterIsolate.spawn(updating, updatingDetails);
    final isolate = await FlutterIsolate.spawn(updating, "a");*/
    //final Directory directory = await getApplicationDocumentsDirectory();
    //print("Application documents directory: inside function _updateListOfChordPointWidgets" + directory.path);
   // final File file = File('${directory.path}/$chordsFileName');
   // if(await file.exists())
   // {
    //  print("file of chord notes exists!!!");
      //istOfChordPointsWidgets = await createNoteWidgetsByChordsNotesJson(topAddition, leftAddition, cameraWidth, cameraHeight);
   // }
   // else {
    //    print("file doesnt exist yet :(");
   // }

    //listOfChordPointsWidgets = await createNoteWidgetsByFrame(xfile.path, topAddition, leftAddition, cameraWidth, cameraHeight);
    //await removeFile(xfile.path);
  }

  void _saveImgToGallery() async {
    XFile xfile = await _controller?.takePicture();
    await ImageGallerySaver.saveFile(xfile.path); //Save Image to Gallery
    await removeFile(xfile.path);
  }

  @override
  void initState() {
    print("In init state");
    doSomething();
    super.initState();
    setupCamera();
    WidgetsBinding.instance.addObserver(this);
    _timer = Timer.periodic(Duration(seconds: 3), (Timer t) {
      print("Hiiii");
      setState(() {
        _updateListOfChordPointWidgets();
      });
    });
    //_timer = Timer.periodic(Duration(seconds: 10), (Timer t) {
    //  _saveImgToGallery();
    //});
    //
    //Fix for length and not mirroring in tablet
    if(_cameraType == CameraType.TWO)
    {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
    /*setState(() {
      _updateListOfChordPointWidgets();
    });*/
    //End of Fix for length and not mirroring in tablet
  }

  @override
  void dispose() {
    //Fix for length and not mirroring in tablet
    if(_cameraType == CameraType.TWO)
    {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
    //End of Fix for length and not mirroring in tablet

    WidgetsBinding.instance.addObserver(this);
    _timer.cancel();
    _timer = null;
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (_controller == null || !_controller.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      setupCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenData screenData = ScreenData(context);
    this.screenHeight = screenData.screenHeight;
    this.screenWidth = screenData.screenWidth;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme
              .of(context)
              .backgroundColor,
          centerTitle: true,
          title: Text("Live Mode",
              style: TextStyle(
                  fontSize: screenData.isBigDevice ? 32 : 24,
                  color: Colors.white)),
          leading: IconButton(
              icon: Icon(Icons.chevron_left_rounded),
              iconSize: 40,
              onPressed: () => Navigator.pop(context)),
          automaticallyImplyLeading: true,
          elevation: 0,
        ),
        body: _controller == null
            ? Container(color: Colors.black)
            : Center(
          child: Stack(
            key: this._stackKey,
            children: [
              CircularProgressIndicator(),
              CameraPreview(_controller),
              //Image.asset('assets/images/g70.png'), //Testing static image
              //...listOfChordPointsWidgets,  //TODO
            ],
          ),
        ));
  }

  void setupCamera()
  {
    availableCameras().then((data) {
      setState(() {
        if (data.length >= 2) {
          print("two cameras");
          _cameraType = CameraType.TWO;
          _selectedCamera = data[1];
        }
        else {
          print("one camera");
          _cameraType = CameraType.ONE;
          _selectedCamera = data[0];
        }
        selectCamera().then((data) {
          _controller = data;
          controller = data;
        });
      });
    });
  }

  selectCamera() async {
    var controller =
      CameraController(_selectedCamera, ResolutionPreset.ultraHigh);

    await controller.initialize();
    return controller;
  }


  Future<String> getPathToSaveFrame() async {
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
    newPath += "/files/chaquopy/AssetFinder/app/c.jpeg";
    print("newPath:" + newPath);
    return newPath;
  }


}

Future<void> removeFile(String filePath) async {
  final file = File(filePath);
  if (file.existsSync()) {
    await file.delete();
  }
}
