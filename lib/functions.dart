import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studio_flutter/profilepage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';
import 'package:intl/intl.dart';
import 'main.dart';

String apiUrl = "https://vmg-studio.hu/api/api.php";
String userId = "";
String apiKey = "";
bool isloggedin = false;
String loginmessage = '';
String name = '';
bool isadmin = false;
List<Users> apiUsers;
bool isscanning = true;

String formatDate(DateTime date) => new DateFormat("yyyy-MM-dd").format(date);

Future<ValidateData> validate() async {
  final response = await http.get(apiUrl +
      "?action=validateUserCredentials&key=" +
      apiKey +
      "&uid=" +
      userId);
  if (response.statusCode == 200) {
    ValidateData validateData =
        ValidateData.fromJson(json.decode(response.body));
    if (validateData.status) {
      name = validateData.name;

      Future<List<Events>> data = fetcheventdata();
      data.then((value) {
        if (!kIsWeb) {
          firebaseMessaging.subscribeToTopic(userId);
          for (var item in value) {
            if (item.isSubscribed) {
              firebaseMessaging
                  .subscribeToTopic('event-' + item.dbid.toString());
            }
          }
        }
      });
      if (validateData.admin == 1) {
        isadmin = true;
      } else {
        isadmin = false;
      }
      final resp =
          await http.get(apiUrl + "?action=getLatestVersion&key=" + apiKey);
      if (resp.statusCode == 200) {
        VersionData versionData = VersionData.fromJson(json.decode(resp.body));
        if (versionData.version != version) {
          launch(versionData.downloadlink);
        }
      }
      return validateData;
    } else {
      throw Exception('Failed to validate your credentials');
    }
  } else {
    throw Exception('Failed to load data');
  }
}

class VersionData {
  bool status;
  String version;
  String downloadlink;

  VersionData({this.status, this.version, this.downloadlink});

  VersionData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    version = json['version'];
    downloadlink = json['downloadlink'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['version'] = this.version;
    data['downloadlink'] = this.downloadlink;
    return data;
  }
}

class ValidateData {
  final bool status;
  final int admin;
  final String message;
  final String name;

  ValidateData({this.status, this.admin, this.message, this.name});

  factory ValidateData.fromJson(Map<String, dynamic> json) {
    return ValidateData(
        status: json['status'],
        message: json['message'],
        admin: json['admin'],
        name: json['name']);
  }
}

Future<LoginData> auth(String uid, String pass) async {
  //print(
  //  apiUrl + "?action=requestUIDvalidation&uid=" + uid + "&password=" + pass);

  final response = await http.get(
      apiUrl + "?action=requestUIDvalidation&uid=" + uid + "&password=" + pass);
  if (response.statusCode == 200) {
    //print(response.body);
    LoginData logindata = LoginData.fromJson(json.decode(response.body));
    if (logindata.status) {
      userId = logindata.userId.toString();
      addStringToSF("userid", userId);
      apiKey = logindata.apiKey;
      addStringToSF("apikey", apiKey);
      isloggedin = logindata.status;
      loginmessage = logindata.message;
      return logindata;
    } else {
      throw Exception('Failed to login');
    }
  } else {
    throw Exception('Failed to load data');
  }
}

class LoginData {
  bool status;
  String message;
  String apiKey;
  int userId;

  LoginData({this.status, this.message, this.apiKey, this.userId});

  LoginData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    apiKey = json['api_key'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['api_key'] = this.apiKey;
    data['user_id'] = this.userId;
    return data;
  }
}

class initValidate {
  String apikey;
  String userid;
}

Future<ScanData> scan(String scanresult) async {
  if (isscanning) {
    isscanning = false;
    Vibration.vibrate(duration: 100);
    final response = await http.get(
        apiUrl + "?action=selectItem&key=" + apiKey + "&itemID=" + scanresult);
    if (response.statusCode == 200) {
      Vibration.vibrate(duration: 100);
      ScanData scanData = ScanData.fromJson(json.decode(response.body));
      isscanning = true;
      return scanData;
    } else {
      isscanning = true;
      throw Exception('Failed to load data');
    }
  }
}

Future<ScanData> dialled(String dialleditem) async {
  final response = await http.get(
      apiUrl + "?action=selectItem&key=" + apiKey + "&itemID=" + dialleditem);
  if (response.statusCode == 200) {
    ScanData scanData = ScanData.fromJson(json.decode(response.body));
    return scanData;
  } else {
    throw Exception('Failed to load data');
  }
}

class ScanData {
  final bool status;

  final String message;

  ScanData({this.status, this.message});

  factory ScanData.fromJson(Map<String, dynamic> json) {
    return ScanData(status: json['status'], message: json['message']);
  }
}

Future<List<ApiItem>> myitems() async {
  final response =
      await http.get(apiUrl + "?key=" + apiKey + "&action=getItemList");
  if (response.statusCode == 200) {
    MyItemsData myItemsData = MyItemsData.fromJson(json.decode(response.body));
    return myItemsData.myitems;
  } else {
    throw Exception('Failed to load data');
  }
}

class MyItemsData {
  final bool status;
  final List<ApiItem> myitems;
  final String message;

  MyItemsData({this.status, this.myitems, this.message});

  factory MyItemsData.fromJson(Map<String, dynamic> json) {
    var list = json['items'] as List;
    List<ApiItem> itemlist = new List();
    itemlist.add(ApiItem(name: "Nincsenek tárgyak", dept: "", datetime: ""));
    if (list != null) {
      itemlist = list.map((e) => ApiItem.fromJson(e)).toList();
    }

    return MyItemsData(
        status: json['status'], myitems: itemlist, message: json['message']);
  }
}

class ApiItem {
  final String dbid;
  final String name;
  final String dept;
  final String comment;
  final String datetime;
  final String username;
  final bool pending;

  ApiItem(
      {this.dbid,
      this.name,
      this.dept,
      this.comment,
      this.datetime,
      this.username,
      this.pending});

  factory ApiItem.fromJson(Map<String, dynamic> json) {
    return ApiItem(
        dbid: json['dbid'].toString(),
        name: json['name'],
        dept: json['dept'],
        comment: json['comment'],
        datetime: json['datetime'],
        username: json['username'],
        pending: json['pending']);
  }
}

addStringToSF(String key, String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}

Future<DeleteItemData> deleteitemfuture(String dbid) async {
  final response = await http
      .get(apiUrl + "?key=" + apiKey + "&action=cancelItem&itemID=" + dbid);
  if (response.statusCode == 200) {
    DeleteItemData deleteItemData =
        DeleteItemData.fromJson(json.decode(response.body));
    return deleteItemData;
  } else {
    throw Exception('Nem sikerült kapcsolatot létesíteni a szerverrel');
  }
}

class DeleteItemData {
  bool status;
  String message;

  DeleteItemData({this.status, this.message});

  DeleteItemData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

Future<List<ApiItem>> fetchhistory() async {
  final response =
      await http.get(apiUrl + "?key=" + apiKey + "&action=getItemHistory");
  if (response.statusCode == 200) {
    MyItemsData myItemsData = MyItemsData.fromJson(json.decode(response.body));
    return myItemsData.myitems;
  } else {
    throw Exception('Failed to load data');
  }
}

class FetchEventsData {
  bool status;
  List<Events> events;
  List<SchoolYears> schoolYears;

  FetchEventsData({this.status, this.events, this.schoolYears});

  FetchEventsData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['events'] != null) {
      events = new List<Events>();
      json['events'].forEach((v) {
        events.add(new Events.fromJson(v));
      });
    }
    if (json['schoolYears'] != null) {
      schoolYears = new List<SchoolYears>();
      json['schoolYears'].forEach((v) {
        schoolYears.add(new SchoolYears.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.events != null) {
      data['events'] = this.events.map((v) => v.toJson()).toList();
    }
    if (this.schoolYears != null) {
      data['schoolYears'] = this.schoolYears.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Events {
  int dbid;
  String name;
  String details;
  List<String> attachments;
  String date;
  int maxSubs;
  int currentSubs;
  bool subscribing = false;
  bool isSubscribed;
  List<Subscribers> subscribers;
  String schoolYear;

  Events(
      {this.dbid,
      this.name,
      this.details,
      this.attachments,
      this.date,
      this.maxSubs,
      this.currentSubs,
      this.isSubscribed,
      this.subscribers,
      this.schoolYear});

  Events.fromJson(Map<String, dynamic> json) {
    dbid = json['dbid'];
    name = json['name'];
    details = json['details'];
    attachments = json['attachments'].cast<String>();
    date = json['date'];
    maxSubs = json['max_subs'];
    currentSubs = json['current_subs'];
    isSubscribed = json['is_subscribed'];
    if (json['subscribers'] != null) {
      subscribers = new List<Subscribers>();
      json['subscribers'].forEach((v) {
        subscribers.add(new Subscribers.fromJson(v));
      });
    }
    schoolYear = json['school_year'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dbid'] = this.dbid;
    data['name'] = this.name;
    data['details'] = this.details;
    data['attachments'] = this.attachments;
    data['date'] = this.date;
    data['max_subs'] = this.maxSubs;
    data['current_subs'] = this.currentSubs;
    data['is_subscribed'] = this.isSubscribed;
    if (this.subscribers != null) {
      data['subscribers'] = this.subscribers.map((v) => v.toJson()).toList();
    }
    data['school_year'] = this.schoolYear;
    return data;
  }
}

class Subscribers {
  int dbid;
  String name;

  Subscribers({this.dbid, this.name});

  Subscribers.fromJson(Map<String, dynamic> json) {
    dbid = json['dbid'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dbid'] = this.dbid;
    data['name'] = this.name;
    return data;
  }
}

class SchoolYears {
  String label;
  String slug;

  SchoolYears({this.label, this.slug});

  SchoolYears.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['slug'] = this.slug;
    return data;
  }
}

Future<List<Events>> fetcheventdata() async {
  Future<List<Users>> users = fetchuserlist();
  await users.then((value) {
    apiUsers = value;
  });
  final response = await http.get(apiUrl +
      "?key=" +
      apiKey +
      "&action=getEventList&SchoolYear=" +
      schoolyears[selectedyear].substring(0, 4));
  if (response.statusCode == 200) {
    FetchEventsData fetchEventsData =
        FetchEventsData.fromJson(json.decode(response.body));
    return fetchEventsData.events;
  } else {
    throw Exception('Failed to load data');
  }
}
Future<List<SchoolYears>> fetchyeardata() async {
  final response = await http.get(apiUrl +
      "?key=" +
      apiKey +
      "&action=getEventList&SchoolYear=" +
      schoolyears[selectedyear].substring(0, 4));
  if (response.statusCode == 200) {
    FetchEventsData fetchEventsData =
        FetchEventsData.fromJson(json.decode(response.body));
    return fetchEventsData.schoolYears;
  } else {
    throw Exception('Failed to load data');
  }
}

class SubscribeData {
  bool status;
  String message;
  bool subscribed;

  SubscribeData({this.status, this.message, this.subscribed});

  SubscribeData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    subscribed = json['subscribed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['subscribed'] = this.subscribed;
    return data;
  }
}

Future<SubscribeData> subscribe(int eventid) async {
  final response = await http.get(apiUrl +
      "?key=" +
      apiKey +
      "&action=subscribeEvent&eventID=" +
      eventid.toString() +
      "&silent=" +
      isadmin.toString());
  if (response.statusCode == 200) {
    SubscribeData subscribeData =
        SubscribeData.fromJson(json.decode(response.body));
    if (subscribeData.subscribed && !kIsWeb) {
      firebaseMessaging.subscribeToTopic('event-' + eventid.toString());
    } else if (!kIsWeb) {
      firebaseMessaging.unsubscribeFromTopic('event-' + eventid.toString());
    }
    return subscribeData;
  } else {
    throw Exception('Failed to load data');
  }
}

class UsersData {
  bool status;
  List<Users> users;

  UsersData({this.status, this.users});

  UsersData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['users'] != null) {
      users = new List<Users>();
      json['users'].forEach((v) {
        users.add(new Users.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.users != null) {
      data['users'] = this.users.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Users {
  int dbid;
  String name;
  String group;
  int subs;
  bool subbed;
  String tel;
  String email;
  int puszipontok;

  Users(
      {this.dbid,
      this.name,
      this.group,
      this.subbed,
      this.subs,
      this.email,
      this.tel,
      this.puszipontok});

  Users.fromJson(Map<String, dynamic> json) {
    dbid = json['dbid'];
    name = json['name'];
    group = json['group'];
    subs = json['subs'];
    subbed = false;
    email = json['email'];
    tel = json['tel'];
    puszipontok = json['puszipontok'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dbid'] = this.dbid;
    data['name'] = this.name;
    data['group'] = this.group;
    data['subs'] = this.subs;
    data['puszipontok'] = this.puszipontok;
    return data;
  }
}

Future<List<Users>> fetchuserlist() async {
  final response =
      await http.get(apiUrl + "?key=" + apiKey + "&action=getUserList");
  if (response.statusCode == 200) {
    UsersData usersData = UsersData.fromJson(json.decode(response.body));
    return usersData.users;
  } else {
    throw Exception('Failed to load data');
  }
}

class ForceSubData {
  bool status;
  String message;
  bool subscribed;

  ForceSubData({this.status, this.message, this.subscribed});

  ForceSubData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    subscribed = json['subscribed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['subscribed'] = this.subscribed;
    return data;
  }
}

Future<ForceSubData> forcesubscription(int eventid, int userid) async {
  final response = await http.get(apiUrl +
      "?key=" +
      apiKey +
      "&action=forceEventSubscription&eventID=" +
      eventid.toString() +
      "&uid=" +
      userid.toString());
  if (response.statusCode == 200) {
    ForceSubData forcesubData =
        ForceSubData.fromJson(json.decode(response.body));
    return forcesubData;
  } else {
    throw Exception('Failed to load data');
  }
}

Future<DeleteItemData> addevent(
    String name, String subs, String details, DateTime date) async {
  final response = await http.get(apiUrl +
      '?key=' +
      apiKey +
      '&action=addEvent&eventName=' +
      name +
      "&eventDetails=" +
      details +
      "&eventDate=" +
      formatDate(date) +
      '&eventMaxSubscribers=' +
      subs);
  if (response.statusCode == 200) {
    DeleteItemData data = DeleteItemData.fromJson(json.decode(response.body));
    return data;
  }
}

Future<DeleteItemData> updateevent(int eventid, String name, String subs,
    String details, DateTime date) async {
  final response = await http.get(apiUrl +
      "?key=" +
      apiKey +
      "&action=updateEvent&eventID=" +
      eventid.toString() +
      "&eventName=" +
      name +
      "&eventDetails=" +
      details +
      "&eventDate=" +
      formatDate(date) +
      "&eventMaxSubscribers=" +
      subs);
  if (response.statusCode == 200) {
    DeleteItemData data = DeleteItemData.fromJson(json.decode(response.body));
    return data;
  }
}

class UserDetailsData {
  bool status;
  String name;
  String email;
  String tel;
  String group;
  List<String> events;

  UserDetailsData(
      {this.status, this.name, this.email, this.tel, this.group, this.events});

  UserDetailsData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    name = json['name'];
    email = json['email'];
    tel = json['tel'];
    group = json['group'];
    events = json['events'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['name'] = this.name;
    data['email'] = this.email;
    data['tel'] = this.tel;
    data['group'] = this.group;
    data['events'] = this.events;
    return data;
  }
}

Future<UserDetailsData> fetchuserdetails(int dbid) async {
  final response = await http.get(apiUrl +
      "?key=" +
      apiKey +
      "&action=getProfileDetails&uid=" +
      dbid.toString());
  if (response.statusCode == 200) {
    UserDetailsData userDetailsData =
        UserDetailsData.fromJson(json.decode(response.body));
    return userDetailsData;
  }
}

Future<DeleteItemData> updateuserdetails() async {
  final response = await http.get(apiUrl +
      "?key=" +
      apiKey +
      "&action=updateProfile&uid=" +
      userId +
      "&email=" +
      emailctrl.text +
      "&tel=" +
      telctrl.text);
  if (response.statusCode == 200) {
    DeleteItemData data = DeleteItemData.fromJson(json.decode(response.body));
    return data;
  }
}

Future<DeleteItemData> sendnewnoti(String notititle, String msg) async {
  final response = await http.get(apiUrl +
      "?key=" +
      apiKey +
      "&action=sendPushNotification&title=" +
      notititle +
      " &msg=" +
      msg);
  if (response.statusCode == 200) {
    DeleteItemData data = DeleteItemData.fromJson(json.decode(response.body));
    return data;
  }
}

Future<HomeData> fetchhomedata() async {
  final response =
      await http.get(apiUrl + "?key=" + apiKey + "&action=getMainPageDetails");
  if (response.statusCode == 200) {
    HomeData data = HomeData.fromJson(json.decode(response.body));
    return data;
  }
}

class HomeData {
  String name;
  String group;
  int subs;
  Events event;
  String title;
  String message;
  List<Posts> posts;

  HomeData(
      {this.name, this.group, this.subs, this.event, this.title, this.message});

  HomeData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    group = json['group'];
    subs = json['subs'];
    event = json['event'] != null ? new Events.fromJson(json['event']) : null;
    title = json['title'];
    message = json['message'];
    if (json['posts'] != null) {
      posts = new List<Posts>();
      json['posts'].forEach((v) {
        posts.add(new Posts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['group'] = this.group;
    data['subs'] = this.subs;
    if (this.event != null) {
      data['event'] = this.event.toJson();
    }
    data['title'] = this.title;
    data['message'] = this.message;
    return data;
  }
}

class Posts {
  String topic;
  String topicId;
  String title;
  String message;

  Posts({this.topic, this.topicId, this.title, this.message});

  Posts.fromJson(Map<String, dynamic> json) {
    topic = json['topic'];
    topicId = json['topic_id'];
    title = json['title'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['topic'] = this.topic;
    data['topic_id'] = this.topicId;
    data['title'] = this.title;
    data['message'] = this.message;
    return data;
  }
}

Future<DeleteItemData> changepassword(String oldpass, String newpass) async {
  final response = await http.get(apiUrl +
      "?action=chpassword&key=" +
      apiKey +
      "&uid=" +
      userId +
      "&oldpass=" +
      oldpass +
      "&newpass=" +
      newpass);
  if (response.statusCode == 200) {
    DeleteItemData data = DeleteItemData.fromJson(json.decode(response.body));
    return data;
  }
}

Future<DeleteItemData> PuszipontAdas(int id) async {
  final response = await http.post(apiUrl, body: {
    'apikey': apiKey,
    'action': 'puszipontAdas',
    'user_id': id.toString()
  });
  if (response.statusCode == 200) {
    DeleteItemData data = DeleteItemData.fromJson(json.decode(response.body));
    return data;
  }
}

Future<DeleteItemData> PuszipontElvetel(int id) async {
  final response = await http.post(apiUrl, body: {
    'apikey': apiKey,
    'action': 'puszipontElvetel',
    'user_id': id.toString()
  });
  if (response.statusCode == 200) {
    DeleteItemData data = DeleteItemData.fromJson(json.decode(response.body));
    return data;
  }
}

class CommentData {
  bool status;
  List<Comments> comments;

  CommentData({this.status, this.comments});

  CommentData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['comments'] != null) {
      comments = new List<Comments>();
      json['comments'].forEach((v) {
        comments.add(new Comments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.comments != null) {
      data['comments'] = this.comments.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Comments {
  int commentId;
  int userId;
  String userName;
  String commentDate;
  String commentBody;

  Comments(
      {this.commentId,
      this.userId,
      this.userName,
      this.commentDate,
      this.commentBody});

  Comments.fromJson(Map<String, dynamic> json) {
    commentId = json['comment_id'];
    userId = json['user_id'];
    userName = json['user_name'];
    commentDate = json['comment_date'];
    commentBody = json['comment_body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comment_id'] = this.commentId;
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['comment_date'] = this.commentDate;
    data['comment_body'] = this.commentBody;
    return data;
  }
}

Future<CommentData> getcomments(String topicid, String topic) async {
  final response = await http.get(apiUrl +
      "?action=getComments&key=" +
      apiKey +
      "&topic=" +
      topic +
      "&topic_id=" +
      topicid);
  if (response.statusCode == 200) {
    CommentData data = CommentData.fromJson(json.decode(response.body));
    return data;
  }
}

Future<DeleteItemData> newComment(
    String topic, String topicid, String body) async {
  final response = await http.post(apiUrl, body: {
    'apikey': apiKey,
    'action': 'newcomment',
    'topic': topic,
    'topic_id': topicid,
    'body': body,
  });
  if (response.statusCode == 200) {
    DeleteItemData data = DeleteItemData.fromJson(json.decode(response.body));
    return data;
  }
}

Future<DeleteItemData> deleteComment(
  String commentId,
) async {
  final response = await http.get(
      apiUrl + "?action=deleteComment&key=" + apiKey + "&commentid=" + commentId);
  if (response.statusCode == 200) {
    DeleteItemData data = DeleteItemData.fromJson(json.decode(response.body));
    return data;
  }
}
