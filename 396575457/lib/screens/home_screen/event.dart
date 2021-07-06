import 'package:flutter/material.dart';

import '../create_event_screen/message.dart';

class Event {
  int indexOfAvatar;
  bool isSelected = false;
  String title;

  List<Message> messages;
  CircleAvatar avatar;

  Event({this.title, this.avatar, this.messages, this.indexOfAvatar});

  String get titleString {
    return title;
  }

  List<Message> get messagesData {
    return messages;
  }

  CircleAvatar get circleAvatar {
    return avatar;
  }

  bool get isEventSelected {
    return isSelected;
  }

  void newMessageAdd(String message) => messages.add(Message(message));

  void inverseSelect() => isSelected = !isSelected;
}
