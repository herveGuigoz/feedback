part of 'models.dart';

@JsonSerializable()
class Comment extends Equatable {
  /// {@macro comment}
  const Comment({
    required this.id,
    required this.content,
    required this.author,
    required this.created,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);

  /// The unique identifier of the comment
  final String id;

  /// The content of the comment
  final String content;

  /// The owner of the comment
  final User author;

  /// The creation date of the comment
  final DateTime created;

  @override
  List<Object?> get props => [id, content, author, created];
}

class AddCommentRequest extends Equatable {
  const AddCommentRequest({required this.feedback, required this.content});

  final String feedback;
  final String content;

  @override
  List<Object?> get props => [feedback, content];
}

class UpdateCommentRequest extends Equatable {
  const UpdateCommentRequest({required this.id, required this.content});

  final String id;
  final String content;

  @override
  List<Object?> get props => [id, content];
}
