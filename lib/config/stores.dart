import 'package:flutter_flux/flutter_flux.dart';

import 'package:gramola_timeline/model/timeline_entry.dart';

class TimelineConfiguration {
  final String eventId;
  final String userId;
  final String imagesBaseUrl;

  const TimelineConfiguration({this.eventId, this.userId, this.imagesBaseUrl});

}

class BaseStore extends Store {
  bool _fetching = false;
  bool _error = false;
  
  String _errorMessage = '';

  bool get isFetching => _fetching;
  bool get isError => _error;

  String get errorMessage => _errorMessage;

  BaseStore();
}

class TimelineStore extends BaseStore {
  String _currentEventId = '';
  String _currentUserId = '';

  String _imagesBaseUrl = '';

  dynamic _result;

  List<TimelineEntry> _timelineEntries = <TimelineEntry>[];
  TimelineEntry _currentTimelineEntry;
  
  String get currentEventId => _currentEventId;
  String get currentUserId => _currentUserId;

  String get imagesBaseUrl => _imagesBaseUrl;

  dynamic get result => _result;

  List<TimelineEntry> get timelineEntries => new List<TimelineEntry>.unmodifiable(_timelineEntries);
  TimelineEntry get currentTimelineEntry => _currentTimelineEntry;

  TimelineStore() {
    triggerOnAction(fetchTimelineEntriesRequestAction, (String _) {
        _fetching = true;
        _error = false;
        _result = null;
        _timelineEntries = List<TimelineEntry>();
    });

    triggerOnAction(fetchTimelineEntriesSuccessAction, (dynamic result) {
        _fetching = false;
        if (result is List) {
          _result = result;
          _timelineEntries = List<TimelineEntry>();
          _result.forEach((element) {
            _timelineEntries.add(new TimelineEntry(id: element['id'], eventId: element['eventId'], 
              userId: element['userId'], title: element['title'], 
              date: element['date'], time: element['time'], 
              description:  element['description'], image: element['image']));
          });
        }
    });

    triggerOnAction(fetchTimelineEntriesFailureAction, (String errorMessage) {
      _fetching = false;
      _errorMessage = errorMessage;
    });

    triggerOnAction(setConfiguration, (TimelineConfiguration configuration) {
      assert(configuration != null);
      _currentEventId = configuration.eventId;
      _currentUserId = configuration.userId;
      _imagesBaseUrl = configuration.imagesBaseUrl;
    });

    triggerOnAction(selectTimelineEntry, (TimelineEntry timelineEntry) {
      assert(timelineEntry != null);
      _currentTimelineEntry = timelineEntry;
    });
  }
}

final StoreToken timelineStoreToken = new StoreToken(new TimelineStore());

final Action<String>  fetchTimelineEntriesRequestAction = new Action<String>();
final Action<dynamic> fetchTimelineEntriesSuccessAction = new Action<dynamic>();
final Action<String>  fetchTimelineEntriesFailureAction = new Action<String>();

final Action<TimelineConfiguration> setConfiguration = new Action<TimelineConfiguration>();
final Action<TimelineEntry> selectTimelineEntry = new Action<TimelineEntry>();
