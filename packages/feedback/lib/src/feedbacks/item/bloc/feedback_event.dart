part of 'feedback_bloc.dart';

final class UpdateFeedbackEvent extends Event {
  const UpdateFeedbackEvent({
    required this.id,
    required this.content,
    required this.status,
  });

  final String id;
  final String content;
  final FeedbackStatus status;

  @override
  List<Object> get props => [id, content, status];
}

final class DeleteFeedbackEvent extends Event {
  const DeleteFeedbackEvent({required this.id});

  final String id;

  @override
  List<Object> get props => [id];
}

final class LoadFeedbackCommentsEvent extends Event {
  const LoadFeedbackCommentsEvent(this.feedback);

  final FeedbackEvent feedback;

  @override
  List<Object> get props => [feedback];
}

final class CommentFeedbackEvent extends Event {
  const CommentFeedbackEvent({
    required this.feedback,
    required this.content,
  });

  final String feedback;
  final String content;

  @override
  List<Object> get props => [feedback, content];
}

final class UpdateCommentEvent extends Event {
  const UpdateCommentEvent({
    required this.id,
    required this.content,
  });

  final String id;
  final String content;

  @override
  List<Object> get props => [id, content];
}

final class DeleteCommentEvent extends Event {
  const DeleteCommentEvent({required this.id});

  final String id;

  @override
  List<Object> get props => [id];
}
