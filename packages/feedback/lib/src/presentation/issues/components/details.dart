import 'package:feedback/src/domain/models/models.dart';
import 'package:feedback/src/presentation/issues/components/image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class EventDetail extends StatelessWidget {
  const EventDetail({
    required this.event,
    required this.onClose,
    super.key,
  });

  final ValueNotifier<FeedbackEvent?> event;

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EventBackButton(onClose: onClose),
          EventInformation(event.value!),
          const Comments(),
          const CommentTextArea(),
        ],
      ),
    );
  }
}

class EventBackButton extends StatelessWidget {
  const EventBackButton({
    required this.onClose,
    super.key,
  });

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.tightFor(height: 48),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          IconButton(
            style: IconButton.styleFrom(
              padding: EdgeInsets.zero,
              fixedSize: const Size(48, 48),
              iconSize: 14,
              shape: const BeveledRectangleBorder(),
              backgroundColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            onPressed: onClose,
            icon: const Icon(Icons.arrow_back),
          ),
        ],
      ),
    );
  }
}

class EventInformation extends StatelessWidget {
  const EventInformation(this.event, {super.key});

  final FeedbackEvent event;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return ColoredBox(
      color: theme.colorScheme.background,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserAvatar(
              username: event.owner.username,
              date: event.createdAt,
            ),
            const Gap(12),
            Text(
              event.body,
              style: const TextStyle(fontSize: 14),
            ),
            Divider(color: Colors.grey.shade300, height: 32),
            Text(
              'Status',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.grey.shade600),
            ),
            ShadSelect<FeedbackStatus>(
              minWidth: 200,
              placeholder: const Text('Status'),
              initialValue: event.status,
              options: [
                for (final status in FeedbackStatus.values)
                  ShadOption(value: status, child: Text(status.name.toUpperCase())),
              ],
              selectedOptionBuilder: (context, option) => Text(option.name.toUpperCase()),
            ),
            Divider(color: Colors.grey.shade300, height: 32),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: ShadGestureDetector(
                      onTap: () => ImageDialog.show(
                        context,
                        imageUrl: Uri(scheme: 'http', host: 'localhost', path: event.image.contentUrl),
                      ),
                      child: Image.network(
                        Uri(scheme: 'http', host: 'localhost', path: event.image.contentUrl).toString(),
                      ),
                    ),
                  ),
                ),
                const Gap(8),
                Expanded(
                  child: DefaultTextStyle(
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w300, color: Colors.grey.shade600),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Comment left on', style: TextStyle(fontWeight: FontWeight.w600)),
                        Gap(8),
                        Text('Chrome 128 · Mac OS'),
                        Gap(4),
                        Text('Desktop - 1920x1080'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Comments extends StatelessWidget {
  const Comments({super.key});

  static DateFormat dateFormat = DateFormat('E, hh:mm a');

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 1,
          separatorBuilder: (context, index) => const Divider(height: 24),
          itemBuilder: (context, index) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserAvatar(
                username: 'John Doe',
                date: DateTime.now(),
              ),
              const Gap(8),
              const Text('This a nice comment to see how it is displayed within the left pane'),
            ],
          ),
        ),
      ),
    );
  }
}

class CommentTextArea extends StatelessWidget {
  const CommentTextArea({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8),
      child: ShadInput(
        placeholder: Text('Add a reply...'),
        minLines: 3,
        maxLines: 3,
      ),
    );
  }
}

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    required this.username,
    this.date,
    super.key,
  });

  final String username;

  final DateTime? date;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Row(
      children: [
        Container(
          constraints: BoxConstraints.tight(const Size.square(21)),
          decoration: ShapeDecoration(shape: const CircleBorder(), color: theme.colorScheme.muted),
          child: Center(
            child: Text(
              username.split('').first.toUpperCase(),
              style: TextStyle(color: theme.colorScheme.mutedForeground, fontWeight: FontWeight.w400, fontSize: 12),
            ),
          ),
        ),
        const Gap(4),
        Expanded(
          child: Text(username, style: theme.textTheme.small.copyWith(fontSize: 10)),
        ),
        if (date != null) ...[
          const Gap(4),
          Text(
            DateFormat('E, hh:mm a').format(date!),
            style: theme.textTheme.small.copyWith(fontSize: 8, color: Colors.grey.shade600),
          ),
        ],
      ],
    );
  }
}
