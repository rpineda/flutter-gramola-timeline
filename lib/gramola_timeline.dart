library gramola_timeline;

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:flutter_flux/flutter_flux.dart';

import 'package:fh_sdk/fh_sdk.dart';

import 'package:gramola_timeline/config/stores.dart';

import 'package:gramola_timeline/timeline_entry_row.dart';

/// A Calculator.
class Calculator {
  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;
}

class EventTimelineComponent extends StatefulWidget {

  EventTimelineComponent(TimelineConfiguration configuration)
      : this._configuration = configuration;

  final TimelineConfiguration _configuration;

  @override
  _EventsComponentState createState() => new _EventsComponentState(this._configuration);
}

class _EventsComponentState extends State<EventTimelineComponent> 
  with StoreWatcherMixin<EventTimelineComponent>{

  final scaffoldKey = new GlobalKey<ScaffoldState>();

  final GlobalKey<AnimatedListState> _listKey = new GlobalKey<AnimatedListState>();

  _EventsComponentState(TimelineConfiguration configuration)
      : this._configuration = configuration;

  final TimelineConfiguration _configuration;

  // Never write to these stores directly. Use Actions.
  TimelineStore timelineStore;

  @override
  void initState() {
    super.initState();

    // Demonstrates using a custom change handler.
    timelineStore = listenToStore(timelineStoreToken, handleTimelineStoreChanged);

    _fetchTimeline();
  }

  void handleTimelineStoreChanged(Store value) {
    setState(() {});
  }

  void _fetchTimeline() async {
    print ('3) timelineStore => ' + timelineStore.currentEventId + ' -> ' + timelineStore.currentUserId);
    assert(timelineStore != null);
    try {
      //setConfiguration(this._configuration);
      print ('4) timelineStore => ' + this._configuration.eventId + ' -> ' + this._configuration.userId);
      fetchTimelineEntriesRequestAction('');
       Map<String, dynamic> options = {
        "path": "/timeline/" + this._configuration.eventId + "/" + this._configuration.userId,
        "method": "GET",
        "contentType": "application/json",
        "timeout": 25000 // timeout value specified in milliseconds. Default: 60000 (60s)
      };
      dynamic result = await FhSdk.cloud(options);
      fetchTimelineEntriesSuccessAction(result);
    } on PlatformException catch (e) {
      fetchTimelineEntriesFailureAction(e.message);
      print('PlatformException e: ' + e.toString());
      _showSnackbar('Error retrieving timeline!');
    }
  }

  void _showSnackbar (String message) {
    // This is just a demo, so no actual login here.
    final snackbar = new SnackBar(
      content: new Text(message),
    );

    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: new Text('List of events'),
        leading: new IconButton(
            tooltip: 'Previous choice',
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
             Navigator.pop(scaffoldKey.currentContext);
             //Navigator.pushReplacementNamed(scaffoldKey.currentContext, '/');
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        toolbarOpacity: 0.5,
      ),
      body: new Column(
        children: <Widget>[
          new Flexible(
            child: new Container(
              //color: Theme.GramolaColors.eventPageBackground,
              child: new ListView.builder(
                //itemExtent: 160.0,
                itemCount: timelineStore.timelineEntries.length,
                itemBuilder: (_, index) => new TimelineEntryRow(timelineStore.imagesBaseUrl, timelineStore.timelineEntries[index]),
              ),
            ),
          )
        ]
      )
    );
  }
}
