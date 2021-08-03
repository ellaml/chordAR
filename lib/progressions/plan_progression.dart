// import 'package:flutter/material.dart';
// import 'package:flutter_complete_guide/models/chord.dart';
// import 'package:flutter_complete_guide/search_box.dart';
// import 'package:drag_and_drop_gridview/devdrag.dart';

// class PlanProgression extends StatefulWidget {

//   static const routeName = '/single-progression';

//   List<ChordOption> chords;
//   PlanProgression(this.chords);

//   @override
//   _PlanProgression createState() => _PlanProgression();
// }


// class _PlanProgression extends State<PlanProgression> {

//   int variableSet = 0;
//   ScrollController _scrollController;
//   double width;
//   double height;

//   @override
//   Widget build(BuildContext context) {
//     return Column(children: [
//       Container(margin: EdgeInsets.only(bottom: 20), child: SearchBox(null)),
//       Container(
//           width: 300,
//           child: DragAndDropGridView(
//             controller: _scrollController,
//             primary: false,
//             padding: const EdgeInsets.all(10),
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisSpacing: 10,
//               mainAxisSpacing: 10,
//               crossAxisCount: 3,
//               childAspectRatio: (50 / 50),
//             ),
//             itemBuilder: (context, index) => Card(
//                 elevation: 2,
//                 child: LayoutBuilder(builder: (context, constrains) {
//                   if (variableSet == 0) {
//                     height = constrains.maxHeight;
//                     width = constrains.maxWidth;
//                     variableSet++;
//                   }
//                   return Container(
//                       width: 60,
//                       height: 50,
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                           boxShadow: [
//                             BoxShadow(
//                                 color: Colors.white12,
//                                 offset: Offset(2, 2),
//                                 blurRadius: 20)
//                           ],
//                           color: Color(0x60FFFFFF),
//                           borderRadius: BorderRadius.all(Radius.circular(10)),
//                           border: Border.all(
//                               width: 2, color: Theme.of(context).primaryColor)),
//                       padding: EdgeInsets.all(10),
//                       margin: EdgeInsets.all(10),
//                       child: Text(
//                         widget.chords[index].name,
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ));
//                 })),
//             onWillAccept: (oldIndex, newIndex) {
//               return true;
//             },
//             onReorder: (oldIndex, newIndex) {
//               final temp = widget.chords[oldIndex];
//               widget.chords[oldIndex] = widget.chords[newIndex];
//               widget.chords[newIndex] = temp;

//               setState(() {});
//             },
//           )),
//     ]); //should be: name input -> plan prog (search + grid) -> interval input -> save/back button
//   }
// }
