part of 'models.dart';

/// {@template feedback_status}
/// The status of the feedback
/// {@endtemplate}
enum FeedbackStatus {
  pending,
  inProgress,
  resolved,
  closed,
}

/// {@template feedback_event}
/// The feedback event received from the server
/// {@endtemplate}
@JsonSerializable()
class FeedbackEvent extends Equatable implements Comparable<FeedbackEvent> {
  /// {@macro feedback_event}
  const FeedbackEvent({
    required this.id,
    required this.url,
    required this.status,
    required this.body,
    required this.image,
    required this.owner,
    required this.createdAt,
  });

  factory FeedbackEvent.fromJson(Map<String, dynamic> json) => _$FeedbackEventFromJson(json);

  /// The unique identifier of the feedback
  final String id;

  /// The url of the feedback
  final String url;

  /// The status of the feedback
  final FeedbackStatus status;

  /// The content of the feedback
  final String body;

  /// The canvas snapshot of the feedback
  final FeedbackImage image;

  /// The owner of the feedback
  final FeedbackOwner owner;

  /// The creation date of the feedback
  final DateTime createdAt;

  @override
  List<Object?> get props => [id, url, status, body, image, owner, createdAt];

  @override
  int compareTo(FeedbackEvent other) => createdAt.compareTo(other.createdAt);
}

@JsonSerializable()
class FeedbackImage extends Equatable {
  const FeedbackImage({required this.contentUrl});

  factory FeedbackImage.fromJson(Map<String, dynamic> json) => _$FeedbackImageFromJson(json);

  final String contentUrl;

  @override
  List<Object?> get props => [contentUrl];
}

@JsonSerializable()
class FeedbackOwner extends Equatable {
  const FeedbackOwner({required this.id, required this.username});

  factory FeedbackOwner.fromJson(Map<String, dynamic> json) => _$FeedbackOwnerFromJson(json);

  final String id;

  final String username;

  @override
  List<Object?> get props => [id, username];
}
