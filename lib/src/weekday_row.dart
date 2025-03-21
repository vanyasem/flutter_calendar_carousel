import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_calendar_carousel/src/default_styles.dart'
    show defaultWeekdayTextStyle;
import 'package:intl/intl.dart';

class WeekdayRow extends StatelessWidget {
  const WeekdayRow(
    this.firstDayOfWeek,
    this.customWeekdayBuilder, {
    super.key,
    required this.showWeekdays,
    required this.capitalizeWeekDays,
    required this.weekdayFormat,
    required this.weekdayMargin,
    required this.weekdayPadding,
    required this.weekdayBackgroundColor,
    required this.weekdayTextStyle,
    required this.localeDate,
  });

  final WeekdayBuilder? customWeekdayBuilder;
  final bool showWeekdays;
  final bool capitalizeWeekDays;
  final WeekdayFormat weekdayFormat;
  final EdgeInsets weekdayMargin;
  final EdgeInsets weekdayPadding;
  final Color weekdayBackgroundColor;
  final TextStyle? weekdayTextStyle;
  final DateFormat localeDate;
  final int firstDayOfWeek;

  Widget _weekdayContainer(final int weekday, final String weekDayName) {
    final WeekdayBuilder? customWeekdayBuilder = this.customWeekdayBuilder;
    return customWeekdayBuilder != null
        ? customWeekdayBuilder(weekday, weekDayName)
        : Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: weekdayBackgroundColor),
              color: weekdayBackgroundColor,
            ),
            margin: weekdayMargin,
            padding: weekdayPadding,
            child: Center(
              child: DefaultTextStyle(
                style: defaultWeekdayTextStyle,
                child: Text(
                  capitalizeWeekDays ? weekDayName.toUpperCase() : weekDayName,
                  semanticsLabel: weekDayName,
                  style: weekdayTextStyle,
                ),
              ),
            ),
          ),
        );
  }

  //  List<Widget> _generateWeekdays() {
  //    switch (weekdayFormat) {
  //      case WeekdayFormat.weekdays:
  //        return localeDate.dateSymbols.WEEKDAYS
  //            .map<Widget>(_weekdayContainer)
  //            .toList();
  //      case WeekdayFormat.standalone:
  //        return localeDate.dateSymbols.STANDALONEWEEKDAYS
  //            .map<Widget>(_weekdayContainer)
  //            .toList();
  //      case WeekdayFormat.short:
  //        return localeDate.dateSymbols.SHORTWEEKDAYS
  //            .map<Widget>(_weekdayContainer)
  //            .toList();
  //      case WeekdayFormat.standaloneShort:
  //        return localeDate.dateSymbols.STANDALONESHORTWEEKDAYS
  //            .map<Widget>(_weekdayContainer)
  //            .toList();
  //      case WeekdayFormat.narrow:
  //        return localeDate.dateSymbols.NARROWWEEKDAYS
  //            .map<Widget>(_weekdayContainer)
  //            .toList();
  //      case WeekdayFormat.standaloneNarrow:
  //        return localeDate.dateSymbols.STANDALONENARROWWEEKDAYS
  //            .map<Widget>(_weekdayContainer)
  //            .toList();
  //      default:
  //        return localeDate.dateSymbols.STANDALONEWEEKDAYS
  //            .map<Widget>(_weekdayContainer)
  //            .toList();
  //    }
  //  }

  // TODO - locale issues
  List<Widget> _renderWeekDays() {
    final List<Widget> list = <Widget>[];

    /// because of number of days in a week is 7, so it would be easier to count it til 7.
    for (
      int i = firstDayOfWeek, count = 0;
      count < 7;
      i = (i + 1) % 7, count++
    ) {
      String weekDay;

      switch (weekdayFormat) {
        case WeekdayFormat.weekdays:
          weekDay = localeDate.dateSymbols.WEEKDAYS[i];
        case WeekdayFormat.standalone:
          weekDay = localeDate.dateSymbols.STANDALONEWEEKDAYS[i];
        case WeekdayFormat.short:
          weekDay = localeDate.dateSymbols.SHORTWEEKDAYS[i];
        case WeekdayFormat.standaloneShort:
          weekDay = localeDate.dateSymbols.STANDALONESHORTWEEKDAYS[i];
        case WeekdayFormat.narrow:
          weekDay = localeDate.dateSymbols.NARROWWEEKDAYS[i];
        case WeekdayFormat.standaloneNarrow:
          weekDay = localeDate.dateSymbols.STANDALONENARROWWEEKDAYS[i];
      }
      list.add(_weekdayContainer(count, weekDay));
    }

    return list;
  }

  @override
  Widget build(final BuildContext context) =>
      showWeekdays
          ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _renderWeekDays(),
          )
          : const SizedBox.shrink();
}
