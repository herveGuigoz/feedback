part of 'feedback_bloc.dart';

enum FormStatus { initial, submissionInProgress, submissionSucceed, submissionFailled }

final class FeedbackFormState extends Equatable {
  const FeedbackFormState({
    this.status = FormStatus.initial,
    this.image,
    this.screenSize,
  });

  final FormStatus status;

  final Uint8List? image;

  final Size? screenSize;

  bool get isValid => image != null && screenSize != null;

  FeedbackFormState copyWith({FormStatus? status, Uint8List? image, Size? screenSize}) {
    return FeedbackFormState(
      status: status ?? this.status,
      image: image ?? this.image,
      screenSize: screenSize ?? this.screenSize,
    );
  }

  @override
  List<Object?> get props => [status, image, screenSize];
}
