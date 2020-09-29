import 'package:flutter/material.dart';


class ButtonGradientWidget extends StatefulWidget {

  final String title;
  final Function() onTap;


  ButtonGradientWidget({
    @required this.title,
    @required this.onTap
  });

  @override
  _ButtonGradientWidgetState createState() => _ButtonGradientWidgetState();
}

class _ButtonGradientWidgetState extends State<ButtonGradientWidget> {
  
  @override
  Widget build(BuildContext context) {
    
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: MediaQuery.of(context).size.width - 200,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          horizontal: 22.0,
          vertical: 16.0
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          gradient: new LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFFFFA06B),
              Color(0xFFFFB944),
              Color(0xFFC5CE43)
            ], // whitish to gray
            tileMode: TileMode.repeated, // repeats the gradient over the canvas
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black45,
              spreadRadius: 0.5,
              blurRadius: 1
            )
          ]
        ),
        child: Text(
          widget.title,
          style: TextStyle(
            color: Color(0xFF448AFF),
            fontSize:  18.0,
            fontWeight: FontWeight.w500
          ),
        ),
      ),
    );
  }
}