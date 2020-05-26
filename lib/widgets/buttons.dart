import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_button/awesome_button.dart';
import 'package:flutter/material.dart';

class Buttons extends StatelessWidget {
  final Shader linearGradient = LinearGradient(
    colors: <Color>[Color(0xff191970), Color(0xff0000ff)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  final String buttonText;
  final Function buttonFunc;

  Buttons({this.buttonText, this.buttonFunc});


  @override
  Widget build(BuildContext context) {
    return             Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: AwesomeButton(
        blurRadius: 15.0,
        splashColor: Color.fromRGBO(255, 255, 255, .4),
        borderRadius: BorderRadius.circular(37.5),
        height: MediaQuery.of(context).size.height * 0.06,
        width: MediaQuery.of(context).size.width,
        onTap: buttonFunc,
        color: Colors.blueAccent,
        child: Padding(
          padding:
          EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
          child: AutoSizeText(
            buttonText,
            style: TextStyle(
              foreground: Paint()..shader = linearGradient,
              fontSize: 30.0,
            ),
          ),
        ),
      ),
    );
  }
}
