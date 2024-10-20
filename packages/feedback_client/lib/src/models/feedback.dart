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
    required this.path,
    required this.status,
    required this.device,
    required this.screenSize,
    required this.agent,
    required this.content,
    required this.screenshot,
    required this.owner,
    required this.created,
  });

  factory FeedbackEvent.fromJson(Map<String, dynamic> json) => _$FeedbackEventFromJson(json);

  /// The unique identifier of the feedback
  final String id;

  /// The url of the feedback
  final String path;

  /// The status of the feedback
  final FeedbackStatus status;

  /// The device of the feedback
  final Device device;

  /// The screen size of the feedback
  final String screenSize;

  /// The user agent of the feedback
  final String agent;

  /// The content of the feedback
  final String content;

  /// The canvas snapshot of the feedback
  final String screenshot;

  /// The owner of the feedback
  final FeedbackOwner owner;

  /// The creation date of the feedback
  final DateTime created;

  @override
  List<Object?> get props => [id, path, status, device, screenSize, agent, content, screenshot, device, owner, created];

  @override
  int compareTo(FeedbackEvent other) => created.compareTo(other.created);

  FeedbackEvent copyWith({FeedbackStatus? status}) {
    return FeedbackEvent(
      id: id,
      path: path,
      status: status ?? this.status,
      device: device,
      screenSize: screenSize,
      agent: agent,
      content: content,
      screenshot: screenshot,
      owner: owner,
      created: created,
    );
  }
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

class CreateFeedbackRequest extends Equatable {
  const CreateFeedbackRequest({
    required this.image,
    required this.body,
    required this.path,
    required this.device,
    required this.screenSize,
    required this.agent,
  });

  final Uint8List image;

  final String body;

  final String path;

  final String device;

  final String screenSize;

  final String agent;

  @override
  List<Object?> get props => [image, body, path, device, screenSize, agent];
}

class UpdateFeedbackRequest extends Equatable {
  const UpdateFeedbackRequest({
    required this.id,
    required this.content,
    required this.status,
  });

  final String id;

  final String content;

  final FeedbackStatus status;

  @override
  List<Object?> get props => [id, status];
}
