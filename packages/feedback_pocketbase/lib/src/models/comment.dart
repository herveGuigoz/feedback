import 'package:feedback_client/feedback_client.dart';
import 'package:pocketbase/pocketbase.dart';

class PocketbaseComment extends Comment {
  const PocketbaseComment({required super.id, required super.content, required super.author, required super.created});

  factory PocketbaseComment.fromRecordModel(RecordModel model) {
    late final String content;
    if (model.data case {'content': final String value}) {
      content = value;
    } else {
      Error.throwWithStackTrace(const FeedbackFindCommentsException('Invalid response (content)'), StackTrace.current);
    }

    late final User author;
    if (model.expand case {'author': final List<RecordModel> records}) {
      author = User.fromJson(records.first.toJson());
    } else {
      Error.throwWithStackTrace(const FeedbackFindCommentsException('Invalid response (author)'), StackTrace.current);
    }

    return PocketbaseComment(
      id: model.id,
      content: content,
      author: author,
      created: DateTime.parse(model.created),
    );
  }
}

class FeedbackFindCommentsException implements Exception {
  const FeedbackFindCommentsException(this.message);

  final String message;

  @override
  String toString() => 'FeedbackFindCommentsException: $message';
}
