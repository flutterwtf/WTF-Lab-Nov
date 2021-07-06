import 'package:flutter_bloc/flutter_bloc.dart';

import '../home_screen/event.dart';
import 'states_create_page.dart';

class CubitCreatePage extends Cubit<StatesCreatePage> {
  CubitCreatePage(StatesCreatePage state) : super(state);

  void addEvent(String text) {
    if (text.isNotEmpty) {
      var event = Event(
        title: text,
        messages: [],
        indexOfAvatar: state.indexOfSelectedIcon,
      );
      state.eventList.insert(0, event);
      emit(state.copyWith(eventList: state.eventList));
    }
  }

  void setIndexOfIcon(int index) {
    emit(state.copyWith(indexOfSelectedIcon: index));
  }
}
