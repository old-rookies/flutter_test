import 'package:demo/album.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:demo/main.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'myWidget_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group(
    "main widget test",
    () {
      testWidgets('위젯 내 카운팅 기능 확인', (WidgetTester tester) async {
        // 위젯을 빌드하고 프레임을 시작해주는 역할을 한다.
        await tester.pumpWidget(MyApp(title: "test widget"));

        // 0으로 카운트가 시작되는지 확인한다.
        expect(find.text('test widget'), findsOneWidget);
        expect(find.text('0'), findsOneWidget);
        expect(find.text('1'), findsNothing);

        // + 아이콘을 tap 하고 동작하게한다.
        await tester.tap(find.byIcon(Icons.add));
        await tester.pump();

        // 실제로 값이 증가했는지 확인한다.
        expect(find.text('0'), findsNothing);
        expect(find.text('1'), findsOneWidget);
      });

      testWidgets('위젯 내 통신 성공', (WidgetTester tester) async {
        final client = MockClient();
        // client의 동작의 결과를 정해줍니다.
        when(client.get(
                Uri.parse('https://jsonplaceholder.typicode.com/albums/1')))
            .thenAnswer((_) async =>
                http.Response('{"userId": 1, "id": 2, "title": "mock"}', 200));

        Future<Album> futureAlbum = fetchAlbum(client);

        // 위젯을 빌드하고 시작합니다.
        await tester.pumpWidget(
          MaterialApp(
            home: AlbumFutureBuilder(
              futureAlbum: futureAlbum,
            ),
          ),
        );
        // 위젯 타입에 따라 검색하여서 로딩 인디케이터가 제대로 나오는지 확인합니다.
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        // 다음 프레임으로 넘어갑니다.
        await tester.pump();
        // client에 의해서 값이 생성되고 로딩 인디케이터가 사라지고 mock이라는 text가 나오게 됩니다.
        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(find.text("mock"), findsOneWidget);
      });

      testWidgets(
        "통신 실패",
        (WidgetTester tester) async {
          final client = MockClient();

          when(client.get(
                  Uri.parse('https://jsonplaceholder.typicode.com/albums/1')))
              .thenAnswer((_) async => http.Response('Not Found', 404));

          Future<Album> futureAlbum = fetchAlbum(client);
          expect(futureAlbum, throwsException);
          Widget widget = MaterialApp(
            home: AlbumFutureBuilder(
              futureAlbum: futureAlbum,
            ),
          );

          await tester.pumpWidget(widget);

          expect(find.byType(CircularProgressIndicator), findsOneWidget);

          await tester.pump();
          // tester 객체 안에는 테스팅시 위젯트리가 어떻게 형성이 되어 있는지 그리고
          // 각종 다양한 내용들이 있습니다. 이를 통해서 테스팅 중 어떤 값이 잘못되었는지 디버깅할 수 있습니다.
          print(tester.elementList(find.byType(Text)));

          expect(find.byType(CircularProgressIndicator), findsNothing);

          expect(find.text("Exception: Failed to load album"), findsOneWidget);
          logInvocations([client]);
        },
      );
    },
  );
}
