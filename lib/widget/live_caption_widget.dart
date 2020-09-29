import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_to_text_generator/api/service_api.dart';
import 'package:image_to_text_generator/widget/button_gradient_widget.dart';
import 'package:path_provider/path_provider.dart';


class GenerateLiveCaptionsWidget extends StatefulWidget {
  GenerateLiveCaptionsWidget();

  @override
  _GenerateLiveCaptionsWidgetState createState() => _GenerateLiveCaptionsWidgetState();
}

class _GenerateLiveCaptionsWidgetState extends State<GenerateLiveCaptionsWidget> {

  String resultText = 'Fetching Response ...';
  List<CameraDescription> cameras;
  CameraController cameraController;
  bool takePhoto = false;

  @override
  void initState() {
    super.initState();
    takePhoto = true;

    detectCameras().then((_){
      initializeController();
    });

  }

  Future<void> detectCameras() async {
    cameras = await availableCameras();
  }

  void initializeController(){
    cameraController = CameraController(cameras[0], ResolutionPreset.medium);

    cameraController.initialize().then((value) {
      
      if(!mounted){
        return;
      }
      setState(() {});
      if(takePhoto){
        const interval = const Duration(seconds: 5);

        new Timer.periodic(
          interval, (Timer timer) => capturePictures()
        );
      }

    });
  }

  capturePictures() async{
    String timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
    
    final Directory extDir = await getApplicationDocumentsDirectory();

    final String dirPath = '${extDir.path}/Pictures/flutter_test';

    await Directory(dirPath).create(recursive: true);

    final String filePath = '$dirPath/{$timeStamp}.png';

    if(takePhoto){
      cameraController.takePicture(filePath).then((_) async {
        if(takePhoto) {
          File imgFile = File(filePath);

          Map<String, dynamic> response = await APIService().fetchResponse(imgFile);

          resultText = APIService().parseResponseCaption(response);

          setState(() {});

        }else{
          return;
        }
      });
    }    
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: (cameraController.value.isInitialized) ? _buildCameraPreview() : Container(),
    );
  }

  Widget _buildCameraPreview() {
    // var size = MediaQuery.of(context).size.width / 1.5;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 20),
        Container(
          width: 200,
          height: 200,
          child: CameraPreview(cameraController),
        ),
        SizedBox(height: 20),
        Text(
          'Prediction is: \n',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFFFFB944),
            fontWeight: FontWeight.bold,
            fontSize: 30.0
          ),
        ),
        _containerResultText()
      ],
    );
  }


  Widget _containerResultText(){
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 30.0,
        vertical: 15.0
      ),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child:  _textResultWidget(),
    );
  }

  

  Widget _textResultWidget() {
    return Container(
      child: Text(
        '$resultText',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14.0,
          color: Colors.blueGrey[800]
        ),
      ),
    );
  }

  Widget _columnOfButtonsWithImage() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          ButtonGradientWidget(title: 'Copy the text',onTap: (){

            Clipboard.setData(ClipboardData(text: resultText));
            _copyWithSuccessSnackbar();

          },),
          SizedBox(height: 15.0,),
        ],
      ),
    );
  }

  void _copyWithSuccessSnackbar() {
    Flushbar(
      margin: EdgeInsets.symmetric(
        vertical: 20.0,
        horizontal: 25.0,
      ),
      borderRadius: 10,
      backgroundGradient: LinearGradient(
        colors: [
          Color(0xFFFFB944),
          Color(0xFFC5CE43)
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      boxShadows: [BoxShadow(offset: Offset(0.5, 0.5), blurRadius: 1.0,)],
      duration: Duration(seconds: 3),
      messageText: Text(
        'Copied the Text',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFF448AFF),
          fontWeight: FontWeight.bold,
          fontSize: 20.0
        ),
        ),
    )..show(context);
  }

  
}