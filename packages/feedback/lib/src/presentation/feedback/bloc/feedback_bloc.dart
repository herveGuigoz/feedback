import 'dart:typed_data';
import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:feedback/src/adapters/api/api.dart';
import 'package:feedback/src/domain/models/models.dart';
import 'package:feedback/src/presentation/shared/bloc/bloc.dart';
import 'package:feedback/src/presentation/shared/bloc/bus.dart';
import 'package:web/web.dart' as web;

part 'feedback_event.dart';
part 'feedback_state.dart';

class FeedbackFormBloc extends Bloc<FeedbackFormState> {
  FeedbackFormBloc({required super.eventBus, required ApiClientInterface apiClient})
      : _apiClient = apiClient,
        super(const FeedbackFormState()) {
    on<ScreenshotEvent>(_onScreenshot);
    on<CancelFeedbackEvent>(_onCancelFeedback);
    on<SubmitFeedbackEvent>(_onSubmitFeedback);
  }

  final ApiClientInterface _apiClient;

  String get device => web.Device.userAgent;

  void _onScreenshot(ScreenshotEvent event) {
    emit(FeedbackFormState(image: event.image, screenSize: event.screenSize));
  }

  void _onCancelFeedback(CancelFeedbackEvent event) {
    emit(const FeedbackFormState());
  }

  Future<void> _onSubmitFeedback(SubmitFeedbackEvent event) async {
    if (!state.isValid || event.body.isEmpty) {
      return;
    }

    emit(state.copyWith(status: FormStatus.submissionInProgress));

    try {
      final issue = await _apiClient.createIssue(
        image: state.image!,
        body: event.body,
        url: Uri.base.toString(),
        device: device,
        screenSize: state.screenSize!,
      );
      emit(state.copyWith(status: FormStatus.submissionSucceed));
      eventBus.add(FeedbackCreatedEvent(data: issue));
    } catch (_) {
      emit(state.copyWith(status: FormStatus.submissionFailled));
    }
  }
}
