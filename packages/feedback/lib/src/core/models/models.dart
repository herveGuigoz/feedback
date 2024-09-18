import 'dart:typed_data';
import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.dart';
part 'models.g.dart';

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
class FeedbackEvent extends Equatable {
  /// {@macro feedback_event}
  const FeedbackEvent({
    required this.id,
    required this.path,
    required this.description,
    required this.snapshotUrl,
    required this.status,
    required this.createdAt,
  });

  factory FeedbackEvent.fromJson(Map<String, dynamic> json) {
    return FeedbackEvent(
      id: json['id'] as int,
      path: Uri.parse(json['path'] as String),
      description: json['description'] as String,
      snapshotUrl: json['snapshotUrl'] as String,
      status: switch (json['status'] as String) {
        'pending' => FeedbackStatus.pending,
        'inProgress' => FeedbackStatus.inProgress,
        'resolved' => FeedbackStatus.resolved,
        'closed' => FeedbackStatus.closed,
        _ => throw ArgumentError('Invalid status: ${json['status']}'),
      },
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  final int id;

  final Uri path;

  final String description;

  final String snapshotUrl;

  final FeedbackStatus status;

  final DateTime createdAt;

  @override
  List<Object?> get props => [id, path, description, snapshotUrl, status, createdAt];

  FeedbackEvent copyWith({required FeedbackStatus status}) {
    return FeedbackEvent(
      id: id,
      path: path,
      description: description,
      snapshotUrl: snapshotUrl,
      status: status,
      createdAt: createdAt,
    );
  }
}

class Screenshot extends Equatable {
  const Screenshot({required this.image, required this.size});

  /// The screenshot of the app
  final Uint8List image;

  /// The viewport size
  final Size size;

  @override
  List<Object?> get props => [image, size];
}

/// {@template feedback_data}
/// The feedback informations sent to the server
/// {@endtemplate}
class FeedbackData extends Equatable {
  /// {@macro feedback_data}
  const FeedbackData({
    required this.path,
    required this.screenshot,
    this.description,
  });

  /// The route path of the feedback
  final Uri path;

  final Screenshot screenshot;

  /// The description of the feedback
  final String? description;

  Map<String, String> toJson() {
    return {
      'path': path.toString(),
      'description': description ?? '',
    };
  }

  FeedbackData copyWith({Uri? path, Screenshot? screenshot, String? description}) {
    return FeedbackData(
      path: path ?? this.path,
      screenshot: screenshot ?? this.screenshot,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [path, screenshot, description];
}
