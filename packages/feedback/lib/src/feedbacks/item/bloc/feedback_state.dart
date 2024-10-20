part of 'feedback_bloc.dart';

class FeedbackState extends Equatable {
  const FeedbackState._({
    required this.feedback,
    required this.canEdit,
    required this.canDelete,
    this.comments = const [],
  });

  factory FeedbackState.fromFeedback(
    FeedbackEvent feedback, {
    User? user,
    List<FeedbackComment> comments = const [],
  }) {
    return FeedbackState._(
      feedback: feedback,
      comments: comments,
      canEdit: feedback.owner.id == user?.id,
      canDelete: feedback.owner.id == user?.id,
    );
  }

  final FeedbackEvent feedback;
  final List<FeedbackComment> comments;
  final bool canEdit;
  final bool canDelete;

  @override
  List<Object?> get props => [feedback, comments];

  FeedbackState copyWith({FeedbackEvent? feedback, List<FeedbackComment>? comments}) {
    return FeedbackState._(
      feedback: feedback ?? this.feedback,
      comments: comments ?? this.comments,
      canEdit: canEdit,
      canDelete: canDelete,
    );
  }
}

class FeedbackComment extends Comment {
  const FeedbackComment({
    required super.id,
    required super.content,
    required super.author,
    required super.created,
    this.canEdit = false,
    this.canDelete = false,
  });

  factory FeedbackComment.fromComment(Comment comment, {bool canEdit = false, bool canDelete = false}) {
    return FeedbackComment(
      id: comment.id,
      content: comment.content,
      author: comment.author,
      created: comment.created,
      canEdit: canEdit,
      canDelete: canDelete,
    );
  }

  final bool canEdit;
  final bool canDelete;
}
