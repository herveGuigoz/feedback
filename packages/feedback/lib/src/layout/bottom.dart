part of 'layout.dart';

class BottomPane extends StatelessWidget {
  const BottomPane({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final user = context.select((AuthenticationBloc auth) => auth.state);

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
            children: [
              ViewCommentsButton(),
              SizedBox(width: 8),
              DevicesButton(),
            ],
          ),
          const Row(
            children: [
              Text('Browse', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
              SwitchButton(),
              Text('Comment', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
            ],
          ),
          ConstrainedBox(
            constraints: const BoxConstraints.tightFor(width: 100),
            child: Align(
              alignment: Alignment.centerRight,
              child: switch (user) {
                User() => Avatar(name: user.username),
                _ => const LoginButton(),
              },
            ),
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

    return ShadButton.outline(
      enabled: state != AppState.disconnected,
      onPressed: switch (state) {
        AppState.disconnected || AppState.comment => null,
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

    return ShadSwitch(
      enabled: state != AppState.disconnected,
      height: 30,
      width: 50,
      value: state == AppState.comment,
      onChanged: (value) => switch (value) {
        true => EventBus.of(context).add(const CommentRequestedEvent()),
        false => EventBus.of(context).add(const BrowseRequestedEvent()),
      },
    );
  }
}
