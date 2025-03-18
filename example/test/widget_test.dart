// This is a basic Flutter widget test.
// To perform an interaction with a widget in your test, use the WidgetTester utility that Flutter
// provides. For example, you can send tap and scroll gestures. You can also use WidgetTester to
// find child widgets in the widget tree, read text, and verify that the values of widget properties
// are correct.

import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  DateTime? pressedDay;
  testWidgets('Default test for Calendar Carousel',
      (final WidgetTester tester) async {
    //  Build our app and trigger a frame.
    final CalendarCarousel<Event> carousel = CalendarCarousel<Event>(
      daysHaveCircularBorder: null,
      weekendTextStyle: const TextStyle(
        color: Colors.red,
      ),
      thisMonthDayBorderColor: Colors.grey,
      headerText: 'Custom Header',
      weekFormat: true,
      height: 200,
      showIconBehindDayText: true,
      customGridViewPhysics: const NeverScrollableScrollPhysics(),
      markedDateShowIcon: true,
      markedDateIconMaxShown: 2,
      selectedDayTextStyle: const TextStyle(
        color: Colors.yellow,
      ),
      todayTextStyle: const TextStyle(
        color: Colors.blue,
      ),
      markedDateIconBuilder: (final Event event) {
        return event.icon ?? const Icon(Icons.help_outline);
      },
      todayButtonColor: Colors.transparent,
      todayBorderColor: Colors.green,
      markedDateMoreShowTotal: true,
      // null for not showing hidden events indicator
      onDayPressed: (final DateTime date, final List<Event> event) {
        pressedDay = date;
      },
    );
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Container(
          child: carousel,
        ),
      ),
    ));

    expect(find.byWidget(carousel), findsOneWidget);

    expect(pressedDay, isNull);

    await tester.tap(find
        .text(DateTime.now().subtract(const Duration(days: 1)).day.toString()));

    await tester.pump();

    expect(pressedDay, isNotNull);
  });
}
