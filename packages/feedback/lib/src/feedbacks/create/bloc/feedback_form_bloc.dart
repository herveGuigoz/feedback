import 'dart:typed_data';
import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:feedback/src/shared/bloc/bloc.dart';
import 'package:feedback/src/shared/events/events.dart';
import 'package:feedback/src/shared/logger/logger.dart';
import 'package:feedback_client/feedback_client.dart';
import 'package:web/web.dart' as web;

part 'feedback_form_event.dart';
part 'feedback_form_state.dart';

class FeedbackFormBloc extends Bloc<FeedbackFormState> {
  FeedbackFormBloc({
    required super.eventBus,
    required FeedbackClient client,
  })  : _client = client,
        super(const FeedbackFormState()) {
    on<ScreenshotEvent>(_onScreenshot);
    on<DeviceChangedEvent>(_onDeviceChanged);
    on<CancelFeedbackEvent>(_onCancelFeedback);
    on<SubmitFeedbackEvent>(_onSubmitFeedback);
  }

  final FeedbackClient _client;

  String get userAgent => web.Device.userAgent;

  void _onScreenshot(ScreenshotEvent event) {
    emit(FeedbackFormState(image: event.image, screenSize: event.screenSize));
  }

  void _onDeviceChanged(DeviceChangedEvent event) {
    emit(state.copyWith(device: event.device));
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
      final request = CreateFeedbackRequest(
        image: state.image!,
        body: event.body,
        path: event.path,
        device: state.device.name,
        screenSize: switch (state.screenSize) {
          final Size size => '${size.width}x${size.height}',
          _ => '${state.device.screenSize.width}x${state.device.screenSize.height}',
        },
        agent: userAgent,
      );

      final feedback = await _client.createFeedback(request: request);

      emit(state.copyWith(status: FormStatus.submissionSucceed));

      eventBus.add(FeedbackCreatedEvent(data: feedback));
    } catch (error, stackTrace) {
      logger.error('Failed to submit feedback', error: error, stackTrace: stackTrace);
      emit(state.copyWith(status: FormStatus.submissionFailled));
    }
  }
}
