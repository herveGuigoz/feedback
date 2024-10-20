part of 'feedback_form_bloc.dart';

// /// Event for feedback text change
// final class FeedbackTextChangedEvent extends Event {
//   const FeedbackTextChangedEvent({required this.body});

//   final String body;

//   @override
//   List<Object> get props => [body];
// }

/// Event to cancel the feedback
final class CancelFeedbackEvent extends Event {
  const CancelFeedbackEvent();
}

/// Event to submit the feedback
final class SubmitFeedbackEvent extends Event {
  const SubmitFeedbackEvent({required this.path, required this.body});

  final String path;

  final String body;

  @override
  List<Object> get props => [path, body];
}
