part of 'models.dart';

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

class Screenshot extends Equatable {
  const Screenshot({required this.image, required this.size});

  /// The screenshot of the app
  final Uint8List image;

  /// The viewport size
  final Size size;

  @override
  List<Object?> get props => [image, size];
}
