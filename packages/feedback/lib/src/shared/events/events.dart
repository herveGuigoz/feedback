import 'dart:async';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:feedback_client/feedback_client.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class EventBus {
  EventBus() : _controller = StreamController.broadcast();

  static EventBus of(BuildContext context) {
    return Provider.of<EventBus>(context, listen: false);
  }

  final StreamController<Event> _controller;

  Stream<T> on<T extends Event>() {
    return _controller.stream.where((Event event) => event is T).cast<T>();
  }

  void add(Event event) {
    _controller.add(event);
  }

  void close() {
    _controller.close();
  }
}

abstract class Event extends Equatable {
  const Event();

  @override
  List<Object> get props => [];
}

// --------------------------------------------------------------------------------------------------------------------
// Authentication events
// --------------------------------------------------------------------------------------------------------------------

/// User is now logged in.
final class AuthenticationSucceededEvent extends Event {
  const AuthenticationSucceededEvent({required this.user});

  final User user;

  @override
  List<Object> get props => [user];
}

/// User failed to log in.
final class AuthenticationFailedEvent extends Event {
  const AuthenticationFailedEvent(this.error);

  final Object? error;
}

/// User is now logged out.
final class LogoutSucceededEvent extends Event {
  const LogoutSucceededEvent();
}

// --------------------------------------------------------------------------------------------------------------------
// Device events
// --------------------------------------------------------------------------------------------------------------------

/// Device was changed.
final class DeviceChangedEvent extends Event {
  const DeviceChangedEvent(this.device);

  final Device device;
}

// --------------------------------------------------------------------------------------------------------------------
// Feedback events
// --------------------------------------------------------------------------------------------------------------------

/// Event to capture a screenshot
final class ScreenshotEvent extends Event {
  const ScreenshotEvent({required this.image, required this.screenSize});

  final Uint8List image;
  final Size screenSize;

  @override
  List<Object> get props => [image, screenSize];
}

/// Feedback was created.
final class FeedbackCreatedEvent extends Event {
  const FeedbackCreatedEvent({required this.data});

  final FeedbackEvent data;

  @override
  List<Object> get props => [data];
}

/// Feedback was updated.
final class FeedbackUpdatedEvent extends Event {
  const FeedbackUpdatedEvent({required this.data});

  final FeedbackEvent data;

  @override
  List<Object> get props => [data];
}

/// Feedback was deleted.
final class FeedbackDeletedEvent extends Event {
  const FeedbackDeletedEvent({required this.id});

  final String id;

  @override
  List<Object> get props => [id];
}
