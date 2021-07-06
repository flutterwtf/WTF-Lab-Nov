import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants/constants.dart';
import '../../models/note.dart';

class AddNoteScreen extends StatefulWidget {
  final String controller;
  final String operation;
  final int editingNote;
  final int editingIcon;

  const AddNoteScreen({
    Key key,
    this.controller,
    this.operation,
    this.editingNote,
    this.editingIcon,
  }) : super(key: key);

  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final controller = TextEditingController();
  bool isFieldEmpty = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('New note'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      floatingActionButton: floatingActionButton,
      body: body(context),
    );
  }

  FloatingActionButton get floatingActionButton {
    return FloatingActionButton(
      onPressed: () {
        if (controller.text != '') {
          for (var i = 0; i < iconsList.length; i++) {
            if (icons[i].isSelected == true) {
              if (widget.operation == 'edit') {
                notes[widget.editingNote] = Note(
                    widget.editingNote,
                    icons[i].icon,
                    controller.text,
                    DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()),
                    false);
              } else {
                notes.add(
                  Note(
                      notes.length,
                      icons[i].icon,
                      controller.text,
                      DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()),
                      false),
                );
              }
            }
          }
          Navigator.of(context).pop();
        }
      },
      child: const Icon(
        Icons.check,
        color: Colors.white,
      ),
    );
  }

  Column body(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.name,
            autofocus: false,
            decoration: InputDecoration(
              hintText: 'Enter note title',
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
          ),
        ),
        Expanded(
          child: GridView.count(
            crossAxisCount: 4,
            children: List.generate(iconsList.length, (index) {
              return Center(
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  radius: 30.0,
                  child: iconItem(icons[index]),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget iconItem(ListItemIcon icon) {
    var iconColor = Colors.white;
    return Center(
      child: GestureDetector(
        onTap: () => setState(
          () {
            for (var i = 0; i < icons.length; i++) {
              if (icons[i].isSelected == true) {
                icons[i].isSelected = false;
              }
            }
            if (icon.isSelected == true) {
              icon.isSelected = false;
            } else {
              icon.isSelected = true;
            }
          },
        ),
        child: Icon(
          icon.icon,
          size: 35,
          color: icon.isSelected ? Theme.of(context).accentColor : iconColor,
        ),
      ),
    );
  }
}
