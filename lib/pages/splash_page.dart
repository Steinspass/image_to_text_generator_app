import 'package:flutter/material.dart';
import 'package:image_to_text_generator/pages/home_page.dart';
import 'package:splashscreen/splashscreen.dart';


class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 2,
      navigateAfterSeconds: HomePage(),
      title: Text(
        'Image to Text',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30.0,
          color: Color(0xFFFFB944),
        ),
      ),
      image: Image.asset('assets/notepad.png'),
      gradientBackground: LinearGradient(
        colors: [ 
        Color(0xFF009CFE),
        Color(0xFF448AFF),
        Color(0xFFB470E1),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,

      ),
      photoSize: 50.0,
      loaderColor: Color(0xFFFFB944), 
    );
  }
}