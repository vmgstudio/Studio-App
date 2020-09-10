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
  Future<CommentData> comments;
  TextEditingController commentsctrl = TextEditingController(text: '');
  Widget sendicon = Icon(Icons.send, color: Color.fromARGB(255, 191, 191, 191));
  ScrollController ctrl = new ScrollController();


  @override
  Widget initState() {
    super.initState();
    comments = getcomments(post.topicId, post.topic);

  }

  _PostDetailsState(this.post);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
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
                      CommentData commentdata = snapshot.data;

                      List<Widget> commentwidgets = new List<Widget>();
                      for (var i = 0; i < commentdata.comments.length; i++) {
                        DateTime date =
                            DateTime.parse(commentdata.comments[i].commentDate);
                        String getdate() {
                          if (date.year == DateTime.now().year &&
                              date.month == DateTime.now().month &&
                              DateTime.now().day == date.day)
                            return DateFormat('kk:mm').format(date);
                          else
                            return DateFormat('MM.dd.  kk:mm').format(date);
                        }

                        if (isadmin) {
                          if (commentdata.comments[i].userId.toString() !=
                              userId) {
                            commentwidgets.add(Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                          maxWidth:
                                              MediaQuery.of(context).size.width -
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
                                              Text(commentdata.comments[i].userName),
                                              Text(
                                                commentdata.comments[i].commentBody,
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
                                            deleteComment(commentdata
                                                .comments[i].commentId
                                                .toString());
                                        delete.then((value) => setState(() {
                                              comments = getcomments(
                                                  post.topicId, post.topic);
                                            }));
                                      },
                                      itemBuilder: (BuildContext context) =>
                                          <PopupMenuEntry<Delete>>[
                                        PopupMenuItem<Delete>(
                                            value: Delete.delete,
                                            child: Text('Törlés', style: TextStyle(color: Colors.black),))
                                      ],
                                      icon: Icon(
                                        Icons.more_vert,
                                        color: Color.fromARGB(255, 191, 191, 191),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                          maxWidth:
                                              MediaQuery.of(context).size.width -
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
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(commentdata
                                                  .comments[i].userName),
                                              Text(
                                                commentdata
                                                    .comments[i].commentBody,
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
                                            deleteComment(commentdata
                                                .comments[i].commentId
                                                .toString());
                                        delete.then((value) => setState(() {
                                              comments = getcomments(
                                                  post.topicId, post.topic);
                                            }));
                                      },
                                      itemBuilder: (BuildContext context) =>
                                          <PopupMenuEntry<Delete>>[
                                        PopupMenuItem<Delete>(
                                            value: Delete.delete,
                                            child: Text('Törlés', style: TextStyle(color: Colors.black),))
                                      ],
                                      icon: Icon(
                                        Icons.more_vert,
                                        color: Color.fromARGB(255, 191, 191, 191),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ));
                          }
                        } else {
                           if (commentdata.comments[i].userId.toString() !=
                            userId) {
                          commentwidgets.add(Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width -
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
                                            Text(commentdata.comments[i].userName),
                                            Text(
                                              commentdata.comments[i].commentBody,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width -
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
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(commentdata
                                                .comments[i].userName),
                                            Text(
                                              commentdata
                                                  .comments[i].commentBody,
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
                                            deleteComment(commentdata
                                                .comments[i].commentId
                                                .toString());
                                        delete.then((value) => setState(() {
                                              comments = getcomments(
                                                  post.topicId, post.topic);
                                            }));
                                      },
                                      itemBuilder: (BuildContext context) =>
                                          <PopupMenuEntry<Delete>>[
                                        PopupMenuItem<Delete>(
                                            value: Delete.delete,
                                            child: Text('Törlés', style: TextStyle(color: Colors.black),))
                                      ],
                                      icon: Icon(
                                        Icons.more_vert,
                                        color: Color.fromARGB(255, 191, 191, 191),
                                      ),
                                    )
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
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          height: 60,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: TextFormField(
              controller: commentsctrl,
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
                      setState(() {
                        sendicon = CircularProgressIndicator();
                      });
                      Future<DeleteItemData> newcomment = newComment(
                          post.topic, post.topicId, commentsctrl.text);
                      newcomment.then((value) {
                        commentsctrl.text = '';
                        comments = getcomments(post.topicId, post.topic);
                        setState(() {
                          sendicon = Icon(Icons.send,
                              color: Color.fromARGB(255, 191, 191, 191));
                        });
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
      ),
    );
  }
}