part of 'bloc.dart';

typedef BlocWidgetListener<S> = void Function(BuildContext context, S state);

typedef BlocListenerCondition<S> = bool Function(S previous, S current);

class BlocListener<B extends Bloc<S>, S> extends SingleChildStatefulWidget {
  const BlocListener({
    required this.listener,
    this.listenWhen,
    super.key,
    super.child,
  });

  final BlocWidgetListener<S> listener;

  final BlocListenerCondition<S>? listenWhen;

  @override
  State<StatefulWidget> createState() => _BlocListenerState<B, S>();
}

class _BlocListenerState<B extends Bloc<S>, S> extends SingleChildState<BlocListener<B, S>> {
  StreamSubscription<S>? _subscription;
  late B _bloc;
  late S _previousState;

  void _subscribe() {
    _subscription = _bloc.stream.listen((state) {
      if (!mounted) return;
      if (widget.listenWhen?.call(_previousState, state) ?? true) {
        widget.listener(context, state);
      }
      _previousState = state;
    });
  }

  void _unsubscribe() {
    _subscription?.cancel();
    _subscription = null;
  }

  @override
  void initState() {
    super.initState();
    _bloc = context.read<B>();
    _previousState = _bloc.state;
    _subscribe();
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return child!;
  }
}
