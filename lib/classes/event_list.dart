class EventList<T> {
  EventList({
    required this.events,
  });

  Map<DateTime, List<T>> events;

  void add(final DateTime date, final T event) {
    final eventsOfDate = events[date];
    if (eventsOfDate == null) {
      events[date] = [event];
    } else {
      eventsOfDate.add(event);
    }
  }

  void addAll(final DateTime date, final List<T> events) {
    final eventsOfDate = this.events[date];
    if (eventsOfDate == null) {
      this.events[date] = events;
    } else {
      eventsOfDate.addAll(events);
    }
  }

  bool remove(final DateTime date, final T event) {
    final eventsOfDate = events[date];
    return eventsOfDate != null ? eventsOfDate.remove(event) : false;
  }

  List<T> removeAll(final DateTime date) {
    return events.remove(date) ?? [];
  }

  void clear() {
    events.clear();
  }

  List<T> getEvents(final DateTime date) {
    return events[date] ?? [];
  }
}
