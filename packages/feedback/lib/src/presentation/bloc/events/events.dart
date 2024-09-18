// import 'dart:async';
// import 'dart:developer';

// import 'package:feedback/src/core/api/api.dart';
// import 'package:feedback/src/core/models/models.dart';
// import 'package:feedback/src/core/navigation/navigation_observer.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/widgets.dart';

// /// {@template events_controller}
// /// A controller for the feedback events
// /// {@endtemplate}
// class EventsController extends ChangeNotifier {
//   /// {@macro events_controller}
//   EventsController({
//     required ApiClient apiClient,
//     required FeedbackNavigationObserver navigationObserver,
//   })  : _apiClient = apiClient,
//         _navigationObserver = navigationObserver {
//     unawaited(_fetchEvents());
//     _navigationObserver.addListener(_fetchEvents);
//   }

//   final ApiClient _apiClient;

//   final FeedbackNavigationObserver _navigationObserver;

//   /// The list of feedbacks from the API
//   List<FeedbackEvent> _events = [];
//   List<FeedbackEvent> get events {
//     final events = _events.where(
//       (e) => switch (e.status) { FeedbackStatus.pending || FeedbackStatus.inProgress => true, _ => false },
//     );

//     return events.toList(growable: false);
//   }

//   Future<void> _fetchEvents() async {
//     // Wait for the next event loop to get correct uri
//     await Future<void>.delayed(Duration.zero);

//     try {
//       _events = await _apiClient.getFeedbacks(Uri.base.toString());
//     } on ApiClientException catch (_) {
//       _events = [];
//     } finally {
//       log('Found ${_events.length} feedbacks', name: 'EventsController');
//       notifyListeners();
//     }
//   }

//   Future<void> createEvent(FeedbackData data) async {
//     try {
//       final event = await _apiClient.postFeedback(data);
//       _addEvent(event);
//     } catch (e) {
//       log('Failed to create event: $e', name: 'EventsController');
//     }
//   }

//   /// Add a new [FeedbackEvent] to the list
//   void _addEvent(FeedbackEvent event) {
//     _events.add(event);
//     notifyListeners();
//   }

//   /// Remove a [FeedbackEvent] from the list
//   void removeEvent(FeedbackEvent event) {
//     _events.remove(event);
//     notifyListeners();
//   }

//   /// Update a [FeedbackEvent] in the list
//   void updateEvent(FeedbackEvent event, {required FeedbackStatus status}) {
//     final index = _events.indexWhere((e) => e.id == event.id);
//     if (index != -1) {
//       _events[index] = event.copyWith(status: status);
//       notifyListeners();
//     }
//   }
// }
