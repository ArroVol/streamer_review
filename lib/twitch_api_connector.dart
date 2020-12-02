import 'package:streamer_review/streamer.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:streamer_review/helper/database_helper.dart' as DBHelper;
import 'helper/database_helper.dart';
import 'model/broadcaster_from_db.dart';

class TwitchAPIConnector {

  var data;
  var topStreamerInfo;
  Streamer topStreamer;
  BroadcasterFromDB broadcasterFromDB;
  var average_satisfaction_rating;
  var average_entertainment_rating;
  var average_interaction_rating;
  var average_skill_rating;
  String broadcaster_id;
  int user_id = 1;
  BroadcasterFromDB b;
  bool offline = false;

  Future<Streamer> getData(String selection) async {

    var url = 'https://api.twitch.tv/helix/search/channels?query='+ selection;

    http.Response response = await http.get(
        Uri.encodeFull(url),
        headers: {
          "Authorization": "Bearer 5e46v0tks21zqvnloyua8e76bcsui9",
          "Client-Id": "874uve10v0bcn3rmp2bq4cvz8fb5wj"
        });

    topStreamerInfo = json.decode(response.body);

    var temp;
    for(int i = 0; i < topStreamerInfo['data'].length; i++) {
      if (topStreamerInfo['data'][i]['display_name'].toString().toLowerCase() == selection.toLowerCase()) {
        temp = topStreamerInfo['data'][i];
        break;
      }
    }

    var topStreamerId = temp['id'];
    broadcaster_id = topStreamerId;

    url = "https://api.twitch.tv/helix/users?id=" + topStreamerId;

    http.Response channelInformation =
    await http.get(Uri.encodeFull(url), headers: {
      "Authorization": "Bearer 5e46v0tks21zqvnloyua8e76bcsui9",
      "Client-Id": "874uve10v0bcn3rmp2bq4cvz8fb5wj"
    });

    data = json.decode(channelInformation.body);

    var login = data['data'][0]['login'];
    var description = data['data'][0]['description'];
    var profilePictureUrl = data['data'][0]['profile_image_url'];
    var viewCount = data['data'][0]['view_count'];
    var streamer =
    new Streamer(login, description, profilePictureUrl, viewCount);
    DatabaseHelper2 d = DBHelper.DatabaseHelper2.instance;

    await d.selectBroadcaster(topStreamerId).then((value) {

      if (value.isNotEmpty) {
        b = new BroadcasterFromDB(
            value[0]['overall_satisfaction'],
            value[0]['overall_skill'],
            value[0]['overall_entertainment'],
            value[0]['overall_interactiveness']);
      }
    }, onError: (error) {
      print(error);
    });
    await d.updateBroadcaster(broadcaster_id, user_id, login);
    var url2 = "https://api.twitch.tv/helix/search/channels?query=" + login;
    http.Response channelInformation2 =
    await http.get(Uri.encodeFull(url2), headers: {
      "Authorization": "Bearer 5e46v0tks21zqvnloyua8e76bcsui9",
      "Client-Id": "874uve10v0bcn3rmp2bq4cvz8fb5wj"
    });

    data = json.decode(channelInformation2.body);
    offline = data['data'][0]['is_live'];
    return streamer;
  }


}
