import 'dart:convert';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:streamer_review/helper/database_helper.dart' as DBHelper;
import 'package:http/http.dart' as http;
import 'helper/database_helper.dart';
import 'package:profanity_filter/profanity_filter.dart';

class ReviewPage extends StatefulWidget {
  String broadcaster_id;

  ReviewPage(String broadcaster_id) {
    this.broadcaster_id = broadcaster_id;
  }

  @override
  StreamerReview createState() => new StreamerReview(broadcaster_id);
}

class StreamerReview extends State<ReviewPage> {
  TextEditingController reviewController = new TextEditingController();
  final filter = ProfanityFilter();
  final profanity = [
    '4r5e',
    '5h1t',
    '5hit',
    'a55',
    'anal',
    'anus',
    'ar5e',
    'arrse',
    'arse',
    'ass',
    'ass-fucker',
    'asses',
    'assfucker',
    'assfukka',
    'asshole',
    'assholes',
    'asswhole',
    'a_s_s',
    'b!tch',
    'b00bs',
    'b17ch',
    'b1tch',
    'ballbag',
    'balls',
    'ballsack',
    'bastard',
    'beastial',
    'beastiality',
    'bellend',
    'bestial',
    'bestiality',
    'bi+ch',
    'biatch',
    'bitch',
    'bitcher',
    'bitchers',
    'bitches',
    'bitchin',
    'bitching',
    'bloody',
    'blow job',
    'blowjob',
    'blowjobs',
    'boiolas',
    'bollock',
    'bollok',
    'boner',
    'boob',
    'boobs',
    'booobs',
    'boooobs',
    'booooobs',
    'booooooobs',
    'breasts',
    'buceta',
    'bugger',
    'bum',
    'bunny fucker',
    'butt',
    'butthole',
    'buttmunch',
    'buttplug',
    'c0ck',
    'c0cksucker',
    'carpet muncher',
    'cawk',
    'chink',
    'cipa',
    'cl1t',
    'clit',
    'clitoris',
    'clits',
    'cnut',
    'cock',
    'cock-sucker',
    'cockface',
    'cockhead',
    'cockmunch',
    'cockmuncher',
    'cocks',
    'cocksuck',
    'cocksucked',
    'cocksucker',
    'cocksucking',
    'cocksucks',
    'cocksuka',
    'cocksukka',
    'cok',
    'cokmuncher',
    'coksucka',
    'coon',
    'cox',
    'crap',
    'cum',
    'cummer',
    'cumming',
    'cums',
    'cumshot',
    'cunilingus',
    'cunillingus',
    'cunnilingus',
    'cunt',
    'cuntlick',
    'cuntlicker',
    'cuntlicking',
    'cunts',
    'cyalis',
    'cyberfuc',
    'cyberfuck',
    'cyberfucked',
    'cyberfucker',
    'cyberfuckers',
    'cyberfucking',
    'd1ck',
    'damn',
    'dick',
    'dickhead',
    'dildo',
    'dildos',
    'dink',
    'dinks',
    'dirsa',
    'dlck',
    'dog-fucker',
    'doggin',
    'dogging',
    'donkeyribber',
    'doosh',
    'duche',
    'dyke',
    'ejaculate',
    'ejaculated',
    'ejaculates',
    'ejaculating',
    'ejaculatings',
    'ejaculation',
    'ejakulate',
    'f u c k',
    'f u c k e r',
    'f4nny',
    'fag',
    'fagging',
    'faggitt',
    'faggot',
    'faggs',
    'fagot',
    'fagots',
    'fags',
    'fanny',
    'fannyflaps',
    'fannyfucker',
    'fanyy',
    'fark',
    'f4rk',
    'fatass',
    'fcuk',
    'fcuker',
    'fcuking',
    'feck',
    'fecker',
    'felching',
    'fellate',
    'fellatio',
    'fingerfuck',
    'fingerfucked',
    'fingerfucker',
    'fingerfuckers',
    'fingerfucking',
    'fingerfucks',
    'fistfuck',
    'fistfucked',
    'fistfucker',
    'fistfuckers',
    'fistfucking',
    'fistfuckings',
    'fistfucks',
    'flange',
    'fook',
    'fooker',
    'fuck',
    'fucka',
    'fucked',
    'fucker',
    'fuckers',
    'fuckhead',
    'fuckheads',
    'fuckin',
    'fucking',
    'fuckings',
    'fuckingshitmotherfucker',
    'fuckme',
    'fucks',
    'fuckwhit',
    'fuckwit',
    'fudge packer',
    'fudgepacker',
    'fuk',
    'fuker',
    'fukker',
    'fukkin',
    'fuks',
    'fukwhit',
    'fukwit',
    'fux',
    'fux0r',
    'f_u_c_k',
    'gangbang',
    'gangbanged',
    'gangbangs',
    'gaylord',
    'gaysex',
    'goatse',
    'God',
    'god-dam',
    'god-damned',
    'goddamn',
    'goddamned',
    'hardcoresex',
    'hell',
    'heshe',
    'hoar',
    'hoare',
    'hoer',
    'homo',
    'hore',
    'horniest',
    'horny',
    'hotsex',
    'jack-off',
    'jackoff',
    'jap',
    'jerk-off',
    'jism',
    'jiz',
    'jizm',
    'jizz',
    'kawk',
    'knob',
    'knobead',
    'knobed',
    'knobend',
    'knobhead',
    'knobjocky',
    'knobjokey',
    'kock',
    'kondum',
    'kondums',
    'kum',
    'kummer',
    'kumming',
    'kums',
    'kunilingus',
    'l3i+ch',
    'l3itch',
    'labia',
    'lmfao',
    'lust',
    'lusting',
    'm0f0',
    'm0fo',
    'm45terbate',
    'ma5terb8',
    'ma5terbate',
    'masochist',
    'master-bate',
    'masterb8',
    'masterbat*',
    'masterbat3',
    'masterbate',
    'masterbation',
    'masterbations',
    'masturbate',
    'mo-fo',
    'mof0',
    'mofo',
    'mothafuck',
    'mothafucka',
    'mothafuckas',
    'mothafuckaz',
    'mothafucked',
    'mothafucker',
    'mothafuckers',
    'mothafuckin',
    'mothafucking',
    'mothafuckings',
    'mothafucks',
    'mother fucker',
    'motherfuck',
    'motherfucked',
    'motherfucker',
    'motherfuckers',
    'motherfuckin',
    'motherfucking',
    'motherfuckings',
    'motherfuckka',
    'motherfucks',
    'muff',
    'mutha',
    'muthafecker',
    'muthafuckker',
    'muther',
    'mutherfucker',
    'n1gga',
    'n1gger',
    'nazi',
    'nigg3r',
    'nigg4h',
    'nigga',
    'niggah',
    'niggas',
    'niggaz',
    'nigger',
    'niggers',
    'nob',
    'nob jokey',
    'nobhead',
    'nobjocky',
    'nobjokey',
    'numbnuts',
    'nutsack',
    'orgasim',
    'orgasims',
    'orgasm',
    'orgasms',
    'p0rn',
    'pawn',
    'pecker',
    'penis',
    'penisfucker',
    'phonesex',
    'phuck',
    'phuk',
    'phuked',
    'phuking',
    'phukked',
    'phukking',
    'phuks',
    'phuq',
    'pigfucker',
    'pimpis',
    'piss',
    'pissed',
    'pisser',
    'pissers',
    'pisses',
    'pissflaps',
    'pissin',
    'pissing',
    'pissoff',
    'poop',
    'porn',
    'porno',
    'pornography',
    'pornos',
    'prick',
    'pricks',
    'pron',
    'pube',
    'pusse',
    'pussi',
    'pussies',
    'pussy',
    'pussys',
    'rectum',
    'retard',
    'rimjaw',
    'rimming',
    's hit',
    's.o.b.',
    'sadist',
    'schlong',
    'screwing',
    'scroat',
    'scrote',
    'scrotum',
    'semen',
    'sex',
    'sh!+',
    'sh!t',
    'sh1t',
    'shag',
    'shagger',
    'shaggin',
    'shagging',
    'shemale',
    'shi+',
    'shit',
    'shitdick',
    'shite',
    'shited',
    'shitey',
    'shitfuck',
    'shitfull',
    'shithead',
    'shiting',
    'shitings',
    'shits',
    'shitted',
    'shitter',
    'shitters',
    'shitting',
    'shittings',
    'shitty ',
    'skank',
    'slut',
    'sluts',
    'smegma',
    'smut',
    'snatch',
    'son-of-a-bitch',
    'spac',
    'spunk',
    's_h_i_t',
    't1tt1e5',
    't1tties',
    'teets',
    'teez',
    'testical',
    'testicle',
    'tit',
    'titfuck',
    'tits',
    'titt',
    'tittie5',
    'tittiefucker',
    'titties',
    'tittyfuck',
    'tittywank',
    'titwank',
    'tosser',
    'turd',
    'tw4t',
    'twat',
    'twathead',
    'twatty',
    'twunt',
    'twunter',
    'v14gra',
    'v1gra',
    'vagina',
    'viagra',
    'vulva',
    'w00se',
    'wang',
    'wank',
    'wanker',
    'wanky',
    'whoar',
    'whore',
    'willies',
    'willy',
    'xrated',
    'xxx'
  ];
  static const String username = 'Temp Username';
  double satisfaction_rating = 1;
  double entertainment_rating = 1;
  double interaction_rating = 1;
  double skill_rating = 1;
  List<String> tags = [];
  String dropdownValue = 'Gaming';
  List<int> tagKeys = [];

  // int broadcaster_id = 229729353;
  // int broadcaster_id = 48526626;
  // int broadcaster_id = 469790580;
  // int broadcaster_id = 37402112;
  // int broadcaster_id = 138117508;
  String broadcaster_id;

  int user_id = 1;

  int old_satisfaction_rating = 1;
  int old_entertainment_rating = 1;
  int old_interaction_rating = 1;
  int old_skill_rating = 1;

  var oldReview;

  List<MultiSelectDialogItem<int>> multiItem = List();

  final valuestopopulate = {
    1: 'Gaming',
    2: 'Food & Drinks',
    3: 'Sports & Fitness',
    4: 'Talk Shows & Podcasts',
    5: 'Just Chatting',
    6: 'Makers & Crafting',
    7: 'Tabletop RPGs',
    8: 'Science & Technologies',
    9: 'Music & Performing Arts',
    10: 'Beauty & Body Art',
    11: 'Travel & Outdoors',
    12: 'ASMR',
  };

  StreamerReview(String broadcaster_id) {
    this.broadcaster_id = broadcaster_id;
  }

  Future<void> submitReview(var context) async {
    if (satisfaction_rating == 0 ||
        entertainment_rating == 0 ||
        interaction_rating == 0 ||
        skill_rating == 0) {
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text('ERROR SUBMITTING REVIEW'),
        backgroundColor: Colors.red,
      ));
    } else if (filter.hasProfanity(reviewController.text) || profanity.contains(reviewController.text)) {
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text('YOUR COMMENT CANNOT CONTAIN PROFANITY'),
        backgroundColor: Colors.red,
      ));
    } else {
      DatabaseHelper2 d = DBHelper.DatabaseHelper2.instance;

      for (var tag in tags) {
        print(tag);
        await d.insertBroadcasterTag(broadcaster_id, tag);
      }

      var x = await d.selectAllBroadcasterTagsByBroadcaster(broadcaster_id);
      print(x);

      String url = "https://api.twitch.tv/helix/users?id=" + broadcaster_id;

      // print(url);

      http.Response channelInformation =
          await http.get(Uri.encodeFull(url), headers: {
        "Authorization": "Bearer 5e46v0tks21zqvnloyua8e76bcsui9",
        "Client-Id": "874uve10v0bcn3rmp2bq4cvz8fb5wj"
      });

      var data = json.decode(channelInformation.body);
      var login = data['data'][0]['login'];
      print(login);
      await d.insertReview(satisfaction_rating, entertainment_rating,
          interaction_rating, skill_rating, broadcaster_id, user_id, login);
      await d.updateBroadcaster(broadcaster_id, user_id, login);
      if (reviewController.text.isNotEmpty) {
        await d.insertTextReviews(reviewController.text,
            new DateTime.now().toString(), broadcaster_id, user_id);
      }

      var y = await d.selectTextReviews(broadcaster_id);
      print(y);
    }
  }

  void getOldReview() async {
    DatabaseHelper2 d = DBHelper.DatabaseHelper2.instance;
    oldReview = await d.selectReviews(broadcaster_id, user_id);
    // print(oldReview[0]);
    // print(oldReview[0]['satisfaction_rating'].runtimeType);
    old_satisfaction_rating = oldReview[0]['satisfaction_rating'];
    old_entertainment_rating = oldReview[0]['entertainment_rating'];
    old_interaction_rating = oldReview[0]['interactiveness_rating'];
    old_skill_rating = oldReview[0]['skill_rating'];
    setState(() {
      if (oldReview != null) {
        old_satisfaction_rating = oldReview[0]['satisfaction_rating'];
        satisfaction_rating = oldReview[0]['satisfaction_rating'].toDouble();
        old_entertainment_rating = oldReview[0]['entertainment_rating'];
        entertainment_rating = oldReview[0]['entertainment_rating'].toDouble();
        old_interaction_rating = oldReview[0]['interactiveness_rating'];
        interaction_rating = oldReview[0]['interactiveness_rating'].toDouble();
        old_skill_rating = oldReview[0]['skill_rating'];
        skill_rating = oldReview[0]['skill_rating'].toDouble();
      } else {
        old_satisfaction_rating = 1;
        satisfaction_rating = 1;
        old_entertainment_rating = 1;
        entertainment_rating = 1;
        old_interaction_rating = 1;
        interaction_rating = 1;
        old_skill_rating = 1;
        skill_rating = 1;
      }
    });
  }

  @override
  void initState() {
    getOldReview();
    super.initState();
  }

  void populateMultiselect() {
    for (int v in valuestopopulate.keys) {
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

  void getvaluefromkey(Set selection) {
    tags.clear();
    tagKeys.clear();
    if (selection != null) {
      for (int x in selection.toList()) {
        // print(valuestopopulate[x]);
        tags.add(valuestopopulate[x]);
        tagKeys.add(x);
        // print(tags);
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanDown: (_) {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width,
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Column(
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
                          height: MediaQuery.of(context).size.height * .9,
                          child: ListView(
                            scrollDirection: Axis.vertical,
                            children: <Widget>[
                              Center(
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
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 10.0),
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5.0,
                                                  ),
                                                  RaisedButton(
                                                    child:
                                                        Text("Show Categories"),
                                                    onPressed: () =>
                                                        _showMultiSelect(
                                                            context),
                                                  ),
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
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 2.0),
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5.0,
                                                  ),
                                                  RatingBar.builder(
                                                    initialRating:
                                                        old_satisfaction_rating
                                                            .toDouble(),
                                                    itemCount: 5,
                                                    itemPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 4.0),
                                                    itemBuilder:
                                                        (context, index) {
                                                      switch (index) {
                                                        case 0:
                                                          return Icon(
                                                            Icons
                                                                .sentiment_very_dissatisfied,
                                                            color: Colors.red,
                                                          );
                                                        case 1:
                                                          return Icon(
                                                            Icons
                                                                .sentiment_dissatisfied,
                                                            color: Colors
                                                                .yellow[900],
                                                          );
                                                        case 2:
                                                          return Icon(
                                                            Icons
                                                                .sentiment_neutral,
                                                            color: Colors
                                                                .amber[700],
                                                          );
                                                        case 3:
                                                          return Icon(
                                                            Icons
                                                                .sentiment_satisfied,
                                                            color: Colors
                                                                    .limeAccent[
                                                                700],
                                                          );
                                                        case 4:
                                                          return Icon(
                                                            Icons
                                                                .sentiment_very_satisfied,
                                                            color: Colors
                                                                    .greenAccent[
                                                                700],
                                                          );
                                                      }
                                                    },
                                                    onRatingUpdate: (rating) {
                                                      satisfaction_rating =
                                                          rating;
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
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 2.0),
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5.0,
                                                  ),
                                                  RatingBar.builder(
                                                    initialRating:
                                                        old_entertainment_rating
                                                            .toDouble(),
                                                    minRating: 1,
                                                    direction: Axis.horizontal,
                                                    allowHalfRating: false,
                                                    itemCount: 5,
                                                    itemPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 4.0),
                                                    itemBuilder: (context, _) =>
                                                        Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                    ),
                                                    onRatingUpdate: (rating) {
                                                      entertainment_rating =
                                                          rating;
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
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 2.0),
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5.0,
                                                  ),
                                                  RatingBar.builder(
                                                    initialRating:
                                                        old_interaction_rating
                                                            .toDouble(),
                                                    minRating: 1,
                                                    direction: Axis.horizontal,
                                                    allowHalfRating: false,
                                                    itemCount: 5,
                                                    itemPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 4.0),
                                                    itemBuilder: (context, _) =>
                                                        Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                    ),
                                                    onRatingUpdate: (rating) {
                                                      interaction_rating =
                                                          rating;
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
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 2.0),
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5.0,
                                                  ),
                                                  RatingBar.builder(
                                                    initialRating:
                                                        old_skill_rating
                                                            .toDouble(),
                                                    minRating: 1,
                                                    direction: Axis.horizontal,
                                                    allowHalfRating: false,
                                                    itemCount: 5,
                                                    itemPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 4.0),
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
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 2.0),
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
                                                    "Additional Comments",
                                                    style: TextStyle(
                                                      color: Colors.deepPurple,
                                                      fontSize: 22.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5.0,
                                                  ),
                                                  TextField(
                                                    controller:
                                                        reviewController,
                                                    maxLines: 8,
                                                    decoration: InputDecoration
                                                        .collapsed(
                                                            hintText:
                                                                "Enter your text here"),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Card(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 2.0),
                                      clipBehavior: Clip.antiAlias,
                                      color: Colors.white,
                                      elevation: 5.0,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 15.0),
                                        child: new ButtonBar(
                                          alignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            RaisedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            80.0)),
                                                elevation: 0.0,
                                                padding: EdgeInsets.all(0.0),
                                                child: Ink(
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                        begin: Alignment
                                                            .centerRight,
                                                        end: Alignment
                                                            .centerLeft,
                                                        colors: [
                                                          Colors
                                                              .deepPurpleAccent,
                                                          Colors.deepPurple[700]
                                                        ]),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30.0),
                                                  ),
                                                  child: Container(
                                                    constraints: BoxConstraints(
                                                        maxWidth: 125.0,
                                                        minHeight: 50.0),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "BACK",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 22.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                )),
                                            RaisedButton(
                                                onPressed: () {
                                                  submitReview(context);
                                                  Navigator.pop(context);
                                                },
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            80.0)),
                                                elevation: 0.0,
                                                padding: EdgeInsets.all(0.0),
                                                child: Ink(
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                        begin: Alignment
                                                            .centerRight,
                                                        end: Alignment
                                                            .centerLeft,
                                                        colors: [
                                                          Colors
                                                              .deepPurpleAccent,
                                                          Colors.deepPurple[700]
                                                        ]),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30.0),
                                                  ),
                                                  child: Container(
                                                    constraints: BoxConstraints(
                                                        maxWidth: 125.0,
                                                        minHeight: 50.0),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "SUBMIT",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 22.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  // CONTENT HERE
                ],
              ),
            ),
          ),
        ),
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
  MultiSelectDialog({Key key, this.items, this.initialSelectedValues})
      : super(key: key);

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
