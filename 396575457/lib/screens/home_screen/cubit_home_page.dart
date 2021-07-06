import 'package:flutter_bloc/flutter_bloc.dart';

import 'event.dart';
import 'event_data.dart';
import 'states_home_page.dart';

class CubitHomePage extends Cubit<StatesHomePage> {
  CubitHomePage(state) : super(state);

  void init() {
    state.eventList = EventData().eventsList;
    redrawingEventList();
  }

  void deleteEvent(int index) {
    state.eventList.removeAt(index);
    redrawingEventList();
  }

  void updateEvent(Event event) => emit(state.copyWidth(event: event));

  void updateEventsList(List<Event> eventsList) =>
      emit(state.copyWidth(eventList: eventsList));

  void redrawingEventList() =>
      emit(state.copyWidth(eventList: state.eventList));
}
