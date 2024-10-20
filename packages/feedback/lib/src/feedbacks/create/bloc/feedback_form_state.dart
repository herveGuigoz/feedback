part of 'feedback_form_bloc.dart';

enum FormStatus { initial, submissionInProgress, submissionSucceed, submissionFailled }

final class FeedbackFormState extends Equatable {
  const FeedbackFormState({
    this.status = FormStatus.initial,
    this.image,
    this.screenSize,
    this.device = Device.desktop,
  });

  final FormStatus status;

  final Uint8List? image;

  final Size? screenSize;

  final Device device;

  bool get isValid => image != null && screenSize != null;

  FeedbackFormState copyWith({FormStatus? status, Uint8List? image, Size? screenSize, Device? device}) {
    return FeedbackFormState(
      status: status ?? this.status,
      image: image ?? this.image,
      screenSize: screenSize ?? this.screenSize,
      device: device ?? this.device,
    );
  }

  @override
  List<Object?> get props => [status, image, screenSize, device];
}
