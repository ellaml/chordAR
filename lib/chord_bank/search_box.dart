import 'package:flutter/material.dart';

class SearchBox extends StatefulWidget {
  final Function updateChord;

  const SearchBox(this.updateChord);

  @override
  State<StatefulWidget> createState() {
    return _SearchBoxState();
  }
}

class ChordOption {
  final String name;

  ChordOption(this.name);

  static List<ChordOption> getChordOptions(String query) {
    return [
      'A',
      'A7',
      'Ab',
      'Am',
      'B',
      'B7',
      'Bb7',
      'Bbm',
      'Bm',
      'C',
      'C#m',
      'C7',
      'Cm',
      'D',
      'D7',
      'Db',
      'Dm',
      'E flat',
      'E',
      'E7',
      'Eb7',
      'Em',
      'F',
      'F#',
      'F#m',
      'F7',
      'Fm',
      'G',
      'F#m',
      'G7',
      'Gm'
    ]
        .where((chordName) =>
            chordName.toLowerCase().contains(query.toLowerCase()))
        .map((chordName) => ChordOption(chordName))
        .toList();
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
        margin: EdgeInsets.only(top: 50, left: 40, right: 40),
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
                            // onSubmitted: (value) =>
                            //     widget.updateChord(value),
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
