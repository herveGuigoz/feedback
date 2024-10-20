import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:feedback/src/shared/bloc/bloc.dart';
import 'package:feedback/src/shared/events/events.dart';
import 'package:feedback/src/shared/logger/logger.dart';
import 'package:feedback_client/feedback_client.dart';

part 'feedback_event.dart';
part 'feedback_state.dart';

class FeedbackBloc extends Bloc<FeedbackState> {
  FeedbackBloc({
    required FeedbackEvent feedback,
    required User user,
    required FeedbackClient client,
    required super.eventBus,
  })  : _client = client,
        super(FeedbackState.fromFeedback(feedback, user: user)) {
    on<LoadFeedbackCommentsEvent>(_loadComments);
    on<UpdateFeedbackEvent>(_updateFeedback);
    on<DeleteFeedbackEvent>(_deleteFeedback);
    on<CommentFeedbackEvent>(_addComment);
    on<UpdateCommentEvent>(_updateComment);
    on<DeleteCommentEvent>(_deleteComment);

    eventBus.add(LoadFeedbackCommentsEvent(feedback));
  }

  final FeedbackClient _client;

  Future<void> _updateFeedback(UpdateFeedbackEvent event) async {
    try {
      final feedback = await _client.updateFeedback(
        request: UpdateFeedbackRequest(id: event.id, content: event.content, status: event.status),
      );
      emit(state.copyWith(feedback: feedback));
      eventBus.add(FeedbackUpdatedEvent(data: feedback));
    } catch (e) {
      logger.error('Error updating feedback: $e');
    }
  }

  Future<void> _deleteFeedback(DeleteFeedbackEvent event) async {
    try {
      await _client.deleteFeedback(id: event.id);
      eventBus.add(FeedbackDeletedEvent(id: event.id));
    } catch (e) {
      logger.error('Error deleting feedback: $e');
    }
  }

  Future<void> _loadComments(LoadFeedbackCommentsEvent event) async {
    try {
      final comments = await _client.findComments(event.feedback.id);
      emit(state.copyWith(comments: comments.map(FeedbackComment.fromComment).toList()));
    } catch (e) {
      logger.error('Error loading comments: $e');
    }
  }

  Future<void> _addComment(CommentFeedbackEvent event) async {
    try {
      final comment = await _client.addComment(
        request: AddCommentRequest(feedback: event.feedback, content: event.content),
      );

      final feedbackComment = FeedbackComment.fromComment(comment, canEdit: true, canDelete: true);

      emit(state.copyWith(comments: [...state.comments, feedbackComment]));
    } catch (e) {
      logger.error('Error adding comment: $e');
    }
  }

  Future<void> _updateComment(UpdateCommentEvent event) async {
    try {
      final comment = await _client.updateComment(
        request: UpdateCommentRequest(id: event.id, content: event.content),
      );

      final index = state.comments.indexWhere((c) => c.id == event.id);
      final comments = List<FeedbackComment>.from(state.comments);
      comments[index] = FeedbackComment.fromComment(comment, canEdit: true, canDelete: true);

      emit(state.copyWith(comments: comments));
    } catch (e) {
      logger.error('Error updating comment: $e');
    }
  }

  Future<void> _deleteComment(DeleteCommentEvent event) async {
    try {
      await _client.deleteComment(id: event.id);
      final comments = state.comments.where((c) => c.id != event.id).toList(growable: false);
      emit(state.copyWith(comments: comments));
    } catch (e) {
      logger.error('Error deleting comment: $e');
    }
  }
}
