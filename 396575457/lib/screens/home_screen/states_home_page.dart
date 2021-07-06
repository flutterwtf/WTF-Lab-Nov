import 'event.dart';

class StatesHomePage {
  List<Event> eventList;
  Event event;

  StatesHomePage({
    this.eventList,
    this.event,
  });

  StatesHomePage copyWidth({List<Event> eventList, Event event}) {
    return StatesHomePage(
      eventList: eventList ?? this.eventList,
      event: event ?? this.event,
    );
  }
}
