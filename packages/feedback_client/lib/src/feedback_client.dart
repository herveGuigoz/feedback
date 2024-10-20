import 'package:feedback_client/src/models/models.dart';

/// {@template feedback_exception}
/// Exception thrown when an error occurs in the feedback client.
/// {@endtemplate}
class FeedbackException implements Exception {
  /// {@macro feedback_exception}
  const FeedbackException(this.error);

  final Object error;

  @override
  String toString() => 'FeedbackException: $error';
}

/// {@template feedback_autenticate_exception}
/// Exception thrown when an error occurs during authentication.
/// {@endtemplate}
class FeedbackAuthenticateException extends FeedbackException {
  /// {@macro feedback_autenticate_exception}
  const FeedbackAuthenticateException(super.error);
}

/// {@template feedback_find_issues_exception}
/// Exception thrown when an error occurs while finding issues.
/// {@endtemplate}
class FeedbackFindIssuesException extends FeedbackException {
  /// {@macro feedback_find_issues_exception}
  const FeedbackFindIssuesException(super.error);
}

/// {@template feedback_create_issue_exception}
/// Exception thrown when an error occurs while creating an issue.
/// {@endtemplate}
class FeedbackCreateIssueException extends FeedbackException {
  /// {@macro feedback_create_issue_exception}
  const FeedbackCreateIssueException(super.error);
}

/// {@template feedback_client}
/// Interface for a feedback api client.
/// {@endtemplate}
abstract class FeedbackClient {
  /// {@macro feedback_client}
  const FeedbackClient();

  /// The base url for the feedback api.
  String get baseUrl;

  /// The current authenticated user.
  Stream<User?> get user;

  /// Authenticates the user with the given [username] and [password].
  Future<User> authenticate({required String username, required String password});

  /// Logs out the current user.
  Future<void> logout();

  /// Posts an issue.
  Future<FeedbackEvent> createFeedback({required CreateFeedbackRequest request});

  /// Finds issues for the given [path].
  Future<List<FeedbackEvent>> findFeedbacks(String path);

  /// Updates an issue.
  Future<FeedbackEvent> updateFeedback({required UpdateFeedbackRequest request});

  /// Deletes an issue.
  Future<void> deleteFeedback({required String id});

  /// Finds comments for the given [issueId].
  Future<List<Comment>> findComments(String issueId);

  /// Posts a comment.
  Future<Comment> addComment({required AddCommentRequest request});

  /// Updates a comment.
  Future<Comment> updateComment({required UpdateCommentRequest request});

  /// Deletes a comment.
  Future<void> deleteComment({required String id});
}
