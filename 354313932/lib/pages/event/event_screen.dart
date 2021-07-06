import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../constants/constants.dart';
import '../../models/event.dart';
import '../../models/note.dart';

class EventScreen extends StatefulWidget {
  final Note note;
  final String title;

  const EventScreen({Key key, this.note, this.title}) : super(key: key);

  @override
  _EventScreenState createState() => _EventScreenState(note);
}

class _EventScreenState extends State<EventScreen> {
  final Note note;
  final TextEditingController eventController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final bool isEditingText = false;
  bool _isFavoriteEvents = false;
  bool _isEventSelected = false;
  bool _isEditing = false;
  int _selectedEventIndex = 0;

  _EventScreenState(this.note);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: _isEventSelected ? editingAppBar(_selectedEventIndex) : appBar(),
      body: body(),
    );
  }

  Column body() {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            reverse: true,
            itemCount: note.events.length,
            itemBuilder: (context, index) {
              _selectedEventIndex = index;
              final event = note.events[index];
              return Container(
                margin: EdgeInsets.only(left: kDefaultPadding * 2),
                padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                width: 100,
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.2,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(kDefaultPadding),
                    topLeft: Radius.circular(kDefaultPadding),
                    bottomLeft: Radius.circular(kDefaultPadding),
                    bottomRight: Radius.circular(kDefaultPadding * 1.5),
                  ),
                  child: Card(
                    elevation: 2,
                    color: note.events[index].isFavorite
                        ? Theme.of(context).accentColor
                        : Theme.of(context).primaryColor,
                    child: ListTile(
                      title: Text(
                        event.text,
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        event.time,
                        style: TextStyle(color: Colors.white),
                      ),
                      onLongPress: () {
                        _selectedEventIndex = index;
                        changeAppBar();
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: kDefaultPadding),
        Container(
          height: 60.0,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
          ),
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.widgets_outlined),
                color: Colors.blueGrey,
                onPressed: () {},
              ),
              Expanded(
                child: TextField(
                  controller: eventController,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    hintText: 'Type Something...',
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                icon: SvgPicture.asset(
                  'assets/icons/attach_photo.svg',
                  width: 24,
                  color: Colors.blueGrey,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(
                  Icons.send,
                  color: Colors.blueGrey,
                ),
                onPressed: () {
                  if (_isEditing) {
                    setState(() => editEventText(_selectedEventIndex));
                  } else {
                    setState(sendEvent);
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  AppBar editingAppBar(int index, {int count}) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      leading: IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          changeAppBar();
        },
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            changeAppBar();
            editEvent(index);
          },
        ),
        IconButton(
          icon: Icon(Icons.copy),
          onPressed: () {
            changeAppBar();
            copyEvent(index);
          },
        ),
        IconButton(
          icon: Icon(Icons.bookmark_border),
          onPressed: () {
            changeAppBar();
            markFavoriteEvent(index);
          },
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            changeAppBar();
            deleteEvent(context, index);
          },
        ),
      ],
    );
  }

  AppBar appBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: Theme.of(context).primaryColor,
      title: Text(widget.title),
      actions: [
        IconButton(
          icon: Icon(
            Icons.search,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: _isFavoriteEvents
              ? Icon(
                  Icons.bookmark,
                )
              : Icon(
                  Icons.bookmark_border_outlined,
                ),
          onPressed: showFavoriteEvents,
        ),
      ],
    );
  }

  void sendEvent() {
    if (eventController.text != '') {
      note.events.insert(
        0,
        Event(
          text: eventController.text,
          time: DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()),
          isSelected: false,
          isFavorite: false,
        ),
      );
    }
    eventController.clear();
  }

  void changeAppBar() {
    setState(() => _isEventSelected = !_isEventSelected);
  }

  void showFavoriteEvents() {
    setState(() => _isFavoriteEvents = !_isFavoriteEvents);
  }

  void editEvent(int index) {
    setState(() {
      _isEditing = true;
      eventController.text = note.events[index].text;
      eventController.selection = TextSelection.fromPosition(
        TextPosition(offset: eventController.text.length),
      );
      focusNode.requestFocus();
    });
  }

  void editEventText(int index) {
    note.events[index].text = eventController.text;
    eventController.clear();
    _isEditing = false;
  }

  void copyEvent(int index) =>
      Clipboard.setData(ClipboardData(text: note.events[index].text));

  void markFavoriteEvent(int index) {
    setState(() {
      if (!note.events[index].isFavorite) {
        note.events[index].isFavorite = true;
      } else {
        note.events[index].isFavorite = false;
      }
    });
  }

  void deleteEvent(BuildContext context, int index) {
    Widget cancelButton = MaterialButton(
      child: Text('Cancel'),
      onPressed: () => Navigator.of(context).pop(),
    );
    Widget submitButton = MaterialButton(
      child: Text('Submit'),
      onPressed: () => setState(
        () {
          note.events.removeAt(index);
          Navigator.of(context).pop();
        },
      ),
    );

    var alert = AlertDialog(
      title: const Text('Are you sure?'),
      content: Text('Would you like to delete selected note?'),
      actions: [
        cancelButton,
        submitButton,
      ],
    );

    showDialog(
      context: context,
      builder: (context) {
        return alert;
      },
    );
  }
}
