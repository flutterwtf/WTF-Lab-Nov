import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../list_icons.dart';
import '../../theme/cubit_theme.dart';
import '../create_event_screen/create_event_page.dart';
import '../create_new_page_screen/create_new_page.dart';
import 'cubit_home_page.dart';
import 'event.dart';
import 'event_data.dart';
import 'states_home_page.dart';

class HomePage extends StatefulWidget {
  final EventData eventsTitlesData;

  HomePage({this.eventsTitlesData});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _sectionIndex = 0;
  static final List<Event> _eventList = <Event>[];
  final CubitHomePage _cubit = CubitHomePage(
    StatesHomePage(
      eventList: _eventList,
    ),
  );

  @override
  void initState() {
    _cubit.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitHomePage, StatesHomePage>(
      cubit: _cubit,
      builder: (context, state) {
        return DefaultTabController(
          length: 1,
          child: Scaffold(
            appBar: _appBar,
            body: _homePageBody,
            floatingActionButton: _floatingActionButton,
            bottomNavigationBar: _bottomNavigationBar,
          ),
        );
      },
    );
  }

  AppBar get _appBar {
    return AppBar(
      bottom: TabBar(
        tabs: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(width: 2, color: Colors.white),
              ),
            ),
            child: Center(
              child: RaisedButton(
                onPressed: null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.android),
                    Padding(
                      padding: EdgeInsets.all(10),
                    ),
                    Text('Questionnaire Bot')
                  ],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
          ),
        ],
      ),
      title: Center(
        child: Text('Home'),
      ),
      leading: IconButton(
          icon: Icon(
            Icons.list,
            color: Colors.white,
          ),
          onPressed: null),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.invert_colors, color: Colors.white),
          onPressed: () => BlocProvider.of<CubitTheme>(context).changeTheme(),
        ),
      ],
    );
  }

  ListView get _homePageBody {
    return ListView.builder(
        itemCount: _cubit.state.eventList.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(left: 7, right: 7),
            child: RaisedButton(
              color: _cubit.state.eventList[index].isEventSelected
                  ? Theme.of(context).primaryColor
                  : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventPage(
                      _cubit.updateEventsList,
                      eventTitle: _cubit.state.eventList[index].titleString,
                      event: _cubit.state.eventList[index],
                      eventList: _cubit.state.eventList,
                    ),
                  ),
                );
              },
              onLongPress: () => _showBottomSheet(context, index),
              child: Row(
                children: [
                  CircleAvatar(
                    child:
                        listIcons[_cubit.state.eventList[index].indexOfAvatar],
                    radius: 15,
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                  ),
                  Text(
                    _cubit.state.eventList[index].title,
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          );
        });
  }

  FloatingActionButton get _floatingActionButton {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreateNewPage(
              eventList: _cubit.state.eventList,
              isEditing: false,
            ),
          ),
        );
        _cubit.redrawingEventList();
      },
    );
  }

  BottomNavigationBar get _bottomNavigationBar {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.dialpad),
          label: 'Daily',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.timeline),
          label: 'TimeLine',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: 'Explore',
        ),
      ],
      showUnselectedLabels: true,
      currentIndex: _sectionIndex,
      onTap: (index) => setState(() {
        _sectionIndex = index;
      }),
    );
  }

  Column _buildBottomNavigationMenu(int index) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(
            Icons.edit,
            color: Colors.blue,
          ),
          title: Text('Edit'),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateNewPage(
                  eventList: _cubit.state.eventList,
                  isEditing: true,
                  index: index,
                ),
              ),
            );
            _cubit.updateEvent(_cubit.state.eventList[index]);
            _cubit.redrawingEventList();
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(
            Icons.delete,
            color: Colors.red,
          ),
          title: Text('Delete'),
          onTap: () {
            _cubit.deleteEvent(index);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  void _showBottomSheet(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 120,
          child: _buildBottomNavigationMenu(index),
        );
      },
    );
  }
}
