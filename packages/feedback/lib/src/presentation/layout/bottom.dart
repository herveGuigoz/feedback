part of 'layout.dart';

class BottomPane extends StatelessWidget {
  const BottomPane({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = FeedbackTheme.of(context);
    final user = context.select((AuthenticationBloc auth) => auth.state);

    return Theme(
      data: theme.material,
      child: Container(
        constraints: const BoxConstraints.tightFor(height: 54),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: theme.backgroundColor,
          border: Border(top: theme.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              mainAxisSize: MainAxisSize.min,
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
            switch (user) {
              null => ShadButton(onPressed: () => LoginForm.show(context), child: const Text('Login')),
              User() => Avatar(name: user.username),
            },
          ],
        ),
      ),
    );
  }
}

class ViewCommentsButton extends StatelessWidget {
  const ViewCommentsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.select((AppBloc app) => app.state);

    return IconButton.outlined(
      onPressed: switch (state) {
        AppState.comment => null,
        AppState.browse => () => context.read<AppBloc>().add(const ViewRequestedEvent()),
        AppState.view => () => context.read<AppBloc>().add(const BrowseRequestedEvent()),
      },
      icon: const Icon(Icons.comment),
    );
  }
}

class SwitchButton extends StatelessWidget {
  const SwitchButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = FeedbackTheme.of(context);
    final state = context.select((AppBloc app) => app.state);

    return CupertinoSwitch(
      activeColor: theme.primaryColor,
      value: state == AppState.comment,
      onChanged: (value) => switch (value) {
        true => context.read<AppBloc>().add(const CommentRequestedEvent()),
        false => context.read<AppBloc>().add(const BrowseRequestedEvent()),
      },
    );
  }
}
