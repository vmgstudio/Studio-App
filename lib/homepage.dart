import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'main.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget initState() {
    super.initState();
    UserData.context = context;
  }

  @override
  Widget build(BuildContext context) {
    if (!UserData.isloggedin) {
      return Scaffold(
        appBar: MobileAppBar("VMG Stúdió"),
        drawer: NavDrawer(),
        body: Column(
          children: [
            TopBar(),
            Flexible(child: Center(child: Text('Kilépve'))),
          ],
        ),
      );
    } else {
      return LGHomePage();
    }
  }
}

class LGHomePage extends StatefulWidget {
  @override
  _LGHomePageState createState() => _LGHomePageState();
}

class _LGHomePageState extends State<LGHomePage> {
  HomeData data = HomeData();

  @override
  Widget initState() {
    updatedata();
  }

  Future<bool> updatedata({bool isdetailed = false}) {
    Future<bool> fetch = data.fetch();
    fetch.then((value) {
      if (value)
        setState(() {
          data.isloading = false;
          data.event.isdetailed = isdetailed;
          return true;
        });
      else
        Navigator.popAndPushNamed(context, "/");
      return false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MobileAppBar("VMG Stúdió"),
      drawer: NavDrawer(),
      body: Column(
        children: [
          TopBar(),
          Flexible(
            child: UserData.ismobile()
                ? Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Card(
                          elevation: 2,
                          clipBehavior: Clip.hardEdge,
                          color: Consts.cardcolor,
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.7,
                            width: MediaQuery.of(context).size.width / 4,
                            child: AnimatedSwitcher(
                              duration: Duration(milliseconds: 100),
                              child: data.isloading
                                  ? Center(child: CircularProgressIndicator())
                                  : AnimatedSwitcher(
                                      switchInCurve: Curves.easeIn,
                                      switchOutCurve: Curves.easeOut,
                                      transitionBuilder: (Widget child,
                                          Animation<double> animation) {
                                        final inAnimation = Tween<Offset>(
                                                begin: Offset(1.0, 0.0),
                                                end: Offset(0.0, 0.0))
                                            .animate(animation);
                                        final outAnimation = Tween<Offset>(
                                                begin: Offset(-1.0, 0.0),
                                                end: Offset(0.0, 0.0))
                                            .animate(animation);

                                        if (child.key == ValueKey(1)) {
                                          return ClipRect(
                                            child: SlideTransition(
                                              position: inAnimation,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: child,
                                              ),
                                            ),
                                          );
                                        } else {
                                          return ClipRect(
                                            child: SlideTransition(
                                              position: outAnimation,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: child,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      duration: Duration(milliseconds: 200),
                                      child: data.event.isdetailed
                                          ? Padding(
                                              key: ValueKey(1),
                                              padding: const EdgeInsets.all(8),
                                              child: Center(
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 8),
                                                          child: Text(
                                                            "Vállalók",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline6,
                                                          ),
                                                        ),
                                                        IconButton(
                                                          icon: Icon(
                                                            Icons.close,
                                                            color: Colors.white,
                                                          ),
                                                          hoverColor:
                                                              Colors.grey[800],
                                                          splashRadius: 30,
                                                          onPressed: () {
                                                            setState(() {
                                                              data.event
                                                                      .isdetailed =
                                                                  false;
                                                            });
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                    Expanded(
                                                      child: ListView.builder(
                                                        itemCount: data.event
                                                            .subscribers.length,
                                                        itemBuilder:
                                                            (context, i) {
                                                          return ListTile(
                                                            title: Text(data
                                                                .event
                                                                .subscribers[i]
                                                                .name),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : Padding(
                                              key: ValueKey(2),
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    data.event.name + '\n',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline6,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      data.event.details,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText2,
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      OutlineButton(
                                                        onPressed: () {
                                                          data.event
                                                              .subscribe()
                                                              .then((value) {
                                                            setState(() {});
                                                            updatedata();
                                                          });
                                                        },
                                                        hoverColor:
                                                            Colors.grey[800],
                                                        borderSide: BorderSide(
                                                            color: Colors.grey),
                                                        child: AnimatedSwitcher(
                                                          duration: Duration(
                                                              milliseconds:
                                                                  200),
                                                          child: Text(
                                                            data.event
                                                                    .isSubscribed
                                                                ? "LEIRATKOZÁS"
                                                                : "FELIRATKOZÁS",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .button,
                                                          ),
                                                        ),
                                                      ),
                                                      FlatButton(
                                                        hoverColor:
                                                            Colors.grey[800],
                                                        onPressed: () {
                                                          setState(
                                                            () {
                                                              data.event
                                                                      .isdetailed =
                                                                  true;
                                                            },
                                                          );
                                                        },
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              "VÁLLALÓK",
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .button,
                                                            ),
                                                            Icon(
                                                              Icons
                                                                  .navigate_next,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                    ),
                            ),
                          ),
                        ),
                        Card(
                          elevation: 2,
                          clipBehavior: Clip.hardEdge,
                          color: const Color(0xff212121),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.7,
                            width: MediaQuery.of(context).size.width / 4,
                            child: AnimatedSwitcher(
                              duration: Duration(milliseconds: 100),
                              child: data.isloading
                                  ? Center(child: CircularProgressIndicator())
                                  : AnimatedSwitcher(
                                      switchInCurve: Curves.easeIn,
                                      switchOutCurve: Curves.easeOut,
                                      transitionBuilder: (Widget child,
                                          Animation<double> animation) {
                                        final inAnimation = Tween<Offset>(
                                                begin: Offset(0.0, 1.0),
                                                end: Offset(0.0, 0.0))
                                            .animate(animation);
                                        final outAnimation = Tween<Offset>(
                                                begin: Offset(0.0, -1.0),
                                                end: Offset(0.0, 0.0))
                                            .animate(animation);

                                        if (child.key == ValueKey(1)) {
                                          return ClipRect(
                                            child: SlideTransition(
                                              position: inAnimation,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: child,
                                              ),
                                            ),
                                          );
                                        } else {
                                          return ClipRect(
                                            child: SlideTransition(
                                              position: outAnimation,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: child,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      duration: Duration(milliseconds: 200),
                                      child: data.isinconv
                                          ? Padding(
                                              key: ValueKey(1),
                                              padding: const EdgeInsets.all(8),
                                              child: AnimatedSwitcher(
                                                switchInCurve: Curves.easeIn,
                                                switchOutCurve: Curves.easeOut,
                                                transitionBuilder:
                                                    (Widget child,
                                                        Animation<double>
                                                            animation) {
                                                  final inAnimation = Tween<
                                                              Offset>(
                                                          begin:
                                                              Offset(1.0, 0.0),
                                                          end: Offset(0.0, 0.0))
                                                      .animate(animation);
                                                  final outAnimation = Tween<
                                                              Offset>(
                                                          begin:
                                                              Offset(-1.0, 0.0),
                                                          end: Offset(0.0, 0.0))
                                                      .animate(animation);

                                                  if (data.isleft) {
                                                    if (child.key ==
                                                        ValueKey(
                                                            data.currconv)) {
                                                      return ClipRect(
                                                        child: SlideTransition(
                                                          position:
                                                              outAnimation,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: child,
                                                          ),
                                                        ),
                                                      );
                                                    } else {
                                                      return ClipRect(
                                                        child: SlideTransition(
                                                          position: inAnimation,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: child,
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  } else {
                                                    if (child.key ==
                                                        ValueKey(
                                                            data.currconv)) {
                                                      return ClipRect(
                                                        child: SlideTransition(
                                                          position: inAnimation,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: child,
                                                          ),
                                                        ),
                                                      );
                                                    } else {
                                                      return ClipRect(
                                                        child: SlideTransition(
                                                          position:
                                                              outAnimation,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: child,
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  }
                                                },
                                                duration:
                                                    Duration(milliseconds: 200),
                                                child: Center(
                                                  key: ValueKey(data.currconv),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 8),
                                                            child: Text(
                                                              data
                                                                  .posts[data
                                                                      .currconv]
                                                                  .title
                                                                  .substring(
                                                                      22),
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headline6,
                                                            ),
                                                          ),
                                                          IconButton(
                                                            icon: Icon(
                                                              Icons.close,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            hoverColor: Colors
                                                                .grey[800],
                                                            splashRadius: 30,
                                                            onPressed: () {
                                                              setState(() {
                                                                data.commentsloading =
                                                                    true;
                                                                data.isinconv =
                                                                    false;
                                                              });
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                      Container(
                                                        height: 16,
                                                      ),
                                                      Text(
                                                        data
                                                            .posts[
                                                                data.currconv]
                                                            .message,
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText2,
                                                      ),
                                                      CommentsWidget(
                                                          post: data.posts[
                                                              data.currconv]),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          IconButton(
                                                            icon: Icon(
                                                              Icons
                                                                  .navigate_before,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            hoverColor: Colors
                                                                .grey[800],
                                                            splashRadius: 30,
                                                            onPressed: () {
                                                              data.commentsloading =
                                                                  true;
                                                              setState(() {
                                                                data.isleft =
                                                                    true;
                                                                if (data.currconv !=
                                                                    0) {
                                                                  data.currconv--;
                                                                }
                                                              });
                                                            },
                                                          ),
                                                          IconButton(
                                                            icon: Icon(
                                                              Icons
                                                                  .navigate_next,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            hoverColor: Colors
                                                                .grey[800],
                                                            splashRadius: 30,
                                                            onPressed: () {
                                                              data.commentsloading =
                                                                  true;
                                                              setState(() {
                                                                data.isleft =
                                                                    false;
                                                                if (data.currconv !=
                                                                    data.posts
                                                                            .length -
                                                                        1)
                                                                  data.currconv++;
                                                              });
                                                            },
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Padding(
                                              key: ValueKey(2),
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'Üzenőfal\n',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline6,
                                                  ),
                                                  Expanded(
                                                    child: ListView.builder(
                                                      itemCount:
                                                          data.posts.length,
                                                      itemBuilder:
                                                          (context, i) {
                                                        return ListTile(
                                                          onTap: () {
                                                            data.currconv = i;
                                                            setState(() {
                                                              data.isinconv =
                                                                  true;
                                                            });
                                                          },
                                                          title: Text(
                                                            data.posts[i].title
                                                                .substring(3),
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyText1,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: Column(
                      children: [
                        Card(
                          color: Consts.cardcolor,
                          elevation: 2,
                          child: Container(
                              height: MediaQuery.of(context).size.height / 3,
                              padding: EdgeInsets.all(8),
                              width: MediaQuery.of(context).size.width,
                              child: AnimatedSwitcher(
                                switchInCurve: Curves.easeIn,
                                switchOutCurve: Curves.easeOut,
                                transitionBuilder: (Widget child,
                                    Animation<double> animation) {
                                  final inAnimation = Tween<Offset>(
                                          begin: Offset(0.0, 1.0),
                                          end: Offset(0.0, 0.0))
                                      .animate(animation);
                                  final outAnimation = Tween<Offset>(
                                          begin: Offset(0, -1.0),
                                          end: Offset(0.0, 0.0))
                                      .animate(animation);

                                  if (child.key == ValueKey(1)) {
                                    return ClipRect(
                                      child: SlideTransition(
                                        position: inAnimation,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: child,
                                        ),
                                      ),
                                    );
                                  } else {
                                    return ClipRect(
                                      child: SlideTransition(
                                        position: outAnimation,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: child,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                duration: Duration(milliseconds: 200),
                                child: !data.event.isdetailed
                                    ? Column(
                                        key: ValueKey(2),
                                        children: [
                                          Flexible(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      data.event.name,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline6,
                                                    ),
                                                    Text(
                                                      data.event.date,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .overline,
                                                    ),
                                                  ],
                                                ),
                                                Expanded(
                                                  child: SingleChildScrollView(
                                                    child: Text(
                                                        data.event.details,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText2),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              setState(() {
                                                data.event.isdetailed = true;
                                              });
                                            },
                                            icon: Icon(
                                              Icons.expand_more,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Column(
                                        key: ValueKey(1),
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8),
                                                  child: Text(
                                                    "Vállalók",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline6,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                data.event.currentSubs
                                                        .toString() +
                                                    '/' +
                                                    data.event.maxSubs
                                                        .toString(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .overline,
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                ),
                                                hoverColor: Colors.grey[800],
                                                splashRadius: 30,
                                                onPressed: () {
                                                  setState(() {
                                                    data.event.isdetailed =
                                                        false;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                          Expanded(
                                            child: ListView.builder(
                                              itemCount:
                                                  data.event.subscribers.length,
                                              itemBuilder: (context, i) {
                                                return Text(data
                                                    .event.subscribers[i].name);
                                              },
                                            ),
                                          ),
                                          OutlineButton(
                                            onPressed: () {
                                              data.event
                                                  .subscribe()
                                                  .then((value) async {
                                                await updatedata(
                                                    isdetailed: true);
                                              });
                                            },
                                            hoverColor: Colors.grey[800],
                                            borderSide:
                                                BorderSide(color: Colors.grey),
                                            child: AnimatedSwitcher(
                                              duration:
                                                  Duration(milliseconds: 200),
                                              child: Text(
                                                data.event.isSubscribed
                                                    ? "LEIRATKOZÁS"
                                                    : "FELIRATKOZÁS",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .button,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                              )),
                        ),
                        Expanded(
                          child: Card(
                            color: Consts.cardcolor,
                            child: Container(
                              padding: EdgeInsets.all(16),
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Üzenőfal',
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: data.posts.length,
                                      itemBuilder: (context, i) {
                                        return ListTile(
                                          onTap: () {
                                            data.currconv = i;
                                            setState(() {
                                              data.isinconv = true;
                                            });
                                          },
                                          title: Text(
                                            data.posts[i].title.substring(3),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class CommentsWidget extends StatefulWidget {
  final Post post;
  CommentsWidget({Key key, @required this.post}) : super(key: key);
  @override
  _CommentsWidgetState createState() => _CommentsWidgetState();
}

class _CommentsWidgetState extends State<CommentsWidget> {
  CommentData data = CommentData();
  @override
  Widget initState() {
    super.initState();
    data.fetch(widget.post.topicId, widget.post.topic).then((value) {
      setState(() {
        data.loading = false;
      });
      Timer.periodic(Duration(seconds: 1), (timer) {
        _refresh();
      });
    });
  }

  Future<Null> _refresh() async {
    bool refreshed = await data.fetch(widget.post.topicId, widget.post.topic);
    if (mounted && refreshed) {
      await setState(() {});
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        child: data.loading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Text(
                    "\nHozzászólások",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: _refresh,
                      child: ListView.builder(
                        reverse: true,
                        controller: data.scrollController,
                        itemCount: data.comments.length,
                        itemBuilder: (context, i) {
                          return Row(
                            mainAxisAlignment: UserData.username !=
                                    data.comments.reversed.toList()[i].userName
                                ? MainAxisAlignment.start
                                : MainAxisAlignment.end,
                            children: [
                              Container(
                                  width: UserData.username !=
                                          data.comments.reversed
                                              .toList()[i]
                                              .userName
                                      ? 0
                                      : 30),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8),
                                  child: Column(
                                    crossAxisAlignment: UserData.username !=
                                            data.comments.reversed
                                                .toList()[i]
                                                .userName
                                        ? CrossAxisAlignment.start
                                        : CrossAxisAlignment.end,
                                    children: [
                                      Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16)),
                                        color: UserData.username !=
                                                data.comments.reversed
                                                    .toList()[i]
                                                    .userName
                                            ? Colors.grey[850]
                                            : Colors.blueGrey,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 4, 8, 4),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              UserData.username !=
                                                      data.comments.reversed
                                                          .toList()[i]
                                                          .userName
                                                  ? Text(
                                                      data.comments.reversed
                                                          .toList()[i]
                                                          .userName,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1)
                                                  : Container(
                                                      width: 0,
                                                      height: 0,
                                                    ),
                                              Text(
                                                data.comments.reversed
                                                    .toList()[i]
                                                    .commentBody,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 8),
                                        child: Text(
                                          data.comments.reversed
                                              .toList()[i]
                                              .date,
                                          style: Theme.of(context)
                                              .textTheme
                                              .overline,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: UserData.username !=
                                        data.comments.reversed
                                            .toList()[i]
                                            .userName
                                    ? 30
                                    : 0,
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: TextFormField(
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          labelStyle: Theme.of(context).textTheme.bodyText2,
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.send,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              if (data.newctrl.text != "") {
                                data.comments.add(Comment(
                                    userName: UserData.username,
                                    commentBody: data.newctrl.text));
                                setState(() {});
                                Timer(
                                  Duration(milliseconds: 10),
                                  () => data.scrollController.jumpTo(data
                                      .scrollController
                                      .position
                                      .maxScrollExtent),
                                );
                                data
                                    .newComment(widget.post.topic,
                                        widget.post.topicId, data.newctrl.text)
                                    .then((value) {
                                  if (value == true) {
                                    _refresh();
                                  }
                                });
                                data.newctrl.text = '';
                              }
                            },
                            splashRadius: 25,
                          ),
                          labelText: 'Hozzászólás...'),
                      controller: data.newctrl,
                    ),
                  )
                ],
              ),
      ),
    );
  }
}

class HomeData {
  bool _commentsloading = true;

  bool get commentsloading => _commentsloading;

  set commentsloading(bool commentsloading) {
    if (commentsloading) currentcomments = CommentData();
    _commentsloading = commentsloading;
  }

  bool isinconv = false;
  int currconv = 0;
  bool isleft = false;
  CommentData currentcomments = CommentData();
  String name;
  bool isloading = true;
  String group;
  int subs;
  Event event;
  String title;
  String message;
  List<Post> posts;

  HomeData(
      {this.name, this.group, this.subs, this.event, this.title, this.message});

  HomeData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    group = json['group'];
    subs = json['subs'];
    event = json['event'] != null ? new Event.fromJson(json['event']) : null;
    title = json['title'];
    message = json['message'];
    if (json['posts'] != null) {
      posts = new List<Post>();
      json['posts'].forEach(
        (v) {
          posts.add(new Post.fromJson(v));
        },
      );
    }
  }

  Future<bool> fetch() async {
    final response = await http.get(UserData.apiurl +
        "?key=" +
        UserData.apikey +
        "&action=getMainPageDetails");
    if (response.statusCode == 200) {
      HomeData data = HomeData.fromJson(json.decode(response.body));
      event = data.event;
      group = data.group;
      name = data.name;
      subs = data.subs;
      posts = data.posts;
      return true;
    } else
      return false;
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

class Post {
  String topic;
  String topicId;
  String title;
  String message;

  Post({this.topic, this.topicId, this.title, this.message});

  Post.fromJson(Map<String, dynamic> json) {
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

class Subscriber {
  int dbid;
  String name;

  Subscriber({this.dbid, this.name});

  Subscriber.fromJson(Map<String, dynamic> json) {
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

class Event {
  int dbid;
  String name;
  bool isdetailed = false;
  String details;
  List<String> attachments;
  String date;
  int maxSubs;
  int currentSubs;
  bool subscribing = false;
  bool isSubscribed;
  List<Subscriber> subscribers;
  String schoolYear;

  Event(
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

  Event.fromJson(Map<String, dynamic> json) {
    dbid = json['dbid'];
    name = json['name'];
    details = json['details'];
    attachments = json['attachments'].cast<String>();
    date = json['date'];
    maxSubs = json['max_subs'];
    currentSubs = json['current_subs'];
    isSubscribed = json['is_subscribed'];
    if (json['subscribers'] != null) {
      subscribers = new List<Subscriber>();
      json['subscribers'].forEach((v) {
        subscribers.add(new Subscriber.fromJson(v));
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

  Future<bool> subscribe() async {
    final response = await http.get(UserData.apiurl +
        "?key=" +
        UserData.apikey +
        "&action=subscribeEvent&eventID=" +
        dbid.toString() +
        "&silent=" +
        UserData.admin.toString());
    if (response.statusCode == 200) {
      var j = json.decode(response.body);
      return true;
    } else
      return false;
  }
}

class CommentData {
  bool loading = true;
  ScrollController scrollController = ScrollController();
  List<Comment> comments;
  TextEditingController newctrl = TextEditingController(text: '');

  CommentData({this.comments});

  CommentData.fromJson(Map<String, dynamic> json) {
    if (json['comments'] != null) {
      comments = new List<Comment>();
      json['comments'].forEach((v) {
        comments.add(new Comment.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.comments != null) {
      data['comments'] = this.comments.map((v) => v.toJson()).toList();
    }
    return data;
  }

  Future<bool> fetch(String topicid, String topic) async {
    final response = await http.get(UserData.apiurl +
        "?action=getComments&key=" +
        UserData.apikey +
        "&topic=" +
        topic +
        "&topic_id=" +
        topicid);
    if (response.statusCode == 200) {
      comments = CommentData.fromJson(json.decode(response.body)).comments;
      return true;
    } else {
      return false;
    }
  }

  Future<bool> newComment(String topic, String topicid, String body) async {
    final response = await http.post(UserData.apiurl, body: {
      'apikey': UserData.apikey,
      'action': 'newcomment',
      'topic': topic,
      'topic_id': topicid,
      'body': body,
    });
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }
}

class Comment {
  int commentId;
  int userId;
  String userName;
  String commentDate;

  String get date {
    DateTime _date = DateTime.parse(commentDate);
    if (_date.year == DateTime.now().year &&
        _date.month == DateTime.now().month &&
        DateTime.now().day == _date.day)
      return DateFormat('kk:mm').format(_date);
    else
      return DateFormat('MM.dd.  kk:mm').format(_date);
  }

  set date(String commentDate) {
    commentDate = commentDate;
  }

  String commentBody;

  Comment(
      {this.commentId,
      this.userId,
      this.userName,
      this.commentDate,
      this.commentBody});

  Comment.fromJson(Map<String, dynamic> json) {
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
