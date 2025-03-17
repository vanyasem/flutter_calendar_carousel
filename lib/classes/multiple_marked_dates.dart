import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/marked_date.dart';

class MultipleMarkedDates {
  MultipleMarkedDates({required this.markedDates});

  List<MarkedDate> markedDates;

  void add(final MarkedDate markedDate) {
    markedDates.add(markedDate);
  }

  void addRange(final MarkedDate markedDate,
      {final int plus = 0, final int minus = 0}) {
    add(markedDate);

    if (plus > 0) {
      int start = 1;
      MarkedDate newAddMarkedDate;

      while (start <= plus) {
        newAddMarkedDate = MarkedDate(
          color: markedDate.color,
          date: markedDate.date.add(Duration(days: start)),
          textStyle: markedDate.textStyle,
        );

        add(newAddMarkedDate);

        start += 1;
      }
    }

    if (minus > 0) {
      int start = 1;
      MarkedDate newSubMarkedDate;

      while (start <= minus) {
        newSubMarkedDate = MarkedDate(
          color: markedDate.color,
          date: markedDate.date.subtract(Duration(days: start)),
          textStyle: markedDate.textStyle,
        );

        add(newSubMarkedDate);

        start += 1;
      }
    }
  }

  void addAll(final List<MarkedDate> markedDates) {
    this.markedDates.addAll(markedDates);
  }

  bool remove(final MarkedDate markedDate) {
    return markedDates.remove(markedDate);
  }

  void clear() {
    markedDates.clear();
  }

  bool isMarked(final DateTime date) {
    final results = markedDates.firstWhere(
        (final element) => element.date == date,
        orElse: () => MarkedDate(color: Colors.black, date: DateTime(0)));
    return results.date.year == date.year;
  }

  Color getColor(final DateTime date) {
    final results = markedDates.firstWhere(
        (final element) => element.date == date,
        orElse: () => MarkedDate(color: Colors.black, date: DateTime(0)));
    return results.color;
  }

  DateTime getDate(final DateTime date) {
    final results = markedDates.firstWhere(
        (final element) => element.date == date,
        orElse: () => MarkedDate(color: Colors.black, date: DateTime(0)));
    return results.date;
  }

  TextStyle? getTextStyle(final DateTime date) {
    final results = markedDates.firstWhere(
        (final element) => element.date == date,
        orElse: () => MarkedDate(color: Colors.black, date: DateTime(0)));
    return results.textStyle;
  }
}
