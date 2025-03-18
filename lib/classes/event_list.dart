class EventList<T> {
  EventList({required this.events});

  Map<DateTime, List<T>> events;

  void add(final DateTime date, final T event) {
    final List<T>? eventsOfDate = events[date];
    if (eventsOfDate == null) {
      events[date] = <T>[event];
    } else {
      eventsOfDate.add(event);
    }
  }

  void addAll(final DateTime date, final List<T> events) {
    final List<T>? eventsOfDate = this.events[date];
    if (eventsOfDate == null) {
      this.events[date] = events;
    } else {
      eventsOfDate.addAll(events);
    }
  }

  bool remove(final DateTime date, final T event) {
    final List<T>? eventsOfDate = events[date];
    return eventsOfDate != null && eventsOfDate.remove(event);
  }

  List<T> removeAll(final DateTime date) {
    return events.remove(date) ?? <T>[];
  }

  void clear() {
    events.clear();
  }

  List<T> getEvents(final DateTime date) {
    return events[date] ?? <T>[];
  }
}
