import 'package:flutter/material.dart';
import '../app_colors.dart' as appColors;

class MenuButton extends StatelessWidget {
  final String buttonLabel;
  final String imgSrc;
  final Widget route;
  final double height, width;

  void changeScreen(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return this.route;
      },
    ));
  }

  MenuButton(
      this.route, this.imgSrc, this.buttonLabel, this.height, this.width);

  @override
  Widget build(BuildContext context) {
    double imageSize = (width > 400 ? 0.3 : 0.23) * this.width;
    return Container(
        width: width,
        height: height,
        color: Color(0x00FFFFFF),
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                      height: imageSize,
                      width: imageSize,
                      margin: EdgeInsets.fromLTRB(
                          0, 0.1 * imageSize, 0.2 * imageSize, 10),
                      child: Image.asset(this.imgSrc)),
                  Container(
                      child: Text(
                    buttonLabel,
                    style: TextStyle(
                        fontSize: 0.24 * this.height,
                        fontWeight: FontWeight.bold,
                        color: appColors.buttonText),
                    textAlign: TextAlign.center,
                  ))
                ])));
  }
}
