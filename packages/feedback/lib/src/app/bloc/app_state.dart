part of 'app_bloc.dart';

/// {@template app_state}
/// The state of the app
/// {@endtemplate}
enum AppState {
  /// The user is not logged in
  disconnected,

  /// The user is browsing the app
  browse,

  /// The user is adding a feedback
  comment,

  /// The user is viewing the feedbacks
  view,
}
