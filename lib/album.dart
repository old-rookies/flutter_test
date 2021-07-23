import 'package:http/http.dart' as http;
import 'dart:convert';

// Album을 가져오는 함수.
// Future는 js에서 Promise 와 같은 객체라고 보면 된다.
Future<Album> fetchAlbum(http.Client client) async {
  final response = await client
      .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

  // response가 200 코드 였을 때 json 파싱을 진행한다.
  if (response.statusCode == 200) {
    // jsonDecode는 map 형태로 반환을 하게 된다.
    return Album.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}

// Album class
class Album {
  // late 키워드를 통해서 필수 변수들을 나중에 선언할 수 있다.
  late int _userId;
  late int _id;
  late String _title;
  // 1. {} 안에 들어가면 매개변수를 키 : 값 형태로 넘겨줄 수 있다.
  // 2. required 키워드를 통해서 필수로 들어가야하는 값을 지정할 수 있다.
  Album({required int userId, required int id, required String title}) {
    this._userId = userId;
    this._id = id;
    this._title = title;
  }
  // factory 패턴을 이용할 때 factory 키워드를 이용한다.
  // #factory 패턴은 생성 시에 주로 이용된다.
  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }

// getter 섹션
  int get userId => this._userId;
  int get id => this._id;
  String get title => this._title;
// setter 섹션
  set userId(int _id) => this._userId = _id;
  set id(int _id) => this._id = _id;
  set title(String _title) => this._title = _title;
}
