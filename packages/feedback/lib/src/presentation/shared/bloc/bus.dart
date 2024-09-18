import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

abstract class Event {
  const Event();
}

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
