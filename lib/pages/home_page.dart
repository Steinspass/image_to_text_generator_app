import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_to_text_generator/api/service_api.dart';
import 'package:image_to_text_generator/widget/button_gradient_widget.dart';
import 'package:image_to_text_generator/widget/live_caption_widget.dart';


class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  bool _loading = true;
  File _image;
  final picker = ImagePicker();
  String resultText = 'Fetching Response ...';
  bool isLiveCamera = false;


  pickImagePhoto() async {
    var image = await picker.getImage(source: ImageSource.camera);

    if(image == null) return null;

    setState(() {
      _image = File(image.path);
      _loading = false;
    });

    Map<String, dynamic> response = await APIService().fetchResponse(_image);

    print(response);

    resultText = APIService().parseResponseCaption(response);

    setState(() {});

  }

  pickImageGallery() async {
    var image = await picker.getImage(source: ImageSource.gallery);

    if(image == null) return null;

    setState(() {
      _image = File(image.path);
      _loading = false;
    });

    Map<String, dynamic> response = await APIService().fetchResponse(_image);

    print(response);

    resultText = APIService().parseResponseCaption(response);

    setState(() {});

  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _backgroundContainer(),
    );
  }

  Widget _backgroundContainer() {  

    Widget liveCameraWidget = new GenerateLiveCaptionsWidget();

    List<Widget> widgets = [
      SizedBox(height: 40.0,),
      _titleOfPage(),
      SizedBox(height: 6.0,),
      _subtitleOfPage(),
      SizedBox(height: 20.0,),
      _centerImage(),
      SizedBox(height: 20.0,),
      _loading ? _columnOfButtonsForImage() : _columnOfButtonsWithImage(),
      SizedBox(height: 10.0,),
    ];

    List<Widget> liveCameraWidgets = [
      SizedBox(height: 40.0,),
      _titleOfPage(),
      SizedBox(height: 6.0,),
      _subtitleOfPage(),
      SizedBox(height: 20.0,),
      liveCameraWidget,
      SizedBox(height: 10.0,),
      ButtonGradientWidget(title: 'Delete actual data',onTap: (){
            
        setState(() {
          _loading = true;
          resultText = 'Fetching Response ...';
          isLiveCamera = false;
        });

      },),
    ];  

    return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
      colors: [ 
      Color(0xFF009CFE),
      Color(0xFF448AFF),
      Color(0xFFB470E1),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      ),
    ),
    child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: (!isLiveCamera) ? widgets : liveCameraWidgets,
        ),
      ),
    );
  }

  Widget _titleOfPage() {
    return Center(
      child: ColorizeAnimatedTextKit(
        text: ['Text Generator'],
        textStyle: TextStyle(
          fontSize: 32.0,
          fontWeight: FontWeight.bold
        ),
        colors: [
          Color(0xFFFFA06B),
          Color(0xFFFFB944),
          Color(0xFFC5CE43)
        ], 
        repeatForever: true,
        speed: Duration(milliseconds: 600),
        pause: Duration(milliseconds: 100),
      ),
    );
  }

  Widget _subtitleOfPage() {
    return ColorizeAnimatedTextKit(
      text: ['Image to Text Generator with NLP Algorithm'],
      textStyle: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold
      ),
      colors: [
        Color(0xFFFFA06B),
        Color(0xFFFFB944),
        Color(0xFFC5CE43)
      ], 
      repeatForever: true,
      speed: Duration(milliseconds: 600),
      pause: Duration(milliseconds: 100),
    );
  }

  Widget _centerImage() {

    return Center(
      child: _loading ? _imagePlaceholder() : _columnOfImageAndText(),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      width: 100.0,
      child: Column(
        children: [
          Image.asset('assets/notepad.png'),
          SizedBox(height: 40.0,)
        ],
      ),
    );
  }

  Widget _columnOfImageAndText(){
    return Column(
      children: [
        _imagePicked(),
        SizedBox(height: 20.0,),
        _containerResultText()
      ],
    );
  }

  Widget _imagePicked(){
    return Container(
      height: 200.0,
      width: MediaQuery.of(context).size.width - 205,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            spreadRadius: 0.5,
            blurRadius: 1
          )
        ]
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Image.file(
          _image, fit: 
          BoxFit.fill,
        ),
      ),
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


  Widget _columnOfButtonsForImage() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          ButtonGradientWidget(title: 'Live Camera',onTap: (){
              setState(() {
                isLiveCamera = true;
              });
          },),
          SizedBox(height: 25.0,),
          ButtonGradientWidget(title: 'Take a photo',onTap: (){
            pickImagePhoto();
          },),
          SizedBox(height: 25.0,),
          ButtonGradientWidget(title: 'Open Gallery',onTap: (){
            pickImageGallery();
          },),
        ],
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
          ButtonGradientWidget(title: 'Delete actual data',onTap: (){
            
            setState(() {
              _loading = true;
              resultText = 'Fetching Response ...';
            });

          },),
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