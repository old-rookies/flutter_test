import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:demo/album.dart';

import 'album_test.mocks.dart';

// Generate a MockClient using the Mockito package.
// Create new instances of this class in each test.
@GenerateMocks([http.Client])
void main() {
  // 그룹을 생성하여 테스트들을 묶어줄 수 있다.
  group('Album Test', () {
    test('Album 생성', () {
      int userId = 1;
      int id = 1;
      String title = "testing";
      Album album = Album(userId: userId, id: id, title: title);

      // expect 함수를 이용하여 원하는 값과 매치가 잘 되는지 확인이 가능한다.
      // 첫 매개변수는 테스트에서 실제 값이고 두번째 매개변수는 기대되는 값(matcher)을 입력한다.
      expect(album.userId, userId);
      expect(album.id, id);
      expect(album.title, title);
    });

    test("Album 수정", () {
      int userId = 1;
      int id = 1;
      String title = "testing";
      int setUserId = 2;
      int setId = 2;
      String setTitle = "set testing";

      Album album = Album(userId: userId, id: id, title: title);

      expect(album.userId, userId);
      expect(album.id, id);
      expect(album.title, title);

      album.userId = setUserId;
      album.id = setId;
      album.title = setTitle;

      expect(album.userId, setUserId);
      expect(album.id, setId);
      expect(album.title, setTitle);
    });
  });

  // api 콜을 테스팅하는 방법
  group('fetchAlbum', () {
    test('Album 데이터 가져오기', () async {
      // Client 클래스의 메소드 동작을 따라하되 결과 값을 조종해야하기 때문에
      // 가짜 Client 클래스를 생성하여 조작한다.
      final client = MockClient();

      // http get을 통해서 가져와야되는 값을 실제로 api 콜을 하는 것이 아닌 미리 정해둔다.
      // 이를 통해서 백엔드의 영향을 받지 않고 프론트엔드 측에서의 온전한 테스트를 진행할 수 있게된다.
      when(client
              .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1')))
          .thenAnswer((_) async =>
              http.Response('{"userId": 1, "id": 2, "title": "mock"}', 200));

      // 두번째 매개변수와 같이 실제 값을 넣는 것이 아닌 TypeMatcher라는 타입을 통해서도 값을 확인할 수 있다.
      expect(await fetchAlbum(client), isA<Album>());
      Album album = await fetchAlbum(client);
      expect(album.id, 2);
      expect(album.userId, 1);
      expect(album.title, "mock");
      // 가짜 client가 쓰인 로그를 볼 수 있다.
      logInvocations([client]);
    });

    test('Album 데이터 가져오기 실패 404', () {
      final client = MockClient();

      // Use Mockito to return an unsuccessful response when it calls the
      // provided http.Client.
      when(client
              .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // 실패할 경우를 생각해서 throwsException을 기대한다.
      expect(fetchAlbum(client), throwsException);
    });
  });
}
