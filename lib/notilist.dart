import 'functions.dart';
import 'main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotiListPage extends StatefulWidget {
  final List<Posts> posts;

  const NotiListPage({Key key, this.posts}) : super(key: key);
  @override
  _NotiListPageState createState() => _NotiListPageState(posts);
}

class _NotiListPageState extends State<NotiListPage> {
  final List<Posts> posts;

  _NotiListPageState(this.posts);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Közlemények'),
      ),
      body: Hero(
          tag: "notipage",
          child: ListView.separated(
              separatorBuilder: (BuildContext context, int index) => Divider(
                    color: Color.fromARGB(255, 120, 120, 120),
                    height: 1,
                  ),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PostDetails(
                                  post: posts[index],
                                )));
                  },
                  title: Text(posts[index].title),
                  subtitle: Text(posts[index].message),
                  isThreeLine: true,
                );
              })),
    );
  }
}

enum Delete { delete }

class PostDetails extends StatefulWidget {
  final Posts post;

  const PostDetails({Key key, this.post}) : super(key: key);
  @override
  _PostDetailsState createState() => _PostDetailsState(post);
}

class _PostDetailsState extends State<PostDetails> {
  final Posts post;
  CommentData data;
  Future<CommentData> comments;
  TextEditingController commentsctrl = TextEditingController(text: '');
  Widget sendicon = Icon(Icons.send, color: Color.fromARGB(255, 191, 191, 191));
  ScrollController ctrl = new ScrollController();
  double taglisth = 0;
  int tagnum = 0;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  String typedname = '';
  int tagnumhandled = 0;

  @override
  Widget initState() {
    super.initState();
    comments = getcomments(post.topicId, post.topic);
    comments.then((value) {
      data = value;
      setState(() {});
    });
  }

  Future<Null> _refresh({bool scrolldown = false}) async{
    Future<CommentData> _cmnts = getcomments(post.topicId, post.topic);
    await _cmnts.then((value) async {
      data = value;
      await setState(() {});
      if (scrolldown) {
        await new Future.delayed(const Duration(milliseconds: 100));
        await ctrl.animateTo(ctrl.position.maxScrollExtent,
            duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
      }
      return null;
    });
  }

  _PostDetailsState(this.post);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        child: CustomScrollView(
          controller: ctrl,
          slivers: [
            SliverAppBar(
              title: Text(post.title.substring(22)),
              pinned: true,
              floating: true,
              snap: true,
              expandedHeight: 250.0,
              flexibleSpace: FlexibleSpaceBar(
                background: SafeArea(
                    child: Container(
                  color: Colors.grey[900],
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 55, 8, 8),
                    child: Text(post.message),
                  ),
                )),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  FutureBuilder(
                    future: comments,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        List<Widget> commentwidgets = new List<Widget>();
                        for (var i = 0; i < data.comments.length; i++) {
                          DateTime date =
                              DateTime.parse(data.comments[i].commentDate);
                          String getdate() {
                            if (date.year == DateTime.now().year &&
                                date.month == DateTime.now().month &&
                                DateTime.now().day == date.day)
                              return DateFormat('kk:mm').format(date);
                            else
                              return DateFormat('MM.dd.  kk:mm').format(date);
                          }

                          if (isadmin) {
                            if (data.comments[i].userId.toString() != userId) {
                              commentwidgets.add(Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      ConstrainedBox(
                                        constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                130),
                                        child: Card(
                                          color: cardcolor2dp,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(18),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(data.comments[i].userName),
                                                Text(
                                                  data.comments[i].commentBody,
                                                  style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 191, 191, 191),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      PopupMenuButton<Delete>(
                                        onSelected: (Delete a) {
                                          Future<DeleteItemData> delete =
                                              deleteComment(data
                                                  .comments[i].commentId
                                                  .toString());
                                          delete.then((value) => setState(() {
                                                data.comments.removeAt(i);
                                                setState(() {});
                                                _refresh(scrolldown: true);
                                              }));
                                        },
                                        itemBuilder: (BuildContext context) =>
                                            <PopupMenuEntry<Delete>>[
                                          PopupMenuItem<Delete>(
                                              value: Delete.delete,
                                              child: Text(
                                                'Törlés',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ))
                                        ],
                                        icon: Icon(
                                          Icons.more_vert,
                                          color: Color.fromARGB(
                                              255, 191, 191, 191),
                                        ),
                                      )
                                    ],
                                  ),
                                  Text(
                                    getdate(),
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 191, 191, 191),
                                    ),
                                  )
                                ],
                              ));
                            } else {
                              commentwidgets.add(Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    getdate(),
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 191, 191, 191),
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      PopupMenuButton<Delete>(
                                        onSelected: (Delete a) {
                                          Future<DeleteItemData> delete =
                                              deleteComment(data
                                                  .comments[i].commentId
                                                  .toString());
                                          delete.then((value) => setState(() {
                                                data.comments.removeAt(i);
                                                setState(() {});
                                                _refresh(scrolldown: true);
                                              }));
                                        },
                                        itemBuilder: (BuildContext context) =>
                                            <PopupMenuEntry<Delete>>[
                                          PopupMenuItem<Delete>(
                                              value: Delete.delete,
                                              child: Text(
                                                'Törlés',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ))
                                        ],
                                        icon: Icon(
                                          Icons.more_vert,
                                          color: Color.fromARGB(
                                              255, 191, 191, 191),
                                        ),
                                      ),
                                      ConstrainedBox(
                                        constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                130),
                                        child: Card(
                                          color: cardcolor2dp,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(18),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(data.comments[i].userName),
                                                Text(
                                                  data.comments[i].commentBody,
                                                  style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 191, 191, 191),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ));
                            }
                          } else {
                            if (data.comments[i].userId.toString() != userId) {
                              commentwidgets.add(Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      ConstrainedBox(
                                        constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                100),
                                        child: Card(
                                          color: cardcolor2dp,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(18),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(data.comments[i].userName),
                                                Text(
                                                  data.comments[i].commentBody,
                                                  style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 191, 191, 191),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    getdate(),
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 191, 191, 191),
                                    ),
                                  )
                                ],
                              ));
                            } else {
                              commentwidgets.add(Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    getdate(),
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 191, 191, 191),
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      PopupMenuButton<Delete>(
                                        onSelected: (Delete a) {
                                          Future<DeleteItemData> delete =
                                              deleteComment(data
                                                  .comments[i].commentId
                                                  .toString());
                                          delete.then((value) => setState(() {
                                                data.comments.removeAt(i);
                                                setState(() {});
                                                _refresh(scrolldown: true);
                                              }));
                                        },
                                        itemBuilder: (BuildContext context) =>
                                            <PopupMenuEntry<Delete>>[
                                          PopupMenuItem<Delete>(
                                              value: Delete.delete,
                                              child: Text(
                                                'Törlés',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ))
                                        ],
                                        icon: Icon(
                                          Icons.more_vert,
                                          color: Color.fromARGB(
                                              255, 191, 191, 191),
                                        ),
                                      ),
                                      ConstrainedBox(
                                        constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                130),
                                        child: Card(
                                          color: cardcolor2dp,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(18),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(data.comments[i].userName),
                                                Text(
                                                  data.comments[i].commentBody,
                                                  style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 191, 191, 191),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ));
                            }
                          }
                        }
                        return Column(children: commentwidgets);
                      } else
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              height: taglisth,
              child: Card(
                color: cardcolor2dp,
                child: Builder(builder: (c) {
                  List<Users> fapiUsers = new List<Users>();

                  if (typedname == "") {
                    fapiUsers = apiUsers;
                  } else {
                    for (var item in apiUsers) {
                      if (item.name
                              .toLowerCase()
                              .contains(typedname.toLowerCase()) ||
                          item.name.contains(typedname.toLowerCase())) {
                        fapiUsers.add(item);
                      }
                    }
                  }
                  return ListView.separated(
                    separatorBuilder: (context, index) {
                      return Divider(
                        height: 0,
                      );
                    },
                    itemCount: fapiUsers.length,
                    itemBuilder: (context, index) {
                      Users cu = fapiUsers[index];
                      return ListTile(
                        onTap: () {
                          commentsctrl.text = commentsctrl.text.substring(
                              0, commentsctrl.text.length - typedname.length);
                          commentsctrl.text += cu.name + ' ';
                          commentsctrl.selection = TextSelection.fromPosition(
                              TextPosition(offset: commentsctrl.text.length));
                          setState(() {
                            taglisth = 0;
                            tagnumhandled += 1;
                          });
                        },
                        dense: true,
                        title: Text('@' + cu.name),
                      );
                    },
                  );
                }),
              ),
            ),
            Container(
              height: 60,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: TextFormField(
                  onTap: () async {
                    await new Future.delayed(const Duration(milliseconds: 300));
                    ctrl.animateTo(ctrl.position.maxScrollExtent,
                        duration: Duration(milliseconds: 200),
                        curve: Curves.easeInOut);
                  },
                  controller: commentsctrl,
                  onChanged: (t) {
                    if (t.indexOf('@') != -1) {
                      print('open dialog');
                      tagnum = 0;
                      typedname = commentsctrl.text
                          .substring(commentsctrl.text.lastIndexOf('@') + 1);
                      t.runes.forEach((int rune) {
                        var character = new String.fromCharCode(rune);
                        if (character == '@') {
                          tagnum++;
                        }
                      });
                      if (tagnum != tagnumhandled) {
                        setState(() {
                          taglisth = 150;
                        });
                      }
                    } else {
                      tagnum = 0;
                      setState(() {
                        taglisth = 0;
                        tagnumhandled = 0;
                      });
                    }
                  },
                  maxLines: null,
                  decoration: InputDecoration(
                    filled: false,
                    fillColor: cardcolor2dp,
                    border: OutlineInputBorder(),
                    labelText: 'Hozzászólás...',
                    labelStyle: TextStyle(
                      color: Color.fromARGB(255, 191, 191, 191),
                    ),
                    suffixIcon: IconButton(
                      icon: sendicon,
                      onPressed: () {
                        if (commentsctrl.text != '') {
                          data.comments.add(Comments(
                              commentBody: commentsctrl.text + " (Sending...)",
                              commentDate: DateTime.now().toString(),
                              userId: int.parse(userId),
                              userName: name));
                          String _t = commentsctrl.text;

                          setState(() {
                            commentsctrl.text = '';
                          });
                          Future<DeleteItemData> newcomment =
                              newComment(post.topic, post.topicId, _t);
                          newcomment.then((value) {
                            _refresh(scrolldown: true);
                          });
                        }
                      },
                    ),
                    prefixIcon: Icon(Icons.comment,
                        color: Color.fromARGB(255, 191, 191, 191)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
