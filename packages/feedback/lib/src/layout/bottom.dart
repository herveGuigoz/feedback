part of 'layout.dart';

class BottomPane extends StatelessWidget {
  const BottomPane({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Container(
      constraints: const BoxConstraints.tightFor(height: 64),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.background,
        border: Border(top: BorderSide(color: theme.colorScheme.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            spacing: 8,
            children: [
              ViewCommentsButton(),
              DevicesButton(),
            ],
          ),
          const Row(
            spacing: 8,
            children: [
              Text('Browse', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
              SwitchButton(),
              Text('Comment', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
            ],
          ),
          ConstrainedBox(
            constraints: const BoxConstraints.tightFor(width: 100),
            child: const Align(alignment: Alignment.centerRight, child: Avatar()),
          ),
        ],
      ),
    );
  }
}

class ViewCommentsButton extends StatelessWidget {
  const ViewCommentsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.select((AppBloc app) => app.state);
    final user = context.select((AuthenticationBloc auth) => auth.state);

    return ShadButton.outline(
      enabled: user != null,
      onPressed: switch (state) {
        AppState.comment => null,
        AppState.browse => () => EventBus.of(context).add(const ViewRequestedEvent()),
        AppState.view => () => EventBus.of(context).add(const BrowseRequestedEvent()),
      },
      child: const Icon(FluentIcons.comment_16_regular),
    );
  }
}

class SwitchButton extends StatelessWidget {
  const SwitchButton({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.select((AppBloc app) => app.state);
    final user = context.select((AuthenticationBloc auth) => auth.state);

    return ShadSwitch(
      enabled: user != null,
      height: 30,
      width: 50,
      value: state == AppState.comment,
      onChanged:
          (value) => switch (value) {
            true => EventBus.of(context).add(const CommentRequestedEvent()),
            false => EventBus.of(context).add(const BrowseRequestedEvent()),
          },
    );
  }
}
