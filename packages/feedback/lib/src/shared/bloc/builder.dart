part of 'bloc.dart';

typedef BlocWidgetBuilder<S> = Widget Function(BuildContext context, S state);

typedef BuildWhen<S> = bool Function(S previous, S current);

class BlocBuilder<B extends Bloc<S>, S> extends StatefulWidget {
  const BlocBuilder({
    required this.build,
    this.buildWhen,
    this.bloc,
    super.key,
  });

  final B? bloc;

  final BuildWhen<S>? buildWhen;

  final BlocWidgetBuilder<S> build;

  @override
  State<BlocBuilder<B, S>> createState() => _BlocBuilderState();
}

class _BlocBuilderState<B extends Bloc<S>, S> extends State<BlocBuilder<B, S>> {
  late B _bloc;
  late S _state;

  @override
  void initState() {
    super.initState();
    _bloc = widget.bloc ?? context.read<B>();
    _state = _bloc.state;
  }

  @override
  void didUpdateWidget(BlocBuilder<B, S> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldBloc = oldWidget.bloc ?? context.read<B>();
    final currentBloc = widget.bloc ?? oldBloc;
    if (oldBloc != currentBloc) {
      _bloc = currentBloc;
      _state = _bloc.state;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bloc = widget.bloc ?? context.read<B>();
    if (_bloc != bloc) {
      _bloc = bloc;
      _state = _bloc.state;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.bloc == null) {
      context.select<B, bool>((bloc) => identical(_bloc, bloc));
    }

    return BlocListener<B, S>(
      bloc: _bloc,
      listenWhen: widget.buildWhen,
      listener: (context, state) => setState(() => _state = state),
      child: widget.build(context, _state),
    );
  }
}
