import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_calendar_carousel/classes/multiple_marked_dates.dart';
import 'package:flutter_calendar_carousel/src/calendar_header.dart';
import 'package:flutter_calendar_carousel/src/default_styles.dart';
import 'package:flutter_calendar_carousel/src/weekday_row.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' show DateFormat;

export 'package:flutter_calendar_carousel/classes/event_list.dart';

typedef MarkedDateIconBuilder<T> = Widget? Function(T event);
typedef OnDayPressed<T> = void Function(DateTime, List<T>);
typedef OnDayLongPressed = void Function(DateTime day);
typedef OnCalendarChanged = void Function(DateTime);

/// This builder is called for every day in the calendar.
/// If you want to build only few custom day containers, return null for the days you want to leave with default looks
/// All characteristics like circle border are also applied to the custom day container [DayBuilder] provides.
/// (if supplied function returns null, Calendar's function will be called for [day]).
/// [isSelectable] - is between [CalendarCarousel.minSelectedDate] and [CalendarCarousel.maxSelectedDate]
/// [index] - DOES NOT equal day number! Index of the day built in current visible field
/// [isSelectedDay] - if the day is selected
/// [isToday] - if the day is similar to [DateTime.now()]
/// [isPrevMonthDay] - if the day is from previous month
/// [textStyle] - text style that would have been applied by the calendar if it was to build the day.
/// Example: if the user provided [CalendarCarousel.todayTextStyle] and [isToday] is true,
///   [CalendarCarousel.todayTextStyle] would be sent into [DayBuilder]'s [textStyle]. If user didn't
///   provide it, default [CalendarCarousel]'s textStyle would be sent. Same applies to all text styles like
///   [CalendarCarousel.prevDaysTextStyle], [CalendarCarousel.daysTextStyle] etc.
/// [isNextMonthDay] - if the day is from next month
/// [isThisMonthDay] - if the day is from next month
/// [day] - day being built.
typedef DayBuilder =
    Widget? Function(
      bool isSelectable,
      int index,
      bool isSelectedDay,
      bool isToday,
      bool isPrevMonthDay,
      TextStyle textStyle,
      bool isNextMonthDay,
      bool isThisMonthDay,
      DateTime day,
    );

/// This builder is called for every weekday container (7 times, from Mon to Sun).
/// [weekday] - weekday built, from 0 to 6.
/// [weekdayName] - string representation of the weekday (Mon, Tue, Wed, etc).
typedef WeekdayBuilder = Widget Function(int weekday, String weekdayName);

class CalendarCarousel<T extends EventInterface> extends StatefulWidget {
  const CalendarCarousel({
    super.key,
    this.viewportFraction = 1,
    this.prevDaysTextStyle,
    this.daysTextStyle,
    this.nextDaysTextStyle,
    this.prevMonthDayBorderColor = Colors.transparent,
    this.thisMonthDayBorderColor = Colors.transparent,
    this.nextMonthDayBorderColor = Colors.transparent,
    this.dayPadding = 2,
    this.height = double.infinity,
    this.width = double.infinity,
    this.todayTextStyle,
    this.inactiveTodayTextStyle,
    this.dayButtonColor = Colors.transparent,
    this.todayBorderColor = Colors.red,
    this.todayButtonColor = Colors.red,
    this.selectedDateTime,
    this.targetDateTime,
    this.selectedDayTextStyle,
    this.selectedDayBorderColor = Colors.green,
    this.selectedDayButtonColor = Colors.green,
    this.daysHaveCircularBorder,
    this.daysBorderRadius,
    this.disableDayPressed = false,
    this.onDayPressed,
    this.weekdayTextStyle = const TextStyle(),
    this.iconColor = Colors.blueAccent,
    this.headerTextStyle,
    this.headerText,
    this.weekendTextStyle,
    this.prevWeekendTextStyle,
    this.nextWeekendTextStyle,
    this.markedDatesMap,
    this.markedDateShowIcon = false,
    this.markedDateIconBorderColor,
    this.markedDateIconMaxShown = 2,
    this.markedDateIconMargin = 5,
    this.markedDateIconOffset = 5,
    this.markedDateIconBuilder,
    this.markedDateMoreShowTotal,
    this.markedDateMoreCustomDecoration,
    this.markedDateCustomShapeBorder,
    this.markedDateCustomTextStyle,
    this.markedDateMoreCustomTextStyle,
    this.markedDateWidget,
    this.multipleMarkedDates,
    this.headerMargin = const EdgeInsets.symmetric(vertical: 16),
    this.childAspectRatio = 1,
    this.weekDayMargin = const EdgeInsets.only(bottom: 4),
    this.weekDayPadding = EdgeInsets.zero,
    this.weekDayBackgroundColor = Colors.transparent,
    this.customWeekDayBuilder,
    this.customDayBuilder,
    this.showWeekDays = true,
    this.capitalizeWeekDays = false,
    this.weekFormat = false,
    this.showHeader = true,
    this.showHeaderButton = true,
    this.leftButtonIcon,
    this.rightButtonIcon,
    this.customGridViewPhysics,
    this.onCalendarChanged,
    this.locale = 'en',
    this.firstDayOfWeek,
    this.minSelectedDate,
    this.maxSelectedDate,
    this.inactiveDates = const <DateTime>[],
    this.inactiveDaysTextStyle,
    this.inactivePrevDaysTextStyle,
    this.inactiveNextDaysTextStyle,
    this.inactiveWeekendTextStyle,
    this.inactivePrevWeekendTextStyle,
    this.inactiveNextWeekendTextStyle,
    this.headerTitleTouchable = false,
    this.onHeaderTitlePressed,
    this.onLeftArrowPressed,
    this.onRightArrowPressed,
    this.weekDayFormat = WeekdayFormat.short,
    this.staticSixWeekFormat = false,
    this.isScrollable = true,
    this.scrollDirection = Axis.horizontal,
    this.showOnlyCurrentMonthDate = false,
    this.pageSnapping = false,
    this.onDayLongPressed,
    this.dayCrossAxisAlignment = CrossAxisAlignment.center,
    this.dayMainAxisAlignment = MainAxisAlignment.center,
    this.showIconBehindDayText = false,
    this.pageScrollPhysics = const ScrollPhysics(),
    this.shouldShowTransform = true,
    this.maxDot = 5,
  });

  final double viewportFraction;
  final TextStyle? prevDaysTextStyle;
  final TextStyle? daysTextStyle;
  final TextStyle? nextDaysTextStyle;
  final Color prevMonthDayBorderColor;
  final Color thisMonthDayBorderColor;
  final Color nextMonthDayBorderColor;
  final double dayPadding;
  final double height;
  final double width;
  final TextStyle? todayTextStyle;
  final TextStyle? inactiveTodayTextStyle;
  final Color dayButtonColor;
  final Color todayBorderColor;
  final Color todayButtonColor;
  final DateTime? selectedDateTime;
  final DateTime? targetDateTime;
  final TextStyle? selectedDayTextStyle;
  final Color selectedDayButtonColor;
  final Color selectedDayBorderColor;
  final bool? daysHaveCircularBorder;
  final BorderRadiusGeometry? daysBorderRadius;
  final bool disableDayPressed;
  final OnDayPressed<T>? onDayPressed;
  final TextStyle? weekdayTextStyle;
  final Color iconColor;
  final TextStyle? headerTextStyle;
  final String? headerText;
  final TextStyle? weekendTextStyle;
  final TextStyle? prevWeekendTextStyle;
  final TextStyle? nextWeekendTextStyle;

  final EventList<T>? markedDatesMap;

  /// Change `makredDateWidget` when `markedDateShowIcon` is set to false.
  final Widget? markedDateWidget;

  /// Change `OutlinedBorder` when `markedDateShowIcon` is set to false.
  final OutlinedBorder? markedDateCustomShapeBorder;

  /// Change `TextStyle` when `markedDateShowIcon` is set to false.
  final TextStyle? markedDateCustomTextStyle;

  /// Icon will overlap the [Day] widget when `markedDateShowIcon` is set to true.
  /// This will also make below parameters work.
  final bool markedDateShowIcon;
  final Color? markedDateIconBorderColor;
  final int markedDateIconMaxShown;
  final double markedDateIconMargin;
  final double markedDateIconOffset;
  final MarkedDateIconBuilder<T>? markedDateIconBuilder;

  /// null - no indicator, true - show the total events, false - show the total of hidden events
  final bool? markedDateMoreShowTotal;
  final Decoration? markedDateMoreCustomDecoration;
  final TextStyle? markedDateMoreCustomTextStyle;
  final EdgeInsets headerMargin;
  final double childAspectRatio;
  final EdgeInsets weekDayMargin;
  final EdgeInsets weekDayPadding;
  final WeekdayBuilder? customWeekDayBuilder;
  final DayBuilder? customDayBuilder;
  final Color weekDayBackgroundColor;
  final bool weekFormat;
  final bool showWeekDays;
  final bool capitalizeWeekDays;
  final bool showHeader;
  final bool showHeaderButton;
  final MultipleMarkedDates? multipleMarkedDates;
  final Widget? leftButtonIcon;
  final Widget? rightButtonIcon;
  final ScrollPhysics? customGridViewPhysics;
  final OnCalendarChanged? onCalendarChanged;
  final String locale;
  final int? firstDayOfWeek;
  final DateTime? minSelectedDate;
  final DateTime? maxSelectedDate;
  final List<DateTime> inactiveDates;
  final TextStyle? inactiveDaysTextStyle;
  final TextStyle? inactivePrevDaysTextStyle;
  final TextStyle? inactiveNextDaysTextStyle;
  final TextStyle? inactiveWeekendTextStyle;
  final TextStyle? inactivePrevWeekendTextStyle;
  final TextStyle? inactiveNextWeekendTextStyle;
  final bool headerTitleTouchable;
  final VoidCallback? onHeaderTitlePressed;
  final VoidCallback? onLeftArrowPressed;
  final VoidCallback? onRightArrowPressed;
  final WeekdayFormat weekDayFormat;
  final bool staticSixWeekFormat;
  final bool isScrollable;
  final Axis scrollDirection;
  final bool showOnlyCurrentMonthDate;
  final bool pageSnapping;
  final OnDayLongPressed? onDayLongPressed;
  final CrossAxisAlignment dayCrossAxisAlignment;
  final MainAxisAlignment dayMainAxisAlignment;
  final bool showIconBehindDayText;
  final ScrollPhysics pageScrollPhysics;
  final bool shouldShowTransform;

  ///Maximium number of dots to be shown
  final int maxDot;

  @override
  State<CalendarCarousel<T>> createState() => _CalendarState<T>();
}

enum WeekdayFormat {
  weekdays,
  standalone,
  short,
  standaloneShort,
  narrow,
  standaloneNarrow,
}

class _CalendarState<T extends EventInterface>
    extends State<CalendarCarousel<T>> {
  late PageController _controller;
  late List<DateTime> _dates;
  late List<List<DateTime>> _weeks;
  DateTime _selectedDate = DateTime.now();
  late DateTime _targetDate;
  int _startWeekday = 0;
  int _endWeekday = 0;
  late DateFormat _localeDate;
  int _pageNum = 0;
  late DateTime minDate;
  late DateTime maxDate;

  /// When FIRSTDAYOFWEEK is 0 in dart-intl, it represents Monday. However it is the second day in the arrays of Weekdays.
  /// Therefore we need to add 1 modulo 7 to pick the right weekday from intl. (cf. [GlobalMaterialLocalizations])
  late int firstDayOfWeek;

  /// If the setState called from this class, don't reload the selectedDate, but it should reload selected date if called from external class

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();

    minDate = widget.minSelectedDate ?? DateTime(2018);
    maxDate =
        widget.maxSelectedDate ??
        DateTime(
          DateTime.now().year + 1,
          DateTime.now().month,
          DateTime.now().day,
        );

    final DateTime? selectedDateTime = widget.selectedDateTime;
    if (selectedDateTime != null) {
      _selectedDate = selectedDateTime;
    }

    _init();

    /// setup pageController
    _controller = PageController(
      initialPage: this._pageNum,
      viewportFraction: widget.viewportFraction,

      /// width percentage
    );

    _localeDate = DateFormat.yMMM(widget.locale);
    firstDayOfWeek =
        widget.firstDayOfWeek ??
        (_localeDate.dateSymbols.FIRSTDAYOFWEEK + 1) % 7;

    _setDate();
  }

  @override
  void didUpdateWidget(final CalendarCarousel<T> oldWidget) {
    if (widget.targetDateTime != null && widget.targetDateTime != _targetDate) {
      _init();
      _setDate(page: _pageNum);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _init() {
    final DateTime? targetDateTime = widget.targetDateTime;
    if (targetDateTime != null) {
      if (targetDateTime.difference(minDate).inDays < 0) {
        _targetDate = minDate;
      } else if (targetDateTime.difference(maxDate).inDays > 0) {
        _targetDate = maxDate;
      } else {
        _targetDate = targetDateTime;
      }
    } else {
      _targetDate = _selectedDate;
    }
    if (widget.weekFormat) {
      _pageNum = _targetDate.difference(_firstDayOfWeek(minDate)).inDays ~/ 7;
    } else {
      _pageNum =
          (_targetDate.year - minDate.year) * 12 +
          _targetDate.month -
          minDate.month;
    }
  }

  @override
  Widget build(final BuildContext context) {
    final String? headerText = widget.headerText;
    return Column(
      children: <Widget>[
        CalendarHeader(
          showHeader: widget.showHeader,
          headerMargin: widget.headerMargin,
          headerTitle:
              headerText ??
              (widget.weekFormat
                  ? _localeDate.format(this._weeks[this._pageNum].first)
                  : _localeDate.format(this._dates[this._pageNum])),
          headerTextStyle: widget.headerTextStyle,
          showHeaderButtons: widget.showHeaderButton,
          headerIconColor: widget.iconColor,
          leftButtonIcon: widget.leftButtonIcon,
          rightButtonIcon: widget.rightButtonIcon,
          onLeftButtonPressed: () {
            widget.onLeftArrowPressed?.call();

            if (this._pageNum > 0) {
              _setDate(page: this._pageNum - 1);
            }
          },
          onRightButtonPressed: () {
            widget.onRightArrowPressed?.call();

            if (widget.weekFormat) {
              if (this._weeks.length - 1 > this._pageNum) {
                _setDate(page: this._pageNum + 1);
              }
            } else {
              if (this._dates.length - 1 > this._pageNum) {
                _setDate(page: this._pageNum + 1);
              }
            }
          },
          onHeaderTitlePressed:
              widget.headerTitleTouchable
                  ? () {
                    final VoidCallback? onHeaderTitlePressed =
                        widget.onHeaderTitlePressed;
                    if (onHeaderTitlePressed != null) {
                      onHeaderTitlePressed();
                    } else {
                      _selectDateFromPicker();
                    }
                  }
                  : null,
        ),
        WeekdayRow(
          firstDayOfWeek,
          widget.customWeekDayBuilder,
          showWeekdays: widget.showWeekDays,
          capitalizeWeekDays: widget.capitalizeWeekDays,
          weekdayFormat: widget.weekDayFormat,
          weekdayMargin: widget.weekDayMargin,
          weekdayPadding: widget.weekDayPadding,
          weekdayBackgroundColor: widget.weekDayBackgroundColor,
          weekdayTextStyle: widget.weekdayTextStyle,
          localeDate: _localeDate,
        ),
        SizedBox(
          width: widget.width,
          height: widget.height,
          child: PageView.builder(
            itemCount:
                widget.weekFormat ? this._weeks.length : this._dates.length,
            physics:
                widget.isScrollable
                    ? widget.pageScrollPhysics
                    : const NeverScrollableScrollPhysics(),
            scrollDirection: widget.scrollDirection,
            onPageChanged: (final int index) {
              this._setDate(page: index, shouldJump: false);
            },
            controller: _controller,
            itemBuilder: (final BuildContext context, final int index) {
              return widget.weekFormat ? weekBuilder(index) : builder(index);
            },
            pageSnapping: widget.pageSnapping,
          ),
        ),
      ],
    );
  }

  Widget getDefaultDayContainer(
    final bool isSelectable,
    final int index,
    final bool isSelectedDay,
    final bool isToday,
    final bool isPrevMonthDay,
    final TextStyle? textStyle,
    final TextStyle defaultTextStyle,
    final bool isNextMonthDay,
    final bool isThisMonthDay,
    final DateTime now,
  ) {
    return SizedBox.expand(
      child: Row(
        crossAxisAlignment: widget.dayCrossAxisAlignment,
        mainAxisAlignment: widget.dayMainAxisAlignment,
        children: <Widget>[
          DefaultTextStyle(
            style: getDefaultDayStyle(
              isSelectable,
              index,
              isSelectedDay,
              isToday,
              isPrevMonthDay,
              textStyle,
              defaultTextStyle,
              isNextMonthDay,
              isThisMonthDay,
            ),
            child: Text(
              '${now.day}',
              semanticsLabel: now.day.toString(),
              style: getDayStyle(
                isSelectable,
                index,
                isSelectedDay,
                isToday,
                isPrevMonthDay,
                textStyle,
                defaultTextStyle,
                isNextMonthDay,
                isThisMonthDay,
                now,
              ),
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget renderDay(
    final bool isSelectable,
    final int index,
    final bool isSelectedDay,
    final bool isToday,
    final bool isPrevMonthDay,
    final TextStyle? textStyle,
    final TextStyle defaultTextStyle,
    final bool isNextMonthDay,
    final bool isThisMonthDay,
    final DateTime now,
  ) {
    // If day is in Multiple selection mode, get its color
    final bool isMultipleMarked =
        widget.multipleMarkedDates?.isMarked(now) ?? false;
    final Color? multipleMarkedColor = widget.multipleMarkedDates?.getColor(
      now,
    );

    final EventList<T>? markedDatesMap = widget.markedDatesMap;
    return Container(
      margin: EdgeInsets.all(widget.dayPadding),
      child: GestureDetector(
        onLongPress: () => _onDayLongPressed(now),
        child: TextButton(
          style: TextButton.styleFrom(
            shape:
                widget.markedDateCustomShapeBorder != null &&
                        markedDatesMap != null &&
                        markedDatesMap.getEvents(now).isNotEmpty
                    ? widget.markedDateCustomShapeBorder
                    : widget.daysHaveCircularBorder == null
                    ? const CircleBorder()
                    : widget.daysHaveCircularBorder ?? false
                    ? CircleBorder(
                      side: BorderSide(
                        color:
                            isSelectedDay
                                ? widget.selectedDayBorderColor
                                : isToday
                                ? widget.todayBorderColor
                                : isPrevMonthDay
                                ? widget.prevMonthDayBorderColor
                                : isNextMonthDay
                                ? widget.nextMonthDayBorderColor
                                : widget.thisMonthDayBorderColor,
                      ),
                    )
                    : RoundedRectangleBorder(
                      borderRadius:
                          widget.daysBorderRadius ?? BorderRadius.zero,
                      side: BorderSide(
                        color:
                            isSelectedDay
                                ? widget.selectedDayBorderColor
                                : isToday
                                ? widget.todayBorderColor
                                : isPrevMonthDay
                                ? widget.prevMonthDayBorderColor
                                : isNextMonthDay
                                ? widget.nextMonthDayBorderColor
                                : widget.thisMonthDayBorderColor,
                      ),
                    ),
            backgroundColor:
                isSelectedDay
                    ? widget.selectedDayButtonColor
                    : isToday
                    ? widget.todayButtonColor
                    // If day is in Multiple selection mode, apply a different color
                    : isMultipleMarked
                    ? multipleMarkedColor
                    : widget.dayButtonColor,
            padding: EdgeInsets.all(widget.dayPadding),
          ),
          onPressed:
              widget.disableDayPressed || !isSelectable
                  ? null
                  : () => _onDayPressed(now),
          child: Stack(
            children:
                widget.showIconBehindDayText
                    ? <Widget>[
                      if (widget.markedDatesMap != null)
                        _renderMarkedMapContainer(now)
                      else
                        const SizedBox.shrink(),
                      getDayContainer(
                        isSelectable,
                        index,
                        isSelectedDay,
                        isToday,
                        isPrevMonthDay,
                        textStyle,
                        defaultTextStyle,
                        isNextMonthDay,
                        isThisMonthDay,
                        now,
                      ),
                    ]
                    : <Widget>[
                      getDayContainer(
                        isSelectable,
                        index,
                        isSelectedDay,
                        isToday,
                        isPrevMonthDay,
                        textStyle,
                        defaultTextStyle,
                        isNextMonthDay,
                        isThisMonthDay,
                        now,
                      ),
                      if (widget.markedDatesMap != null)
                        _renderMarkedMapContainer(now)
                      else
                        const SizedBox.shrink(),
                    ],
          ),
        ),
      ),
    );
  }

  AnimatedBuilder builder(final int slideIndex) {
    _startWeekday = _dates[slideIndex].weekday - firstDayOfWeek;
    if (_startWeekday == 7) {
      _startWeekday = 0;
    }
    _endWeekday =
        DateTime(
          _dates[slideIndex].year,
          _dates[slideIndex].month + 1,
        ).weekday -
        firstDayOfWeek;
    final double screenWidth = MediaQuery.of(context).size.width;
    final int totalItemCount =
        widget.staticSixWeekFormat
            ? 42
            : DateTime(
                  _dates[slideIndex].year,
                  _dates[slideIndex].month + 1,
                  0,
                ).day +
                _startWeekday +
                (7 - _endWeekday);
    final int year = _dates[slideIndex].year;
    final int month = _dates[slideIndex].month;

    return AnimatedBuilder(
      animation: _controller,
      builder: (final BuildContext context, final Widget? child) {
        if (!widget.shouldShowTransform) {
          return child!;
        }
        double value = 1;
        if (_controller.position.haveDimensions) {
          value = _controller.page! - slideIndex;
          value = (1 - (value.abs() * .5)).clamp(0, 1);
        }

        return Center(
          child: SizedBox(
            height: Curves.easeOut.transform(value) * widget.height,
            width: Curves.easeOut.transform(value) * screenWidth,
            child: child,
          ),
        );
      },
      child: GridView.count(
        physics: widget.customGridViewPhysics,
        crossAxisCount: 7,
        childAspectRatio: widget.childAspectRatio,
        padding: EdgeInsets.zero,
        children: List<Widget>.generate(
          totalItemCount,

          /// last day of month + weekday
          (final int index) {
            final DateTime? selectedDateTime = widget.selectedDateTime;
            final bool isToday =
                DateTime.now().day == index + 1 - _startWeekday &&
                DateTime.now().month == month &&
                DateTime.now().year == year;
            final bool isSelectedDay =
                selectedDateTime != null &&
                selectedDateTime.year == year &&
                selectedDateTime.month == month &&
                selectedDateTime.day == index + 1 - _startWeekday;
            final bool isPrevMonthDay = index < _startWeekday;
            final bool isNextMonthDay =
                index >= (DateTime(year, month + 1, 0).day) + _startWeekday;
            final bool isThisMonthDay = !isPrevMonthDay && !isNextMonthDay;

            DateTime now = DateTime(year, month);
            TextStyle? textStyle;
            TextStyle defaultTextStyle;
            if (isPrevMonthDay && !widget.showOnlyCurrentMonthDate) {
              now = now.subtract(Duration(days: _startWeekday - index));
              textStyle = widget.prevDaysTextStyle;
              defaultTextStyle = defaultPrevDaysTextStyle;
            } else if (isThisMonthDay) {
              now = DateTime(year, month, index + 1 - _startWeekday);
              textStyle =
                  isSelectedDay
                      ? widget.selectedDayTextStyle
                      : isToday
                      ? widget.todayTextStyle
                      : widget.daysTextStyle;
              defaultTextStyle =
                  isSelectedDay
                      ? defaultSelectedDayTextStyle
                      : isToday
                      ? defaultTodayTextStyle
                      : defaultDaysTextStyle;
            } else if (!widget.showOnlyCurrentMonthDate) {
              now = DateTime(year, month, index + 1 - _startWeekday);
              textStyle = widget.nextDaysTextStyle;
              defaultTextStyle = defaultNextDaysTextStyle;
            } else {
              return const SizedBox.shrink();
            }
            final EventList<T>? markedDatesMap = widget.markedDatesMap;
            if (widget.markedDateCustomTextStyle != null &&
                markedDatesMap != null &&
                markedDatesMap.getEvents(now).isNotEmpty) {
              textStyle = widget.markedDateCustomTextStyle;
            }
            bool isSelectable = true;
            if (now.millisecondsSinceEpoch < minDate.millisecondsSinceEpoch) {
              isSelectable = false;
            } else if (now.millisecondsSinceEpoch >
                maxDate.millisecondsSinceEpoch) {
              isSelectable = false;
            } else if (widget.inactiveDates.any(
              (final DateTime inactiveDate) => inactiveDate.isSameDay(now),
            )) {
              isSelectable = false;
            }

            return renderDay(
              isSelectable,
              index,
              isSelectedDay,
              isToday,
              isPrevMonthDay,
              textStyle,
              defaultTextStyle,
              isNextMonthDay,
              isThisMonthDay,
              now,
            );
          },
        ),
      ),
    );
  }

  AnimatedBuilder weekBuilder(final int slideIndex) {
    final double screenWidth = MediaQuery.of(context).size.width;
    List<DateTime> weekDays = _weeks[slideIndex];

    weekDays =
        weekDays
            .map(
              (final DateTime weekDay) =>
                  weekDay.add(Duration(days: firstDayOfWeek)),
            )
            .toList();

    return AnimatedBuilder(
      animation: _controller,
      builder: (final BuildContext context, final Widget? child) {
        double value = 1;
        if (_controller.position.haveDimensions) {
          value = _controller.page! - slideIndex;
          value = (1 - (value.abs() * .5)).clamp(0, 1);
        }

        return Center(
          child: SizedBox(
            height: Curves.easeOut.transform(value) * widget.height,
            width: Curves.easeOut.transform(value) * screenWidth,
            child: child,
          ),
        );
      },
      child: Stack(
        children: <Widget>[
          Positioned(
            child: SizedBox.expand(
              child: GridView.count(
                physics: widget.customGridViewPhysics,
                crossAxisCount: 7,
                childAspectRatio: widget.childAspectRatio,
                padding: EdgeInsets.zero,
                children: List<Widget>.generate(weekDays.length, (
                  final int index,
                ) {
                  /// last day of month + weekday
                  final bool isToday =
                      weekDays[index].day == DateTime.now().day &&
                      weekDays[index].month == DateTime.now().month &&
                      weekDays[index].year == DateTime.now().year;
                  final bool isSelectedDay =
                      this._selectedDate.year == weekDays[index].year &&
                      this._selectedDate.month == weekDays[index].month &&
                      this._selectedDate.day == weekDays[index].day;
                  final bool isPrevMonthDay =
                      weekDays[index].month < this._targetDate.month;
                  final bool isNextMonthDay =
                      weekDays[index].month > this._targetDate.month;
                  final bool isThisMonthDay =
                      !isPrevMonthDay && !isNextMonthDay;

                  final DateTime now = DateTime(
                    weekDays[index].year,
                    weekDays[index].month,
                    weekDays[index].day,
                  );
                  TextStyle? textStyle;
                  TextStyle defaultTextStyle;
                  if (isPrevMonthDay && !widget.showOnlyCurrentMonthDate) {
                    textStyle = widget.prevDaysTextStyle;
                    defaultTextStyle = defaultPrevDaysTextStyle;
                  } else if (isThisMonthDay) {
                    textStyle =
                        isSelectedDay
                            ? widget.selectedDayTextStyle
                            : isToday
                            ? widget.todayTextStyle
                            : widget.daysTextStyle;
                    defaultTextStyle =
                        isSelectedDay
                            ? defaultSelectedDayTextStyle
                            : isToday
                            ? defaultTodayTextStyle
                            : defaultDaysTextStyle;
                  } else if (!widget.showOnlyCurrentMonthDate) {
                    textStyle = widget.nextDaysTextStyle;
                    defaultTextStyle = defaultNextDaysTextStyle;
                  } else {
                    return const SizedBox.shrink();
                  }
                  bool isSelectable = true;
                  if (now.millisecondsSinceEpoch <
                      minDate.millisecondsSinceEpoch) {
                    isSelectable = false;
                  } else if (now.millisecondsSinceEpoch >
                      maxDate.millisecondsSinceEpoch) {
                    isSelectable = false;
                  } else if (widget.inactiveDates.any(
                    (final DateTime inactiveDate) =>
                        inactiveDate.isSameDay(now),
                  )) {
                    isSelectable = false;
                  }
                  return renderDay(
                    isSelectable,
                    index,
                    isSelectedDay,
                    isToday,
                    isPrevMonthDay,
                    textStyle,
                    defaultTextStyle,
                    isNextMonthDay,
                    isThisMonthDay,
                    now,
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<DateTime> _getDaysInWeek([DateTime? selectedDate]) {
    selectedDate ??= DateTime.now();

    final DateTime firstDayOfCurrentWeek = _firstDayOfWeek(selectedDate);
    final DateTime lastDayOfCurrentWeek = _lastDayOfWeek(selectedDate);

    return _daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek).toList();
  }

  DateTime _firstDayOfWeek(final DateTime date) {
    final DateTime day = _createUTCMiddayDateTime(date);
    return day.subtract(Duration(days: date.weekday % 7));
  }

  DateTime _lastDayOfWeek(final DateTime date) {
    final DateTime day = _createUTCMiddayDateTime(date);
    return day.add(Duration(days: 7 - day.weekday % 7));
  }

  DateTime _createUTCMiddayDateTime(final DateTime date) {
    // Magic const: 12 is to maintain compatibility with date_utils
    return DateTime.utc(date.year, date.month, date.day, 12);
  }

  Iterable<DateTime> _daysInRange(final DateTime start, final DateTime end) {
    Duration offset = start.timeZoneOffset;

    return List<int>.generate(
      end.difference(start).inDays,
      (final int i) => i + 1,
    ).map((final int i) {
      DateTime d = start.add(Duration(days: i - 1));

      final Duration timeZoneDiff = d.timeZoneOffset - offset;
      if (timeZoneDiff.inSeconds != 0) {
        offset = d.timeZoneOffset;
        d = d.subtract(Duration(seconds: timeZoneDiff.inSeconds));
      }
      return d;
    });
  }

  void _onDayLongPressed(final DateTime picked) {
    widget.onDayLongPressed?.call(picked);
  }

  void _onDayPressed(final DateTime picked) {
    if (picked.millisecondsSinceEpoch < minDate.millisecondsSinceEpoch) {
      return;
    }
    if (picked.millisecondsSinceEpoch > maxDate.millisecondsSinceEpoch) {
      return;
    }
    if (widget.inactiveDates.any(
      (final DateTime inactiveDate) => inactiveDate.isSameDay(picked),
    )) {
      return;
    }

    setState(() {
      _selectedDate = picked;
    });
    widget.onDayPressed?.call(
      picked,
      widget.markedDatesMap?.getEvents(picked) ?? <T>[],
    );
  }

  Future<void> _selectDateFromPicker() async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: minDate,
      lastDate: maxDate,
    );

    if (selected != null) {
      // updating selected date range based on selected week
      setState(() {
        _selectedDate = selected;
      });
      widget.onDayPressed?.call(
        selected,
        widget.markedDatesMap?.getEvents(selected) ?? <T>[],
      );
    }
  }

  void _setDatesAndWeeks() {
    /// Setup default calendar format
    final List<DateTime> date = <DateTime>[];
    int currentDateIndex = 0;
    for (
      int cnt = 0;
      0 >=
          DateTime(
            minDate.year,
            minDate.month + cnt,
          ).difference(DateTime(maxDate.year, maxDate.month)).inDays;
      cnt++
    ) {
      date.add(DateTime(minDate.year, minDate.month + cnt));
      if (0 ==
          date.last
              .difference(
                DateTime(this._targetDate.year, this._targetDate.month),
              )
              .inDays) {
        currentDateIndex = cnt;
      }
    }

    /// Setup week-only format
    final List<List<DateTime>> week = <List<DateTime>>[];
    for (
      int cnt = 0;
      0 >=
          minDate
              .add(Duration(days: 7 * cnt))
              .difference(maxDate.add(const Duration(days: 7)))
              .inDays;
      cnt++
    ) {
      week.add(_getDaysInWeek(minDate.add(Duration(days: 7 * cnt))));
    }

    _startWeekday = date[currentDateIndex].weekday - firstDayOfWeek;
    /*if (widget.showOnlyCurrentMonthDate) {
      _startWeekday--;
    }*/
    if ( /*widget.showOnlyCurrentMonthDate && */ _startWeekday == 7) {
      _startWeekday = 0;
    }
    _endWeekday =
        DateTime(
          date[currentDateIndex].year,
          date[currentDateIndex].month + 1,
        ).weekday -
        firstDayOfWeek;
    this._dates = date;
    this._weeks = week;
    //        this._selectedDate = widget.selectedDateTime != null
    //            ? widget.selectedDateTime
    //            : DateTime.now();
  }

  void _setDate({final bool shouldJump = true, final int page = -1}) {
    if (page == -1) {
      setState(_setDatesAndWeeks);
    } else {
      if (widget.weekFormat) {
        setState(() {
          this._pageNum = page;
          this._targetDate = this._weeks[page].first;
        });

        if (shouldJump) {
          _controller.animateToPage(
            page,
            duration: const Duration(milliseconds: 1),
            curve: const Threshold(0),
          );
        }
      } else {
        setState(() {
          this._pageNum = page;
          this._targetDate = this._dates[page];
          _startWeekday = _dates[page].weekday - firstDayOfWeek;
          _endWeekday = _lastDayOfWeek(_dates[page]).weekday - firstDayOfWeek;
        });

        if (shouldJump) {
          _controller.animateToPage(
            page,
            duration: const Duration(milliseconds: 1),
            curve: const Threshold(0),
          );
        }
      }

      //call callback
      final OnCalendarChanged? onCalendarChanged = widget.onCalendarChanged;
      if (onCalendarChanged != null) {
        WidgetsBinding.instance.addPostFrameCallback((final _) {
          onCalendarChanged(
            !widget.weekFormat
                ? this._dates[page]
                : this._weeks[page][firstDayOfWeek],
          );
        });
      }
    }
  }

  Widget _renderMarkedMapContainer(final DateTime now) {
    if (widget.markedDateShowIcon) {
      return Stack(children: _renderMarkedMap(now));
    } else {
      return Container(
        height: double.infinity,
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: _renderMarkedMap(now),
        ),
      );
    }
  }

  List<Widget> _renderMarkedMap(final DateTime now) {
    final List<T> markedEvents = widget.markedDatesMap?.getEvents(now) ?? <T>[];
    final MarkedDateIconBuilder<T>? markedDateIconBuilder =
        widget.markedDateIconBuilder;
    final Widget? markedDateWidget = widget.markedDateWidget;
    final bool? markedDateMoreShowTotal = widget.markedDateMoreShowTotal;
    final TextStyle? markedDateMoreCustomTextStyle =
        widget.markedDateMoreCustomTextStyle;
    final double markedDateIconMargin = widget.markedDateIconMargin;
    final bool markedDateShowIcon = widget.markedDateShowIcon;
    final int markedDateIconMaxShown = widget.markedDateIconMaxShown;
    final double markedDateIconOffset = widget.markedDateIconOffset;
    final Decoration? markedDateMoreCustomDecoration =
        widget.markedDateMoreCustomDecoration;

    if (markedEvents.isNotEmpty) {
      final List<Widget> tmp = <Widget>[];
      int count = 0;
      int eventIndex = 0;
      double offset = 0;
      final double padding = markedDateIconMargin;
      for (final T event in markedEvents) {
        if (markedDateShowIcon) {
          if (tmp.isNotEmpty && tmp.length < markedDateIconMaxShown) {
            offset += markedDateIconOffset;
          }
          if (tmp.length < markedDateIconMaxShown &&
              markedDateIconBuilder != null) {
            tmp.add(
              Center(
                child: Container(
                  padding: EdgeInsets.only(
                    top: padding + offset,
                    left: padding + offset,
                    right: padding - offset,
                    bottom: padding - offset,
                  ),
                  width: double.infinity,
                  height: double.infinity,
                  child: markedDateIconBuilder(event),
                ),
              ),
            );
          } else {
            count++;
          }
          if (count > 0 && markedDateMoreShowTotal != null) {
            tmp.add(
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  width: markedDateMoreShowTotal ? 18 : null,
                  height: markedDateMoreShowTotal ? 18 : null,
                  decoration:
                      markedDateMoreCustomDecoration ??
                      const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(1000)),
                      ),
                  child: Center(
                    child: Text(
                      markedDateMoreShowTotal
                          ? (count + markedDateIconMaxShown).toString()
                          : ('$count+'),
                      semanticsLabel:
                          markedDateMoreShowTotal
                              ? (count + markedDateIconMaxShown).toString()
                              : ('$count+'),
                      style:
                          markedDateMoreCustomTextStyle ??
                          const TextStyle(
                            fontSize: 9,
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                  ),
                ),
              ),
            );
          }
        } else {
          //max 5 dots
          if (eventIndex < widget.maxDot) {
            Widget? widget;

            if (markedDateIconBuilder != null) {
              widget = markedDateIconBuilder(event);
            }

            if (widget != null) {
              tmp.add(widget);
            } else {
              final Widget? dot = event.getDot();
              if (dot != null) {
                tmp.add(dot);
              } else if (markedDateWidget != null) {
                tmp.add(markedDateWidget);
              } else {
                tmp.add(defaultMarkedDateWidget);
              }
            }
          }
        }

        eventIndex++;
      }
      return tmp;
    }
    return <Widget>[];
  }

  TextStyle getDefaultDayStyle(
    final bool isSelectable,
    final int index,
    final bool isSelectedDay,
    final bool isToday,
    final bool isPrevMonthDay,
    final TextStyle? textStyle,
    final TextStyle defaultTextStyle,
    final bool isNextMonthDay,
    final bool isThisMonthDay,
  ) {
    return !isSelectable
        ? defaultInactiveDaysTextStyle
        : (_localeDate.dateSymbols.WEEKENDRANGE.contains(
              (index - 1 + firstDayOfWeek) % 7,
            )) &&
            !isSelectedDay &&
            !isToday
        ? (isPrevMonthDay
            ? defaultPrevDaysTextStyle
            : isNextMonthDay
            ? defaultNextDaysTextStyle
            : isSelectable
            ? defaultWeekendTextStyle
            : defaultInactiveWeekendTextStyle)
        : isToday
        ? defaultTodayTextStyle
        : isSelectable && textStyle != null
        ? textStyle
        : defaultTextStyle;
  }

  TextStyle? getDayStyle(
    final bool isSelectable,
    final int index,
    final bool isSelectedDay,
    final bool isToday,
    final bool isPrevMonthDay,
    final TextStyle? textStyle,
    final TextStyle defaultTextStyle,
    final bool isNextMonthDay,
    final bool isThisMonthDay,
    final DateTime now,
  ) {
    // If day is in multiple selection get its style(if available)
    final bool isMultipleMarked =
        widget.multipleMarkedDates?.isMarked(now) ?? false;
    final TextStyle? mutipleMarkedTextStyle = widget.multipleMarkedDates
        ?.getTextStyle(now);

    return isSelectedDay && widget.selectedDayTextStyle != null
        ? widget.selectedDayTextStyle
        : isMultipleMarked
        ? mutipleMarkedTextStyle
        : (_localeDate.dateSymbols.WEEKENDRANGE.contains(
              (index - 1 + firstDayOfWeek) % 7,
            )) &&
            !isSelectedDay &&
            isThisMonthDay &&
            !isToday
        ? (isSelectable
            ? isPrevMonthDay
                ? widget.prevWeekendTextStyle
                : isNextMonthDay
                ? widget.nextWeekendTextStyle
                : widget.weekendTextStyle
            : isPrevMonthDay
            ? widget.inactivePrevWeekendTextStyle
            : isNextMonthDay
            ? widget.inactiveNextWeekendTextStyle
            : widget.inactiveWeekendTextStyle)
        : (isSelectable
            ? isPrevMonthDay
                ? widget.prevDaysTextStyle
                : isNextMonthDay
                ? widget.nextDaysTextStyle
                : isToday
                ? widget.todayTextStyle
                : widget.daysTextStyle
            : isPrevMonthDay
            ? widget.inactivePrevDaysTextStyle
            : isNextMonthDay
            ? widget.inactiveNextDaysTextStyle
            : isToday
            ? widget.inactiveTodayTextStyle
            : widget.inactiveDaysTextStyle);
  }

  Widget getDayContainer(
    final bool isSelectable,
    final int index,
    final bool isSelectedDay,
    final bool isToday,
    final bool isPrevMonthDay,
    final TextStyle? textStyle,
    final TextStyle defaultTextStyle,
    final bool isNextMonthDay,
    final bool isThisMonthDay,
    final DateTime now,
  ) {
    final DayBuilder? customDayBuilder = widget.customDayBuilder;

    Widget? dayContainer;
    if (customDayBuilder != null) {
      final TextStyle appTextStyle = DefaultTextStyle.of(context).style;

      final TextStyle? dayStyle = getDayStyle(
        isSelectable,
        index,
        isSelectedDay,
        isToday,
        isPrevMonthDay,
        textStyle,
        defaultTextStyle,
        isNextMonthDay,
        isThisMonthDay,
        now,
      );

      final TextStyle styleForBuilder = appTextStyle.merge(dayStyle);

      dayContainer = customDayBuilder(
        isSelectable,
        index,
        isSelectedDay,
        isToday,
        isPrevMonthDay,
        styleForBuilder,
        isNextMonthDay,
        isThisMonthDay,
        now,
      );
    }

    return dayContainer ??
        getDefaultDayContainer(
          isSelectable,
          index,
          isSelectedDay,
          isToday,
          isPrevMonthDay,
          textStyle,
          defaultTextStyle,
          isNextMonthDay,
          isThisMonthDay,
          now,
        );
  }
}

extension on DateTime {
  bool isSameDay(final DateTime otherDate) {
    return otherDate.year == year &&
        otherDate.month == month &&
        otherDate.day == day;
  }
}
