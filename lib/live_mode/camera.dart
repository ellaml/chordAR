import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter_complete_guide/chord_notes.dart';
import 'package:flutter_complete_guide/utils.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'globals.dart' as globals;
import 'globals.dart';
//import 'globals.dart';

enum CameraType
{
  ONE,
  TWO
}



//UpdatingDetails updatingDetails = UpdatingDetails();

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

  void _updateListOfChordPointWidgets() async {
    UpdatingDetails updatingDetails;
    final RenderBox renderBox = this._stackKey.currentContext.findRenderObject();

    final cameraHeight = renderBox.size.height;
    final cameraWidth = renderBox.size.width;
    String pathToSaveFrame = await getPathToSaveFrame();
    final topAddition = 80.0; //app bar
    final leftAddition = (this.screenWidth - cameraWidth) / 2; // centered
    XFile xfile = await _controller?.takePicture();
    updatingDetails = UpdatingDetails(screenWidth, cameraHeight, cameraWidth, topAddition, leftAddition, xfile.path, pathToSaveFrame);
    String jsonUpdatingDetails = jsonEncode(updatingDetails);
    print("JSON:" + jsonUpdatingDetails);
    listOfChordPointsWidgets = await compute(updating, jsonUpdatingDetails);
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
    super.initState();
    setupCamera();
    WidgetsBinding.instance.addObserver(this);
    _timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
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
              ...listOfChordPointsWidgets,  //TODO
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
  final file = io.File(filePath);
  if (file.existsSync()) {
    await file.delete();
  }
}

Future<List<Widget>> updating(String updatingDetailsStr) async
{
  print("A1");
  dynamic d = jsonDecode(updatingDetailsStr);
  globals.UpdatingDetails updatingDetails = globals.UpdatingDetails.fromJson(d);
  final topAddition = updatingDetails.topAddition;
  print("topAddition!!!!" + topAddition.toString());
  final leftAddition = updatingDetails.leftAddition;
  final cameraWidth = updatingDetails.cameraWidth;
  final cameraHeight = updatingDetails.cameraHeight;
  final filePath = updatingDetails.filePath;
  final pathToSaveFrame = updatingDetails.pathToSaveFrame;
  print("A2");
  List<Widget> listOfChordPointsWidgets = await createNoteWidgetsByFrame(filePath, pathToSaveFrame, topAddition, leftAddition, cameraWidth, cameraHeight);
  //listOfChordPointsWidgets = await createNoteWidgetsByFrame(xfile.path, topAddition, leftAddition, cameraWidth, cameraHeight);

  print("A4");
  await removeFile(filePath);
  print("A5");
  return listOfChordPointsWidgets;

  //return listOfChordPointsWidgets;
}