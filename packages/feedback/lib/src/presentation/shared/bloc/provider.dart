part of 'bloc.dart';

class BlocProvider<T extends Bloc<Object?>> extends SingleChildStatelessWidget {
  const BlocProvider({
    required Create<T>? create,
    this.lazy = false,
    super.child,
    super.key,
  })  : _create = create,
        _value = null;

  const BlocProvider.value({
    required T value,
    this.lazy = true,
    super.child,
    super.key,
  })  : _create = null,
        _value = value;

  static VoidCallback _startListening<T extends Bloc<Object?>>(InheritedContext<T?> context, T value) {
    final subscription = value.stream.listen((_) => context.markNeedsNotifyDependents());
    return subscription.cancel;
  }

  final Create<T>? _create;

  final T? _value;

  final bool lazy;

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    if (_value != null) {
      return InheritedProvider<T>.value(value: _value, startListening: _startListening, lazy: lazy, child: child);
    }

    return InheritedProvider<T>(
      create: _create,
      dispose: (_, bloc) => bloc.close(),
      startListening: _startListening,
      lazy: lazy,
      child: child,
    );
  }
}
