import 'dart:async';

import 'package:demo/album.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp(title: "Test Demo"));

class MyApp extends StatefulWidget {
  // final 키워드는 값이 정해졌을 때 변경을 하지 못하게 한다.
  final String title;
  MyApp({Key? key, required this.title}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final Future<Album> futureAlbum;
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  // 라이프 서클 중 처음 로드 되었을 때 상태를 저장한다.
  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum(http.Client());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: widget.title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AlbumFutureBuilder(futureAlbum: futureAlbum),
              Text("You have pushed the button this many times:"),
              Text('$_counter', style: Theme.of(context).textTheme.headline4),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

// 위젯을 가독성 + 테스트를 하기 위해서 분리 시켜준다.
class AlbumFutureBuilder extends StatelessWidget {
  final Future<Album> futureAlbum;
  const AlbumFutureBuilder({Key? key, required this.futureAlbum})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Album>(
      future: futureAlbum,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data!.title.toString());
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
