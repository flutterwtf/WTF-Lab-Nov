import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../list_icons.dart';
import '../../theme/cubit_theme.dart';
import '../home_screen/event.dart';
import 'cubit_create_event_page.dart';
import 'details_image_screen.dart';
import 'message.dart';
import 'states_event_page.dart';

typedef VoidCallBack = void Function(List<Event>);

class EventPage extends StatefulWidget {
  final String eventTitle;
  final Event event;
  final List<Event> eventList;
  final VoidCallBack _callback;

  EventPage(this._callback,
      {Key key, this.eventTitle, this.event, this.eventList})
      : super(key: key);

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _textSearchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final FocusNode _searchFocusNode = FocusNode();
  List<Event> _eventList;
  Event _event;
  CubitCreateEventPage _cubit;

  @override
  void initState() {
    _event = widget.event;
    _eventList = widget.eventList;
    _focusNode.requestFocus();
    _cubit = CubitCreateEventPage(StatesEventPage(event: _event));
    _cubit.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitCreateEventPage, StatesEventPage>(
      cubit: _cubit,
      builder: (context, state) {
        return Scaffold(
          appBar: _cubit.state.isSearchButtonEnable
              ? _searchAppBar
              : _cubit.state.isMessageSelected
                  ? _selectedMessageAppBar
                  : _defaultAppBar,
          body: _createEventPageBody,
        );
      },
    );
  }

  AppBar get _searchAppBar {
    return AppBar(
      title: _textFieldSearch,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          _cubit.isSearchButtonEnable(false);
          _textSearchController.clear();
        },
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.close),
          onPressed: _textSearchController.clear,
        ),
      ],
    );
  }

  TextField get _textFieldSearch {
    return TextField(
      controller: _textSearchController,
      focusNode: _searchFocusNode,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Enter text',
        hintStyle: TextStyle(color: Colors.white),
        border: InputBorder.none,
        filled: true,
      ),
    );
  }

  AppBar get _defaultAppBar {
    return AppBar(
      title: Center(
        child: Text(widget.eventTitle),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          widget._callback(_eventList);
          Navigator.pop(context);
        },
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            _searchFocusNode.requestFocus();
            _cubit.isSearchButtonEnable(true);
            _textSearchController.addListener(
              () {
                _cubit.setMessagesList(_cubit.state.messagesList);
              },
            );
          },
        ),
        IconButton(
          icon: _cubit.state.isFavoriteMessageButtonEnable
              ? Icon(Icons.bookmark)
              : Icon(Icons.bookmark_border),
          onPressed: () => _cubit.isFavoriteMessagesButtonEnableInverse(),
        )
      ],
    );
  }

  AppBar get _selectedMessageAppBar {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.cancel),
        onPressed: () {
          _clearSelectedInformation();
        },
      ),
      title: Center(
        child: Text(_cubit.state.numberOfSelectedElements.toString()),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.reply),
          onPressed: () {
            _showAlertDialogForChooseEvent();
          },
        ),
        _cubit.state.numberOfSelectedElements < 2 &&
                _cubit.state.selectedMessage.imagePath == null
            ? IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  _cubit.isEditing(true);
                  _cubit.isMessageSelectedSet(false);
                  _cubit.state.selectedMessage.selectMessage = false;
                  _cubit.clearCounterOfSelectedElements();
                  _cubit.editMessage(
                      _textController, _cubit.state.selectedMessage);
                },
              )
            : SizedBox(),
        _cubit.state.numberOfSelectedElements < 2 &&
                _cubit.state.selectedMessage.imagePath == null
            ? Builder(builder: (context) {
                return IconButton(
                  icon: Icon(Icons.content_copy),
                  onPressed: () {
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Message copy in clipboard'),
                      ),
                    );
                    Clipboard.setData(ClipboardData(
                        text: _cubit.state.selectedMessage.message));
                  },
                );
              })
            : SizedBox(),
        IconButton(
          icon: Icon(Icons.bookmark_border),
          onPressed: () {
            for (var message in _cubit.state.messagesList) {
              if (message.isMessageSelected) {
                setState(() => message.inverseChosen());
              }
            }
          },
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            var indexes = <int>[];
            for (var i = 0; i < _cubit.state.messagesList.length; i++) {
              if (_cubit.state.messagesList[i].isMessageSelected) {
                indexes.add(i);
              }
            }
            for (var i = 0; i < indexes.length; i++) {
              _cubit.deleteMessageByIndex(indexes[i] - i);
            }
            _cubit.isMessageSelectedSet(false);
            _cubit.clearCounterOfSelectedElements();
          },
        ),
      ],
    );
  }

  Widget get _createEventPageBody {
    return Column(
      children: [
        Expanded(
          child: _messagesListView(
            _cubit.state,
          ),
        ),
        if (_cubit.state.isEditingPhoto)
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: _chooseImageSourceWrap,
          ),
        _bottomArea,
      ],
    );
  }

  Wrap get _chooseImageSourceWrap {
    return Wrap(
      spacing: 25,
      alignment: WrapAlignment.spaceAround,
      children: [
        _widgetForImagePick(
          ListTile(
            leading: Icon(
              Icons.camera_enhance,
              color: Colors.white,
            ),
            title: Text(
              'Open Camera',
              style: TextStyle(color: Colors.white),
            ),
          ),
          ImageSource.camera,
        ),
        _widgetForImagePick(
          ListTile(
            leading: Icon(
              Icons.photo,
              color: Colors.white,
            ),
            title: Text(
              'Open gallery',
              style: TextStyle(color: Colors.white),
            ),
          ),
          ImageSource.gallery,
        ),
      ],
    );
  }

  Row get _bottomArea {
    return Row(
      children: <Widget>[
        IconButton(
          icon: _cubit.state.indexOfSelectedCategoryIcon == null
              ? CircleAvatar(
                  child: Icon(Icons.category),
                )
              : CircleAvatar(
                  child: listIcons[_cubit.state.indexOfSelectedCategoryIcon],
                ),
          onPressed: () => _showBottomSheetIcons(context),
        ),
        Expanded(
          child: TextField(
            controller: _textController,
            focusNode: _focusNode,
            onChanged: (value) {
              value.isNotEmpty
                  ? _cubit.isWritingChange(true)
                  : _cubit.isWritingChange(false);
            },
            decoration: InputDecoration(
              hintText: 'Enter message',
              filled: false,
            ),
          ),
        ),
        _cubit.state.isWriting
            ? IconButton(
                icon: Icon(
                  Icons.send,
                  color: BlocProvider.of<CubitTheme>(context).state.isLightTheme
                      ? Theme.of(context).primaryColor
                      : Colors.white,
                ),
                onPressed: () => _cubit.sendMessage(
                    _textController, _cubit.state.indexOfSelectedCategoryIcon),
              )
            : IconButton(
                icon: Icon(
                  Icons.image,
                  color: BlocProvider.of<CubitTheme>(context).state.isLightTheme
                      ? Theme.of(context).primaryColor
                      : Colors.white,
                ),
                onPressed: () =>
                    _cubit.setEditingPhoto(!_cubit.state.isEditingPhoto),
              ),
      ],
    );
  }

  Padding _titleMessagesListColumn() {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: ListView.builder(
        itemCount: _eventList.length,
        itemBuilder: (context, index) {
          return RadioListTile(
            title: Text(_eventList[index].titleString),
            value: index,
            activeColor: Colors.red,
            groupValue: _cubit.state.indexOfSelectedElement,
            onChanged: (value) => _cubit.setIndexOfSelectedElement(value),
          );
        },
      ),
    );
  }

  Widget _widgetForImagePick(ListTile listTile, ImageSource imageSource) {
    return GestureDetector(
      child: Container(
        width: 160,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(80)),
          color: Theme.of(context).primaryColor,
        ),
        child: listTile,
      ),
      onTap: () async {
        final image = await ImagePicker().getImage(source: imageSource);
        if (image != null) {
          _cubit.addImageEvent(image);
        }
      },
    );
  }

  ListView _messagesListView(StatesEventPage state) {
    var _favoriteMessagesList = <Message>[];
    if (state.isFavoriteMessageButtonEnable) {
      for (var message in state.messagesList) {
        if (message.isMessageFavorite) {
          _favoriteMessagesList.insert(0, message);
        }
      }
    }

    final _messagesList = state.isSearchButtonEnable
        ? state.messagesList
            .where((element) =>
                element.message.contains(_textSearchController.text))
            .toList()
        : state.isFavoriteMessageButtonEnable
            ? _favoriteMessagesList
            : state.messagesList;

    return ListView.builder(
      scrollDirection: Axis.vertical,
      reverse: true,
      itemCount: _messagesList.length,
      itemBuilder: (context, index) {
        return _printEventList(_messagesList[index], index, state, context);
      },
    );
  }

  Widget _printEventList(
      Message message, int index, StatesEventPage state, BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          _cubit.deleteMessageByIndex(index);
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('Message removed'),
              action: SnackBarAction(
                label: 'UNDO',
                onPressed: () => _cubit.undoDeleteMessage(message, index),
              ),
            ),
          );
        } else {
          _cubit.isEditing(true);
          _cubit.selectedMessageSet(message);
          _cubit.editMessage(_textController, message);
        }
      },
      background: Container(
        child: Icon(Icons.delete),
        color: Colors.red,
        alignment: Alignment.centerLeft,
      ),
      secondaryBackground: Container(
        child: Icon(Icons.edit),
        color: Colors.orange,
        alignment: Alignment.centerRight,
      ),
      child: ClipRRect(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20.0),
          child: Column(
            children: [
              Card(
                color: message.isMessageSelected ? Colors.red : Colors.white,
                child: ListTile(
                  title: Row(
                    children: [
                      message.indexOfCategoryCircleAvatar != null
                          ? Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: CircleAvatar(
                                child: listIcons[
                                    message.indexOfCategoryCircleAvatar],
                                radius: 15,
                              ),
                            )
                          : SizedBox(),
                      message.imagePath != null
                          ? Hero(
                              tag: 'imageHero',
                              child: Image.file(
                                File(message.imagePath),
                                width: 100,
                                height: 100,
                              ),
                            )
                          : Text(
                              message.message,
                              style: TextStyle(color: Colors.black),
                            ),
                      SizedBox(
                        width: 10,
                      ),
                      message.isMessageFavorite
                          ? Icon(
                              Icons.bookmark,
                              color: Colors.orange,
                              size: 15,
                            )
                          : SizedBox(),
                    ],
                  ),
                  onTap: () => setState(() {
                    if (message.imagePath != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) {
                          return DetailsScreen(message);
                        }),
                      );
                    } else {
                      message.inverseChosen();
                    }
                  }),
                  onLongPress: () {
                    message.inverseSelected();
                    if (message.isMessageSelected) {
                      _cubit.incrementNumberOfSelectedElements();
                      _cubit.selectedMessageSet(message);
                      _cubit.isMessageSelectedSet(true);
                    } else {
                      _cubit.decrementNumberOfSelectedElements();
                      if (_cubit.state.numberOfSelectedElements == 0) {
                        _clearSelectedInformation();
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _clearSelectedInformation() {
    for (var message in _cubit.state.messagesList) {
      message.selectMessage = false;
      message.editMessage = false;
    }
    _cubit.clearCounterOfSelectedElements();
    _cubit.isMessageSelectedSet(false);
  }

  void _showAlertDialogForChooseEvent() {
    showDialog(
      context: context,
      builder: (context) {
        return BlocBuilder(
          cubit: _cubit,
          builder: (context, state) {
            return AlertDialog(
              title: Text(
                  'Select the page you want to migrate the selected event(s) to!'),
              content: _titleMessagesListColumn(),
              actions: [
                FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                FlatButton(
                  onPressed: () async {
                    _eventList = await _cubit.transferMessage(
                        _cubit.state.selectedMessage, _eventList);
                    Navigator.pop(context);
                  },
                  child: Text('Send'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showBottomSheetIcons(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 50,
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  _cubit.clearChosenCategoryButtonIcon();
                  Navigator.pop(context);
                },
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: listIcons.length,
                  itemBuilder: (context, index) {
                    return IconButton(
                      icon: CircleAvatar(
                        child: listIcons[index],
                      ),
                      onPressed: () {
                        _cubit.setIndexOfSelectedCategoryIcon(index);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
