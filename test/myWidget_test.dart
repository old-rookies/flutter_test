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
        // Build our app and trigger a frame.
        await tester.pumpWidget(MyApp(title: "test widget"));

        // Verify that our counter starts at 0.
        expect(find.text('test widget'), findsOneWidget);
        expect(find.text('0'), findsOneWidget);
        expect(find.text('1'), findsNothing);

        // Tap the '+' icon and trigger a frame.
        await tester.tap(find.byIcon(Icons.add));
        await tester.pump();

        // Verify that our counter has incremented.
        expect(find.text('0'), findsNothing);
        expect(find.text('1'), findsOneWidget);
      });

      testWidgets('위젯 내 통신 성공', (WidgetTester tester) async {
        final client = MockClient();

        when(client.get(
                Uri.parse('https://jsonplaceholder.typicode.com/albums/1')))
            .thenAnswer((_) async =>
                http.Response('{"userId": 1, "id": 2, "title": "mock"}', 200));

        Future<Album> futureAlbum = fetchAlbum(client);

        // await tester.pumpWidget(MyApp(title: "test widget"));

        await tester.pumpWidget(
          MaterialApp(
            home: AlbumFutureBuilder(
              futureAlbum: futureAlbum,
            ),
          ),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        await tester.pump();

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
          print(tester.elementList(find.byType(Text)));
          expect(find.byType(CircularProgressIndicator), findsNothing);

          expect(find.text("Exception: Failed to load album"), findsOneWidget);
          logInvocations([client]);
        },
      );
    },
  );
}
