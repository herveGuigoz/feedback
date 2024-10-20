part of 'feedbacks_bloc.dart';

class FeedbacksState extends Equatable {
  const FeedbacksState({
    this.path = '/',
    this.feedbacks = const [],
  });

  final String path;
  final List<FeedbackEvent> feedbacks;

  FeedbacksState copyWith({String? path, List<FeedbackEvent>? feedbacks}) {
    return FeedbacksState(path: path ?? this.path, feedbacks: feedbacks ?? this.feedbacks);
  }

  @override
  List<Object?> get props => [path, feedbacks];
}
