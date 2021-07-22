import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Album> fetchAlbum(http.Client client) async {
  final response = await client
      .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
  print(response);
  if (response.statusCode == 200) {
    return Album.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}

class Album {
  late int _userId;
  late int _id;
  late String _title;

  Album({required userId, required id, required title}) {
    this._userId = userId;
    this._id = id;
    this._title = title;
  }

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }

  int get userId => this._userId;
  int get id => this._id;
  String get title => this._title;

  set userId(int _id) => this._userId = _id;
  set id(int _id) => this._id = _id;
  set title(String _title) => this._title = _title;
}
