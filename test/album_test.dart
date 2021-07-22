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
  group('Album Test', () {
    test('Album 생성', () {
      int userId = 1;
      int id = 1;
      String title = "testing";
      Album album = Album(userId: userId, id: id, title: title);

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

  group('fetchAlbum', () {
    test('Album 데이터 가져오기', () async {
      final client = MockClient();

      when(client
              .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1')))
          .thenAnswer((_) async =>
              http.Response('{"userId": 1, "id": 2, "title": "mock"}', 200));

      expect(await fetchAlbum(client), isA<Album>());
      fetchAlbum(client).then((album) => {
            expect(album.id, 2),
            expect(album.userId, 1),
            expect(album.title, "mock"),
          });

      logInvocations([client]);
    });

    test('Album 데이터 가져오기 실패 404', () {
      final client = MockClient();

      // Use Mockito to return an unsuccessful response when it calls the
      // provided http.Client.
      when(client
              .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(fetchAlbum(client), throwsException);
    });
  });
}
