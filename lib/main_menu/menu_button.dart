import 'package:flutter/material.dart';
import '../app_colors.dart' as appColors;

class MenuButton extends StatelessWidget {
  final String buttonLabel;
  final String imgSrc;
  final Widget route;

  void changeScreen(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return this.route;
      },
    ));
  }

  MenuButton(this.route, this.imgSrc, this.buttonLabel);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 235,
        height: 85,
        color: Color(0x00FFFFFF),
        margin: EdgeInsets.all(10),
        child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Color(0x00FFFFFF)),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  side: BorderSide(
                      color: appColors.borderPurple,
                      width: 1,
                      style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(10))),
            ),
            onPressed: () => changeScreen(context),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                      height: 64,
                      width: 64,
                      margin: EdgeInsets.all(10),
                      child: Image.asset(this.imgSrc)),
                  Container(
                      child: Text(
                    buttonLabel,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: appColors.buttonText),
                    textAlign: TextAlign.center,
                  ))
                ])));
  }
}
