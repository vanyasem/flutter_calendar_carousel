import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/src/calendar_header.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String title = 'Test title';
  const EdgeInsets margin = EdgeInsets.symmetric(vertical: 16);
  const MaterialAccentColor iconColor = Colors.blueAccent;

  testWidgets('Verify Header Defaults', (final WidgetTester tester) async {
    bool headerTapped = false;
    bool leftPressed = false;
    bool rightPressed = false;

    await tester.pumpWidget(
      wrapped(
        CalendarHeader(
          headerTitle: title,
          headerMargin: margin,
          showHeader: true,
          showHeaderButtons: true,
          headerIconColor: iconColor,
          onHeaderTitlePressed: () => headerTapped = true,
          onRightButtonPressed: () => rightPressed = true,
          onLeftButtonPressed: () => leftPressed = true,
        ),
      ),
    );

    expect(find.text(title), findsOneWidget);

    await tester.tap(find.byType(TextButton));

    await tester.pump();

    expect(headerTapped, equals(true));

    await tester.tap(find.widgetWithIcon(IconButton, Icons.chevron_right));

    await tester.pump();

    expect(rightPressed, equals(true));

    await tester.tap(find.widgetWithIcon(IconButton, Icons.chevron_left));

    await tester.pump();

    expect(leftPressed, equals(true));
  });

  testWidgets('Verify No header Renders', (final WidgetTester tester) async {
    final CalendarHeader noHeaderEmpty = CalendarHeader(
      showHeader: false,
      headerTitle: '',
      onLeftButtonPressed: () {},
      onHeaderTitlePressed: () {},
      onRightButtonPressed: () {},
    );

    await tester.pumpWidget(Container(child: noHeaderEmpty));

    expect(find.byWidget(noHeaderEmpty), findsOneWidget);
  });

  testWidgets('Verify Header Is Not Touchable', (
    final WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      wrapped(
        CalendarHeader(
          headerTitle: title,
          headerMargin: margin,
          showHeader: true,
          showHeaderButtons: true,
          headerIconColor: iconColor,
          onHeaderTitlePressed: null,
          onRightButtonPressed: () {},
          onLeftButtonPressed: () {},
        ),
      ),
    );

    // the header TextButton Should not render
    final Finder touchableHeader = find.byType(TextButton);

    expect(touchableHeader, findsNothing);
  });

  testWidgets('Verify No Header Buttons', (final WidgetTester tester) async {
    await tester.pumpWidget(
      wrapped(
        CalendarHeader(
          headerTitle: title,
          headerMargin: margin,
          showHeader: true,
          showHeaderButtons: false,
          headerIconColor: iconColor,
          onHeaderTitlePressed: () {},
          onRightButtonPressed: () {},
          onLeftButtonPressed: () {},
        ),
      ),
    );

    // the header IconButtons Should not render
    final Finder headerButton = find.byType(IconButton);

    expect(headerButton, findsNothing);
  });
}

// header uses Row which requires MaterialApp as an ancestor
Widget wrapped(final Widget widget) =>
    MaterialApp(home: Material(child: widget));
