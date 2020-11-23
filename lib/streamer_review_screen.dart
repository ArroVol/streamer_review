import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:streamer_review/helper/database_helper.dart' as DBHelper;

import 'helper/database_helper.dart';



class ReviewPage extends StatefulWidget {
  @override
  StreamerReview  createState() => new StreamerReview ();
}

class StreamerReview extends State<ReviewPage> {
  static const String username = 'Temp Username';
  double satisfaction_rating;
  double entertainment_rating;
  double interaction_rating;
  double skill_rating;
  List<String> tags = [];
  String dropdownValue = 'Gaming';
  List<int> tagKeys = [];
  // int broadcaster_id = 229729353;
  // int broadcaster_id = 48526626;
  // int broadcaster_id = 469790580;
  // int broadcaster_id = 37402112;
  int broadcaster_id = 26261471;

  int user_id = 1;

  int old_satisfaction_rating = 1;
  int old_entertainment_rating = 1;
  int old_interaction_rating = 1;
  int old_skill_rating = 1;

  var oldReview;

  List <MultiSelectDialogItem<int>> multiItem = List();

  final valuestopopulate = {
    1 : 'Gaming',
    2 : 'Food & Drinks',
    3 : 'Sports & Fitness',
    4 : 'Talk Shows & Podcasts',
    5 : 'Just Chatting',
    6 : 'Makers & Crafting',
    7 : 'Tabletop RPGs',
    8 : 'Science & Technologies',
    9 : 'Music & Performing Arts',
    10 : 'Beauty & Body Art',
    11 : 'Travel & Outdoors',
    12 : 'ASMR',
  };

  Future<void> submitReview() async {
    // print(tags);
    DatabaseHelper2 d = DBHelper.DatabaseHelper2.instance;
    await d.insertReview(satisfaction_rating, entertainment_rating, interaction_rating, skill_rating, broadcaster_id, user_id);
    await d.updateBroadcaster(broadcaster_id, user_id);
  }

  void getOldReview() async {
    DatabaseHelper2 d = DBHelper.DatabaseHelper2.instance;
    oldReview = await d.selectReviews(broadcaster_id, user_id);
    print(oldReview[0]);
    print(oldReview[0]['satisfaction_rating'].runtimeType);
    old_satisfaction_rating = oldReview[0]['satisfaction_rating'];
    old_entertainment_rating = oldReview[0]['entertainment_rating'];
    old_interaction_rating = oldReview[0]['interactiveness_rating'];
    old_skill_rating = oldReview[0]['skill_rating'];
    setState(() {
      if(oldReview != null) {
        old_satisfaction_rating = oldReview[0]['satisfaction_rating'];
        old_entertainment_rating = oldReview[0]['entertainment_rating'];
        old_interaction_rating = oldReview[0]['interactiveness_rating'];
        old_skill_rating = oldReview[0]['skill_rating'];
      } else{
        old_satisfaction_rating = 1;
        old_entertainment_rating = 1;
        old_interaction_rating = 1;
        old_skill_rating = 1;
      }

    });
  }

  @override
  void initState() {
    getOldReview();
    super.initState();
  }


  void populateMultiselect(){
    for(int v in valuestopopulate.keys){
      multiItem.add(MultiSelectDialogItem(v, valuestopopulate[v]));
    }
  }


  void _showMultiSelect(BuildContext context) async {
    multiItem = [];
    populateMultiselect();
    final items = multiItem;


    final selectedValues = await showDialog<Set<int>>(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          items: items,
          initialSelectedValues: tagKeys.toSet(),
        );
      },
    );

    // print('this' + selectedValues.toString());
    getvaluefromkey(selectedValues);
  }



  void getvaluefromkey(Set selection){
    tags.clear();
    tagKeys.clear();
    if(selection != null){
      for(int x in selection.toList()){
        // print(valuestopopulate[x]);
        tags.add(valuestopopulate[x]);
        tagKeys.add(x);
        // print(tags);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.purple[900], Colors.white],
                  stops: [0.2, 1],
                )),
            child: Container(
              width: double.infinity,
              height: MediaQuery
                  .of(context)
                  .size
                  .height * .9,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Reviewing " + username,
                      style: TextStyle(
                        fontSize: 22.0,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Card(
                      margin:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      clipBehavior: Clip.antiAlias,
                      color: Colors.white,
                      elevation: 5.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 12.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    "Category",
                                    style: TextStyle(
                                      color: Colors.deepPurple,
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  RaisedButton(
                                    child: Text("Show Categories"),
                                    onPressed: () => _showMultiSelect(context),
                                  ),

                                  // DropdownButton<String>(
                                  //   value: dropdownValue,
                                  //   icon: Icon(Icons.arrow_downward),
                                  //   iconSize: 24,
                                  //   elevation: 16,
                                  //   style: TextStyle(color: Colors.deepPurple),
                                  //   underline: Container(
                                  //     height: 2,
                                  //     color: Colors.deepPurpleAccent,
                                  //   ),
                                  //   onChanged: (String newValue) {
                                  //     setState(() {
                                  //       dropdownValue = newValue;
                                  //     });
                                  //   },
                                  //   items: <String>[
                                  //     'Gaming',
                                  //     'Food & Drinks',
                                  //     'Sports & Fitness',
                                  //     'Talk Shows & Podcasts',
                                  //     'Just Chatting',
                                  //     'Makers & Crafting',
                                  //     'Tabletop RPGs',
                                  //     'Science & Technologies',
                                  //     'Music & Performing Arts',
                                  //     'Beauty & Body Art',
                                  //     'Travel & Outdoors',
                                  //     'ASMR',
                                  //   ].map<DropdownMenuItem<String>>(
                                  //           (String value) {
                                  //         return DropdownMenuItem<String>(
                                  //           value: value,
                                  //           child: Text(value),
                                  //         );
                                  //       }).toList(),
                                  // ),

                                  SizedBox(
                                    height: 5.0,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      margin:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
                      clipBehavior: Clip.antiAlias,
                      color: Colors.white,
                      elevation: 5.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 12.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    "Overall Satisfaction",
                                    style: TextStyle(
                                      color: Colors.deepPurple,
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  RatingBar.builder(
                                    initialRating: old_satisfaction_rating.toDouble(),
                                    itemCount: 5,
                                    itemPadding:
                                    EdgeInsets.symmetric(horizontal: 4.0),
                                    itemBuilder: (context, index) {
                                      switch (index) {
                                        case 0:
                                          return Icon(
                                            Icons.sentiment_very_dissatisfied,
                                            color: Colors.red,
                                          );
                                        case 1:
                                          return Icon(
                                            Icons.sentiment_dissatisfied,
                                            color: Colors.yellow[900],
                                          );
                                        case 2:
                                          return Icon(
                                            Icons.sentiment_neutral,
                                            color: Colors.amber[700],
                                          );
                                        case 3:
                                          return Icon(
                                            Icons.sentiment_satisfied,
                                            color: Colors.limeAccent[700],
                                          );
                                        case 4:
                                          return Icon(
                                            Icons.sentiment_very_satisfied,
                                            color: Colors.greenAccent[700],
                                          );
                                      }
                                    },
                                    onRatingUpdate: (rating) {
                                      satisfaction_rating = rating;
                                      print(rating);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      margin:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
                      clipBehavior: Clip.antiAlias,
                      color: Colors.white,
                      elevation: 5.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 15.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    "Entertainment Value",
                                    style: TextStyle(
                                      color: Colors.deepPurple,
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  RatingBar.builder(
                                    initialRating: old_entertainment_rating.toDouble(),
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: false,
                                    itemCount: 5,
                                    itemPadding:
                                    EdgeInsets.symmetric(horizontal: 4.0),
                                    itemBuilder: (context, _) =>
                                        Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                    onRatingUpdate: (rating) {
                                      entertainment_rating = rating;
                                      print(rating);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      margin:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
                      clipBehavior: Clip.antiAlias,
                      color: Colors.white,
                      elevation: 5.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 15.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    "Viewer Interaction",
                                    style: TextStyle(
                                      color: Colors.deepPurple,
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  RatingBar.builder(
                                    initialRating: old_interaction_rating.toDouble(),
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: false,
                                    itemCount: 5,
                                    itemPadding:
                                    EdgeInsets.symmetric(horizontal: 4.0),
                                    itemBuilder: (context, _) =>
                                        Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                    onRatingUpdate: (rating) {
                                      interaction_rating = rating;
                                      print(rating);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      margin:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
                      clipBehavior: Clip.antiAlias,
                      color: Colors.white,
                      elevation: 5.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 15.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    "Skill Level",
                                    style: TextStyle(
                                      color: Colors.deepPurple,
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  RatingBar.builder(
                                    initialRating: old_skill_rating.toDouble(),
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: false,
                                    itemCount: 5,
                                    itemPadding:
                                    EdgeInsets.symmetric(horizontal: 4.0),
                                    itemBuilder: (context, _) =>
                                        Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                    onRatingUpdate: (rating) {
                                      skill_rating = rating;
                                      print(rating);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      margin:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
                      clipBehavior: Clip.antiAlias,
                      color: Colors.white,
                      elevation: 5.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 15.0),
                        child: new ButtonBar(
                          alignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            RaisedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(80.0)),
                                elevation: 0.0,
                                padding: EdgeInsets.all(0.0),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.centerRight,
                                        end: Alignment.centerLeft,
                                        colors: [
                                          Colors.deepPurpleAccent,
                                          Colors.deepPurple[700]
                                        ]),
                                    borderRadius:
                                    BorderRadius.circular(30.0),
                                  ),
                                  child: Container(
                                    constraints: BoxConstraints(
                                        maxWidth: 150.0, minHeight: 50.0),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "BACK",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )),
                            RaisedButton(
                                onPressed: () {
                                  submitReview();
                                  Navigator.pop(context);
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(80.0)),
                                elevation: 0.0,
                                padding: EdgeInsets.all(0.0),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.centerRight,
                                        end: Alignment.centerLeft,
                                        colors: [
                                          Colors.deepPurpleAccent,
                                          Colors.deepPurple[700]
                                        ]),
                                    borderRadius:
                                    BorderRadius.circular(30.0),
                                  ),
                                  child: Container(
                                    constraints: BoxConstraints(
                                        maxWidth: 150.0, minHeight: 50.0),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "SUBMIT",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                        // child: Row(
                        //   children: <Widget>[
                        //     Expanded(
                        //       child: Column(
                        //         children: <Widget>[
                        //           SizedBox(
                        //             height: 5.0,
                        //           ),
                        //           RaisedButton(
                        //               onPressed: () {
                        //                 Navigator.pop(context);
                        //               },
                        //               shape: RoundedRectangleBorder(
                        //                   borderRadius:
                        //                   BorderRadius.circular(80.0)),
                        //               elevation: 0.0,
                        //               padding: EdgeInsets.all(0.0),
                        //               child: Ink(
                        //                 decoration: BoxDecoration(
                        //                   gradient: LinearGradient(
                        //                       begin: Alignment.centerRight,
                        //                       end: Alignment.centerLeft,
                        //                       colors: [
                        //                         Colors.deepPurpleAccent,
                        //                         Colors.deepPurple[700]
                        //                       ]),
                        //                   borderRadius:
                        //                   BorderRadius.circular(30.0),
                        //                 ),
                        //                 child: Container(
                        //                   constraints: BoxConstraints(
                        //                       maxWidth: 150.0, minHeight: 50.0),
                        //                   alignment: Alignment.center,
                        //                   child: Text(
                        //                     "RETURN",
                        //                     style: TextStyle(
                        //                         color: Colors.white,
                        //                         fontSize: 22.0,
                        //                         fontWeight: FontWeight.bold),
                        //                   ),
                        //                 ),
                        //               )),
                        //         ],
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MultiSelectDialogItem<V> {
  const MultiSelectDialogItem(this.value, this.label);

  final V value;
  final String label;
}

class MultiSelectDialog<V> extends StatefulWidget {
  MultiSelectDialog({Key key, this.items, this.initialSelectedValues}) : super(key: key);

  final List<MultiSelectDialogItem<V>> items;
  final Set<V> initialSelectedValues;

  @override
  State<StatefulWidget> createState() => _MultiSelectDialogState<V>();
}

class _MultiSelectDialogState<V> extends State<MultiSelectDialog<V>> {
  final _selectedValues = Set<V>();

  void initState() {
    super.initState();
    if (widget.initialSelectedValues != null) {
      _selectedValues.addAll(widget.initialSelectedValues);
    }
  }

  void _onItemCheckedChange(V itemValue, bool checked) {
    setState(() {
      if (checked) {
        _selectedValues.add(itemValue);
      } else {
        _selectedValues.remove(itemValue);
      }
    });
  }

  void _onCancelTap() {
    Navigator.pop(context);
  }

  void _onSubmitTap() {
    Navigator.pop(context, _selectedValues);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Tags'),
      contentPadding: EdgeInsets.only(top: 12.0),
      content: SingleChildScrollView(
        child: ListTileTheme(
          contentPadding: EdgeInsets.fromLTRB(14.0, 0.0, 24.0, 0.0),
          child: ListBody(
            children: widget.items.map(_buildItem).toList(),
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('CANCEL'),
          onPressed: _onCancelTap,
        ),
        FlatButton(
          child: Text('OK'),
          onPressed: _onSubmitTap,
        )
      ],
    );
  }

  Widget _buildItem(MultiSelectDialogItem<V> item) {
    final checked = _selectedValues.contains(item.value);
    return CheckboxListTile(
      value: checked,
      title: Text(item.label),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (checked) => _onItemCheckedChange(item.value, checked),
    );
  }
}


