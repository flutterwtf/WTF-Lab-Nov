import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'event.dart';

class Note {
  final int _id;
  final IconData _icon;
  final String _title;
  final String _subtitle;
  bool isPinned;
  final List<Event> events = <Event>[];

  Note(this._id, this._icon, this._title, this._subtitle, this.isPinned);

  int get id => _id;

  IconData get icon => _icon;

  String get title => _title;

  String get subtitle => _subtitle;
}

class ListItemIcon<T> {
  bool isSelected;
  IconData icon;

  ListItemIcon(this.icon, {this.isSelected = false});
}

List<IconData> iconsList = [
  Icons.local_cafe,
  Icons.music_note,
  Icons.work,
  Icons.weekend,
  Icons.spa,
  Icons.local_movies,
  Icons.local_shipping,
  Icons.insert_emoticon,
  Icons.place,
  Icons.grade,
  Icons.nature_people,
  Icons.book_sharp
];

List<ListItemIcon<IconData>> icons = [];

List notes = [];
