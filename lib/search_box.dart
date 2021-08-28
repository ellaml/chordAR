import 'package:flutter/material.dart';
import 'models/chord.dart';
import 'utils.dart';

class SearchBox extends StatefulWidget {
  final Function callBack;
  final double width;

  const SearchBox(this.callBack, this.width);

  @override
  State<StatefulWidget> createState() {
    return _SearchBoxState();
  }
}

class _SearchBoxState extends State<SearchBox> {
  TextEditingController _controller;
  List<Chord> _chordOptions = [];
  String chosenChord;

  @override
  void initState() {
    _controller = new TextEditingController();
    _controller.addListener(() {
      setState(() =>
          _chordOptions = Chord.getChordOptions(_controller.value.text));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenData screenData = ScreenData(context);
    double chordBoxWidth = screenData.isBigDevice ? 90 : 60;
    double chordBoxHeight = screenData.isBigDevice ? 70 : 50;
    return Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).backgroundColor,
            boxShadow: [
              BoxShadow(
                  color: Colors.white12, offset: Offset(2, 2), blurRadius: 20)
            ]),
        child: Container(
            width: widget.width,
            decoration: BoxDecoration(
                color: Color(0x26FFFFFF),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white)),
            child: Column(children: [
              Container(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                    Container(
                        height: screenData.isBigDevice ? 70 : 44,
                        width: screenData.isBigDevice ? 70 : 44,
                        margin: EdgeInsets.all(10),
                        child: Image.asset('assets/icons/glass' +
                            (screenData.isBigDevice ? '128' : '64') +
                            '.png')),
                    Container(
                        width: widget.width * 0.7,
                        child: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                filled: false,
                                labelText: "Filter by name...",
                                labelStyle: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontStyle: FontStyle.italic,
                                    color: Colors.white,
                                    fontSize:
                                        screenData.isBigDevice ? 26 : 18))))
                  ])),
              Container(
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          children: _chordOptions
                              .map((chordOption) => GestureDetector(
                                  onTap: () => {
                                        chosenChord = chordOption.name,
                                        widget.callBack(chordOption.name),
                                      },
                                  child: Container(
                                      width: chordBoxWidth,
                                      height: chordBoxHeight,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          boxShadow:
                                              chosenChord == chordOption.name
                                                  ? [
                                                      BoxShadow(
                                                          color: Colors.white12,
                                                          offset: Offset(2, 2),
                                                          blurRadius: 20)
                                                    ]
                                                  : null,
                                          color: this.chosenChord ==
                                                  chordOption.name
                                              ? Color(0x60FFFFFF)
                                              : null,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          border: Border.all(
                                              width: 2,
                                              color: Theme.of(context)
                                                  .primaryColor)),
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.all(10),
                                      child: Text(
                                        chordOption.name,
                                        style: TextStyle(
                                            fontSize: 0.3 * chordBoxHeight,
                                            fontWeight: FontWeight.bold),
                                      ))))
                              .toList())))
            ])));
  }
}
