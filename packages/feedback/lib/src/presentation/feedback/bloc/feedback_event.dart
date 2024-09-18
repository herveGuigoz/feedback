part of 'feedback_bloc.dart';

/// Event to capture a screenshot
final class ScreenshotEvent extends Equatable implements Event {
  const ScreenshotEvent({required this.image, required this.screenSize});

  final Uint8List image;
  final Size screenSize;

  @override
  List<Object?> get props => [image, screenSize];
}

/// Event to cancel the feedback
final class CancelFeedbackEvent implements Event {
  const CancelFeedbackEvent();
}

/// Event to submit the feedback
final class SubmitFeedbackEvent extends Equatable implements Event {
  const SubmitFeedbackEvent({required this.body});

  final String body;

  @override
  List<Object?> get props => [body];
}

final class FeedbackCreatedEvent extends Equatable implements Event {
  const FeedbackCreatedEvent({
    required this.data,
  });

  final FeedbackEvent data;

  @override
  List<Object?> get props => [data];
}
