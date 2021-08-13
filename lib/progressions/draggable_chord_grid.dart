import 'package:flutter/material.dart';
import 'package:drag_and_drop_gridview/devdrag.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_complete_guide/models/chord.dart';
import 'package:dotted_border/dotted_border.dart';

class DraggableChordGrid extends StatefulWidget {
  @override
  _DraggableChordGrid createState() => _DraggableChordGrid();

  List<ChordOption> chords;
  final Function deleteChord;
  final double chordBoxWidth, chordBoxHeight;
  final chordsInRow;
  
  //TODO: move to state if better
  DraggableChordGrid(chords, this.chordBoxWidth, this.chordBoxHeight,
      this.deleteChord, this.chordsInRow) {
    this.chords = chords;
    if (this.chords.length == 0 || (this.chords.last.name != "dummy")) {
      this.chords.add(ChordOption("dummy"));
    }
  }
}

class _DraggableChordGrid extends State<DraggableChordGrid> {
  int variableSet = 0;
  ScrollController _scrollController;
  double width;
  double height;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: DragAndDropGridView(
      controller: _scrollController,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.chordsInRow,
        childAspectRatio: 10 / 6.5,
      ),
      itemBuilder: (context, index) => Card(
        color: Theme.of(context).backgroundColor,
        margin: EdgeInsets.symmetric(horizontal: widget.chordsInRow < 4 ? 30 : 50, vertical: widget.chordsInRow <4 ? 10 : 20),
        child: LayoutBuilder(
          builder: (context, constrains) {
            if (variableSet == 0) {
              height = constrains.maxHeight;
              width = constrains.maxWidth;
              variableSet++;
            }
            return GridTile(
                child: widget.chords[index].name == 'dummy'
                    ? Container(
                        child: DottedBorder(
                            dashPattern: [10, 10],
                            strokeWidth: 2,
                            color: Theme.of(context).primaryColor,
                            borderType: BorderType.RRect,
                            radius: Radius.circular(10),
                            padding: EdgeInsets.all(6),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              child: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "+",
                                    style: TextStyle(fontSize: 40),
                                  )),
                            )),
                      )
                    : Container(
                        width: widget.chordBoxWidth,
                        height: widget.chordBoxHeight,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.white12,
                                  offset: Offset(2, 2),
                                  blurRadius: 20)
                            ],
                            color: Color(0x60FFFFFF),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.all(
                                width: 2,
                                color: Theme.of(context).primaryColor)),
                        child: Column(
                          children: [
                            Container(
                              height: 0.4 * widget.chordBoxHeight,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                        margin: EdgeInsets.all(5),
                                        child: GestureDetector(
                                          onTap: () =>
                                              widget.deleteChord(index),
                                          child: Image.asset(
                                              'assets/icons/letter-x.png'),
                                        ))
                                  ]),
                            ),
                            Center(
                                child: Text(
                              widget.chords[index].name,
                              style: TextStyle(
                                  fontSize: 0.3 * widget.chordBoxHeight,
                                  fontWeight: FontWeight.bold),
                            ))
                          ],
                        )));
          },
        ),
      ),
      itemCount: widget.chords.length,
      onWillAccept: (oldIndex, newIndex) {
        if (widget.chords[newIndex].name == "dummy") {
          return false;
        }
        return true;
      },
      onReorder: (oldIndex, newIndex) {
        if (widget.chords[oldIndex].name != "dummy") {
          final temp = widget.chords[oldIndex];
          widget.chords[oldIndex] = widget.chords[newIndex];
          widget.chords[newIndex] = temp;
        }
      },
    ));
  }
}
