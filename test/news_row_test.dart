import 'package:flutter_test/flutter_test.dart';
import 'package:fyp/pages/news_row.dart';
import 'package:fyp/models/news.dart';
import 'package:flutter/material.dart';

void main() {

  testWidgets('NewsRow has News object', (WidgetTester tester) async {
    News temp = new News(id: '1', schoolId: '101', title: 'Test', 
                  author: 'test', imageUrl: null, description: 'Fake desc', date: 'test');
    await tester.pumpWidget(NewsRow(temp));

    final titleFinder = find.text('Test');
    final authorFinder = find.text('test');
    final descFinder = find.text('Fake desc');

    expect(titleFinder, findsOneWidget); //verify that text appears exactly once
    expect(authorFinder, findsOneWidget);
    expect(descFinder, findsNothing);
  });

  testWidgets('find specific instance of Container in NewsRow', (WidgetTester tester) async {
    final childWidget = FlatButton(child: new Stack());

    await tester.pumpWidget(MaterialApp(home: Container (child: childWidget)));

    expect(find.byWidget(childWidget), findsOneWidget);
  });
}