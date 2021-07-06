import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../list_icons.dart';
import '../home_screen/event.dart';
import 'cubit_create_page.dart';
import 'states_create_page.dart';

class CreateNewPage extends StatefulWidget {
  final List<Event> eventList;
  final bool isEditing;
  final int index;

  CreateNewPage({Key key, this.eventList, this.isEditing, this.index})
      : super(key: key);

  @override
  _CreateNewPageState createState() =>
      _CreateNewPageState(eventList, isEditing, index);
}

class _CreateNewPageState extends State<CreateNewPage> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textController = TextEditingController();

  bool isEditing;
  int index;

  List<Event> eventList;
  CubitCreatePage _cubit;

  _CreateNewPageState(this.eventList, this.isEditing, this.index) {
    _cubit = CubitCreatePage(StatesCreatePage(0, eventList));
  }

  @override
  void initState() {
    if (isEditing) {
      _cubit.state.indexOfSelectedIcon = eventList[index].indexOfAvatar;
      _textController.text = eventList[index].title;
      _focusNode.requestFocus();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      cubit: _cubit,
      builder: (context, state) {
        return Scaffold(
          appBar: _appBar,
          body: _createNewPageBody,
          floatingActionButton: _floatingActionButton,
        );
      },
    );
  }

  AppBar get _appBar {
    return AppBar(
      title: Padding(
        padding: EdgeInsets.fromLTRB(35, 0, 0, 0),
        child: Text('Create a new event page'),
      ),
    );
  }

  Column get _createNewPageBody {
    return Column(
      children: <Widget>[
        _inputText,
        Expanded(
          child: _iconGrid,
        ),
      ],
    );
  }

  FloatingActionButton get _floatingActionButton {
    return FloatingActionButton(
      child: Icon(Icons.check),
      onPressed: () {
        isEditing ? _editPage() : _cubit.addEvent(_textController.text);
        if (_textController.text.isNotEmpty) {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget get _inputText {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 15, 10),
            child: TextField(
              controller: _textController,
              focusNode: _focusNode,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter event title',
              ),
            ),
          ),
        ),
      ],
    );
  }

  GridView get _iconGrid {
    return GridView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: listIcons.length,
      itemBuilder: (context, index) {
        return IconButton(
          icon: _circleAvatar(listIcons[index], index),
          onPressed: () => _cubit.setIndexOfIcon(index),
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 5.0,
        crossAxisSpacing: 5.0,
      ),
    );
  }

  CircleAvatar _circleAvatar(Icon icon, int index) {
    return CircleAvatar(
      child: icon,
      backgroundColor: index == _cubit.state.indexOfSelectedIcon
          ? Colors.green
          : Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
    );
  }

  void _editPage() {
    if (_textController.text.isNotEmpty) {
      eventList[index].title = _textController.text;
      eventList[index].indexOfAvatar = _cubit.state.indexOfSelectedIcon;
    }
  }
}
