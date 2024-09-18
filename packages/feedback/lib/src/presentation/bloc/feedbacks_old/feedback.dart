// import 'package:feedback/src/core/models/models.dart';
// import 'package:feedback/src/presentation/bloc/events/events.dart';
// import 'package:flutter/widgets.dart' hide SnapshotController;

// /// {@template feedback_state}
// /// The state of the feedback
// /// {@endtemplate}
// enum FeedbackState {
//   /// The user is browsing the app
//   browse,

//   /// The user is adding a feedback
//   comment,

//   /// The user is viewing the feedbacks
//   view,
// }

// /// {@template feedback_controller}
// /// A controller for the feedbacks
// /// {@endtemplate}
// class FeedbackController extends ChangeNotifier {
//   /// {@macro feedback_controller}
//   FeedbackController({
//     required EventsController eventsController,
//   }) : _eventsController = eventsController;

//   final EventsController _eventsController;

//   /// The current state
//   FeedbackState _state = FeedbackState.browse;
//   FeedbackState get state => _state;

//   /// The latest screenshot
//   Screenshot? _screenshot;
//   Screenshot get screenshot {
//     assert(_screenshot != null, 'No screenshot available');
//     return _screenshot!;
//   }

//   set screenshot(Screenshot value) {
//     _screenshot = value;
//     notifyListeners();
//   }

//   /// Start adding a feedback
//   void comment() {
//     if (_state == FeedbackState.comment) {
//       return;
//     }
//     _state = FeedbackState.comment;
//     notifyListeners();
//   }

//   /// Send the current feedback
//   Future<void> send(String description) async {
//     if (_state != FeedbackState.comment || _screenshot == null) {
//       return;
//     }

//     try {
//       final payload = FeedbackData(path: Uri.base, screenshot: screenshot, description: description);
//       await _eventsController.createEvent(payload);
//     } finally {
//       _screenshot = null;
//       _state = FeedbackState.view;
//       notifyListeners();
//     }
//   }

//   /// Cancel the current feedback
//   void browse() {
//     if (_state == FeedbackState.browse) {
//       return;
//     }
//     _screenshot = null;
//     _state = FeedbackState.browse;
//     notifyListeners();
//   }

//   /// Start viewing the feedbacks
//   void viewFeedbacks() {
//     if (_state == FeedbackState.view) {
//       return;
//     }
//     _state = FeedbackState.view;
//     notifyListeners();
//   }
// }
