import '../home_screen/event.dart';

class StatesCreatePage {
  int indexOfSelectedIcon;
  List<Event> eventList;

  StatesCreatePage(this.indexOfSelectedIcon, this.eventList);

  StatesCreatePage copyWith({
    List<Event> eventList,
    int indexOfSelectedIcon,
  }) {
    return StatesCreatePage(indexOfSelectedIcon ?? this.indexOfSelectedIcon,
        eventList ?? this.eventList);
  }
}
