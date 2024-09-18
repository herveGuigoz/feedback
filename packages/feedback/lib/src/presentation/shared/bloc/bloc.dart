import 'dart:async';

import 'package:feedback/src/presentation/shared/bloc/bus.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:rxdart/rxdart.dart';

part 'listener.dart';
part 'provider.dart';

class Bloc<State> {
  Bloc(State initialState, {required this.eventBus}) : _stateController = BehaviorSubject.seeded(initialState);

  late final BehaviorSubject<State> _stateController;

  @protected
  final EventBus eventBus;

  final _subscriptions = <StreamSubscription<Event>>[];

  State get state => _stateController.value;

  Stream<State> get stream => _stateController.stream;

  bool get isClosed => _stateController.isClosed;

  void on<E extends Event>(FutureOr<void> Function(E event) onEvent) {
    _subscriptions.add(eventBus.on<E>().listen(onEvent));
  }

  void emit(State value) {
    if (isClosed) {
      throw StateError('Cannot emit new states after calling close');
    }
    if (state == value) {
      return;
    }
    _stateController.add(value);
  }

  Future<void> close() async {
    await _stateController.close();
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
  }
}
