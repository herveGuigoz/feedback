part of 'layout.dart';

class BottomPane extends StatelessWidget {
  const BottomPane({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = FeedbackTheme.of(context);

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
          children: [
            const Expanded(
              child: Row(
                children: [
                  ViewCommentsButton(),
                  SizedBox(width: 8),
                  DevicesButton(),
                ],
              ),
            ),
            const Row(
              children: [
                Text('Browse', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
                SwitchButton(),
                Text('Comment', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
              ],
            ),
            Expanded(child: Container()),
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
    final state = context.select((FeedbackController controller) => controller.state);

    return IconButton.outlined(
      onPressed: switch (state) {
        FeedbackState.comment => null,
        FeedbackState.browse => () => context.read<FeedbackController>().viewFeedbacks(),
        FeedbackState.view => () => context.read<FeedbackController>().browse(),
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
    final state = context.select((FeedbackController controller) => controller.state);

    return CupertinoSwitch(
      activeColor: theme.primaryColor,
      value: state == FeedbackState.comment,
      onChanged: (value) => switch (value) {
        true => context.read<FeedbackController>().comment(),
        false => context.read<FeedbackController>().browse(),
      },
    );
  }
}
