import 'package:flutter/material.dart';
import 'models/chord.dart';

class SearchBox extends StatefulWidget {
  final Function updateChord;

  const SearchBox(this.updateChord);

  @override
  State<StatefulWidget> createState() {
    return _SearchBoxState();
  }
}

class _SearchBoxState extends State<SearchBox> {
  TextEditingController _controller;
  List<ChordOption> _chordOptions = [];
  String chosenChord;

  @override
  void initState() {
    _controller = new TextEditingController();
    _controller.addListener(() {
      setState(() =>
          _chordOptions = ChordOption.getChordOptions(_controller.value.text));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 40, right: 40),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).backgroundColor,
            boxShadow: [
              BoxShadow(
                  color: Colors.white12, offset: Offset(2, 2), blurRadius: 20)
            ]),
        child: Container(
            // margin: EdgeInsets.all(40),
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
                        height: 44,
                        width: 44,
                        margin: EdgeInsets.all(10),
                        child: Image.asset('assets/icons/glass64.png')),
                    Container(
                        width: 200,
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
                                    fontStyle: FontStyle.italic,
                                    color: Colors.white,
                                    fontSize: 18))))
                  ])),
              Container(
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          children: _chordOptions
                              .map((chordOption) => GestureDetector(
                                  onTap: () => {
                                        chosenChord = chordOption.name,
                                        widget.updateChord(chordOption.name),
                                      },
                                  child: Container(
                                      width: 60,
                                      height: 50,
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
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                        ))))
                              .toList())))
            ])));
  }
}
