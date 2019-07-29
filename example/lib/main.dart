import 'dart:math';

import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Post {
  final String title;
  final String body;

  Post(this.title, this.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final SearchBarController<Post> _searchBarController = SearchBarController();
  bool isReplay = false;

  Future<List<Post>> _getALlPosts(String text) async {
    await Future.delayed(Duration(seconds: text.length == 4 ? 10 : 1));
    if (isReplay) return [Post("Replaying !", "Replaying body")];
    if (text.length == 5) throw Error();
    if (text.length == 6) return [];
    List<Post> posts = [];

    var random = new Random();
    for (int i = 0; i < 10; i++) {
      posts.add(Post("$text $i", "body random number : ${random.nextInt(100)}"));
    }
    return posts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: SearchBar<Post>(
            onSearch: _getALlPosts,
            searchBarController: _searchBarController,
            placeHolder: Text("placeholder"),
            cancellationText: Text("Annuler"),
            emptyWidget: Text("empty"),
            header: Row(
              children: <Widget>[
                RaisedButton(
                  child: Text("sort"),
                  onPressed: () {
                    _searchBarController.sortList((Post a, Post b) {
                      return a.body.compareTo(b.body);
                    });
                  },
                ),
                RaisedButton(
                  child: Text("Desort"),
                  onPressed: () {
                    _searchBarController.removeSort();
                  },
                ),
                RaisedButton(
                  child: Text("Replay"),
                  onPressed: () {
                    isReplay = !isReplay;
                    _searchBarController.replayLastSearch();
                  },
                ),
              ],
            ),
            onItemFound: (Post post, int index) {
              return ListTile(
                title: Text(post.title),
                subtitle: Text(post.body),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Detail()));
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class Detail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            Text("Detail"),
          ],
        ),
      ),
    );
  }
}
