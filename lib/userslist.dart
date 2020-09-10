import 'package:flutter/material.dart';
import 'functions.dart';
import 'main.dart';
import 'icons2_icons.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:url_launcher/url_launcher.dart';
import 'userdetailspage.dart';

class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final SlidableController slidableController = SlidableController();

  List<Widget> slidable(Users thisuser) {
    if (isadmin) {
      return <Widget>[
        IconSlideAction(
            caption: 'Hívás',
            color: Color.fromARGB(255, 56, 142, 60),
            icon: Icons.call,
            onTap: () {
              launch('tel:' + thisuser.tel);
            }),
        IconSlideAction(
            caption: 'Email',
            color: customblue,
            icon: Icons.email,
            onTap: () {
              launch('mailto:' + thisuser.email);
            }),
        IconSlideAction(
            caption: 'Megtekintés',
            color: cardcolor1dp,
            icon: Icons.visibility,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          UserDetailsPage(thisuser.dbid)));
            }),
      ];
    } else {
      return <Widget>[
        IconSlideAction(
            caption: 'Hívás',
            color: Color.fromARGB(255, 56, 142, 60),
            icon: Icons.call,
            onTap: () {
              launch('tel:' + thisuser.tel);
            }),
        IconSlideAction(
            caption: 'Email',
            color: customblue,
            icon: Icons.email,
            onTap: () {
              launch('mailto:' + thisuser.email);
            }),
      ];
    }
  }

  Icon pusziicon(int puszik) {
    if (puszik < 0) {
      return Icon(
        Icons2.heart_broken,
        color: Colors.red,
        size: 35,
      );
    } else
      return Icon(
        Icons.favorite,
        color: Colors.red,
        size: 35,
      );
  }

  Widget puszicounter(int puszik, int id) {
    if (!isadmin) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Center(
              child: pusziicon(puszik)),
          Center(
              child: Text(
            puszik.toString(),
            style: TextStyle(fontSize: 13),
          )),
        ],
      );
    } else {
      return Row(children: [
        IconButton(
            icon: Icon(
              Icons.remove,
              color: Colors.white,
              size: 10,
            ),
            onPressed: () {
              Future<DeleteItemData> data = PuszipontElvetel(id);
              data.then((value) {
                setState(() {});
              });
            }),
        Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: pusziicon(puszik)
            ),
            Center(
                child: Text(
              puszik.toString(),
              style: TextStyle(fontSize: 13),
            )),
          ],
        ),
        IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
              size: 10,
            ),
            onPressed: () {
              Future<DeleteItemData> data = PuszipontAdas(id);
              data.then((value) {
                setState(() {});
              });
            }),
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchuserlist(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return RefreshIndicator(
            onRefresh: () {
              setState(() {});
            },
            child: ListView.separated(
              separatorBuilder: (BuildContext context, int index) => Divider(
                color: Color.fromARGB(255, 120, 120, 120),
                height: 1,
              ),
              itemBuilder: (context, index) {
                Users thisuser = snapshot.data[index];
                return Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  controller: slidableController,
                  actionExtentRatio: 0.25,
                  actions: slidable(thisuser),
                  key: Key(thisuser.dbid.toString()),
                  child: ListTile(
                    onTap: () {},
                    title: Text(thisuser.name),
                    subtitle: Text(thisuser.group),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        puszicounter(thisuser.puszipontok, thisuser.dbid),
                        Container(
                          width: 8,
                        ),
                        Text(thisuser.subs.toString()),
                      ],
                    ),
                  ),
                );
              },
              itemCount: snapshot.data.length,
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
