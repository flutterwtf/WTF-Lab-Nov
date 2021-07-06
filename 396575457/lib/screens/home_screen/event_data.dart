import 'event.dart';

class EventData {
  final List<Event> _data = <Event>[
    Event(title: 'FirstEvent', messages: [], indexOfAvatar: 0),
    Event(title: 'SecondEvent', messages: [], indexOfAvatar: 0),
    Event(title: 'ThirdEvent', messages: [], indexOfAvatar: 0),
  ];

  List<Event> get eventsList {
    return _data;
  }

  int get size {
    return _data.length;
  }

  void putAlreadyCreateEvent(Event event) {
    _data.add(event);
  }

  void put(String title) {
    _data.add(Event(title: title));
  }

  String getTitleByIndex(int i) {
    return _data.elementAt(i).titleString;
  }

  Event getEventByIndex(int i) {
    return _data[i];
  }

  void removeEventByIndex(int i) => _data.removeAt(i);
}
