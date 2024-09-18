part of 'layout.dart';

class LeftPane extends StatelessWidget {
  const LeftPane({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final state = context.select((AppBloc app) => app.state);

    return ScrollConfiguration(
      behavior: const MaterialScrollBehavior(),
      child: Material(
        // To Remove !
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: theme.colorScheme.background,
            border: Border(right: BorderSide(color: theme.colorScheme.border)),
          ),
          child: switch (state) {
            AppState.disconnected => null,
            AppState.comment => const FeedbackForm(),
            AppState.view => const EventsLayout(),
            AppState.browse => const SizedBox(),
          },
        ),
      ),
    );
  }
}
