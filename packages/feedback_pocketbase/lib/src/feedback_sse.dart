import 'dart:async';

import 'package:pocketbase/pocketbase.dart';

class ServerSideEvent extends Stream<RecordSubscriptionEvent> {
  ServerSideEvent({
    required PocketBase pocketBase,
    required this.collection,
    required this.topic,
    this.filter,
    this.expands,
  }) : _pocketBase = pocketBase;

  final PocketBase _pocketBase;

  final String collection;

  final String topic;

  final String? filter;

  final String? expands;

  late final StreamController<RecordSubscriptionEvent> _controller = StreamController<RecordSubscriptionEvent>(
    sync: true,
    onListen: _subscribe,
    onCancel: () => _pocketBase.collection(collection).unsubscribe(topic),
    onPause: () => _pocketBase.collection(collection).unsubscribe(topic),
    onResume: _subscribe,
  );

  @override
  StreamSubscription<RecordSubscriptionEvent> listen(
    void Function(RecordSubscriptionEvent event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return _controller.stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  Future<void> _subscribe() async {
    await _pocketBase.collection(collection).subscribe(topic, _controller.add, filter: filter, expand: expands);
  }
}
