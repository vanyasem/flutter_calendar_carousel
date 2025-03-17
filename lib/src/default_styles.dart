import 'package:flutter/material.dart';

const TextStyle defaultHeaderTextStyle = TextStyle(
  fontSize: 20,
  color: Colors.blue,
);
const TextStyle defaultPrevDaysTextStyle = TextStyle(
  color: Colors.grey,
  fontSize: 14,
);
const TextStyle defaultNextDaysTextStyle = TextStyle(
  color: Colors.grey,
  fontSize: 14,
);
const TextStyle defaultDaysTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 14,
);
const TextStyle defaultTodayTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 14,
);
const TextStyle defaultSelectedDayTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 14,
);
const TextStyle defaultWeekdayTextStyle = TextStyle(
  color: Colors.deepOrange,
  fontSize: 14,
);
const TextStyle defaultWeekendTextStyle = TextStyle(
  color: Colors.pinkAccent,
  fontSize: 14,
);
const TextStyle defaultInactiveDaysTextStyle = TextStyle(
  color: Colors.black38,
  fontSize: 14,
);
final TextStyle defaultInactiveWeekendTextStyle = TextStyle(
  color: Colors.pinkAccent.withValues(alpha: 0.6),
  fontSize: 14,
);
final Widget defaultMarkedDateWidget = Container(
  margin: EdgeInsets.symmetric(horizontal: 1),
  color: Colors.blueAccent,
  height: 4,
  width: 4,
);
