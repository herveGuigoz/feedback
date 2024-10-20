import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:feedback/src/app/bloc/app_bloc.dart';
import 'package:feedback/src/shared/bloc/bloc.dart';
import 'package:feedback/src/shared/events/events.dart';
import 'package:feedback/src/shared/logger/logger.dart';
import 'package:feedback_client/feedback_client.dart';
import 'package:flutter/widgets.dart';

part 'feedbacks_state.dart';

class FeedbacksBloc extends Bloc<FeedbacksState> {
  FeedbacksBloc({
    required super.eventBus,
    required FeedbackClient client,
    required RouteInformationProvider routeInformationProvider,
  }) : _client = client,
       _routeInformationProvider = routeInformationProvider,
       super(const FeedbacksState()) {
    on<FeedbackCreatedEvent>(_loadFeedbacks);
    on<FeedbackUpdatedEvent>(_updateFeedback);
    on<FeedbackDeletedEvent>(_loadFeedbacks);
    on<ViewRequestedEvent>(_loadFeedbacks);
    _routeInformationProvider.addListener(_onNavigationEvent);
  }

  final FeedbackClient _client;

  final RouteInformationProvider _routeInformationProvider;

  Uri get _currentURL => _routeInformationProvider.value.uri;

  /// Fetches the issues from the API
  Future<void> _loadFeedbacks([Event? event]) async {
    try {
      // await Future<void>.delayed(Duration.zero);
      final feedbacks = await _client.findFeedbacks(_currentURL.path);
      emit(state.copyWith(feedbacks: feedbacks, path: _currentURL.path));
    } catch (error, stackTrace) {
      logger.error('Failed to load feedbacks', error: error, stackTrace: stackTrace);
    }
  }

  Future<void> _updateFeedback(FeedbackUpdatedEvent event) async {
    if (event.data.status == FeedbackStatus.closed) {
      final feedbacks = state.feedbacks.where((feedback) => feedback.id != event.data.id).toList();
      emit(state.copyWith(feedbacks: feedbacks));
    } else {
      final feedbacks = state.feedbacks.map((it) => it.id == event.data.id ? event.data : it).toList();
      emit(state.copyWith(feedbacks: feedbacks));
    }
  }

  Future<void> _onNavigationEvent() async {
    await _loadFeedbacks();
  }

  @override
  Future<void> close() async {
    _routeInformationProvider.removeListener(_onNavigationEvent);
    await super.close();
  }
}
