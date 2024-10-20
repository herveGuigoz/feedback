// ignore_for_file: use_build_context_synchronously

import 'package:feedback/src/authentication/bloc/authentication_bloc.dart';
import 'package:feedback/src/feedbacks/components/avatar.dart';
import 'package:feedback/src/feedbacks/components/image.dart';
import 'package:feedback/src/feedbacks/components/modals.dart';
import 'package:feedback/src/feedbacks/item/bloc/feedback_bloc.dart';
import 'package:feedback/src/shared/bloc/bloc.dart';
import 'package:feedback/src/shared/components/image.dart';
import 'package:feedback/src/shared/events/events.dart';
import 'package:feedback/src/shared/models/agent.dart';
import 'package:feedback_client/feedback_client.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class EventDetail extends StatelessWidget {
  const EventDetail({required this.event, required this.onClose, super.key});

  final ValueNotifier<FeedbackEvent?> event;

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    assert(event.value != null, 'Event must not be null');
    final theme = ShadTheme.of(context);

    return BlocProvider(
      create: (context) => FeedbackBloc(
        feedback: event.value!,
        user: context.read<AuthenticationBloc>().state!,
        client: context.read<FeedbackClient>(),
        eventBus: context.read<EventBus>(),
      ),
      child: Material(
        color: theme.colorScheme.muted,
        child: CustomScrollView(
          slivers: [
            PinnedHeaderSliver(child: ActionToolbar(onClose: onClose)),
            const SliverToBoxAdapter(child: EventInformation()),
            const CommentsListView(),
          ],
        ),
      ),
    );
  }
}

class ActionToolbar extends StatelessWidget {
  const ActionToolbar({required this.onClose, super.key});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return IconButtonTheme(
      data: IconButtonThemeData(
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
      ),
      child: Container(
        constraints: const BoxConstraints.tightFor(height: 48),
        color: theme.colorScheme.muted,
        child: OverflowBar(
          alignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(onPressed: onClose, icon: const Icon(Icons.arrow_back)),
          ],
        ),
      ),
    );
  }
}

class EventInformation extends StatelessWidget {
  const EventInformation({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    final (FeedbackEvent event, UserAgent agent, bool canEdit, bool canDelete) = context
        .select<FeedbackBloc, (FeedbackEvent event, UserAgent agent, bool canEdit, bool canDelete)>(
          (b) => (b.state.feedback, UserAgent(b.state.feedback.agent), b.state.canEdit, b.state.canDelete),
        );

    return ShadContextMenuRegion(
      items: [
        ShadContextMenuItem.inset(
          enabled: canEdit,
          onPressed: () {
            InputDialog.show(
              context,
              title: const Text('Edit feedback'),
              description: const Text('Update the feedback content'),
              initialValue: event.content,
            ).then((content) {
              if (content != null) {
                context.read<EventBus>().add(
                  UpdateFeedbackEvent(id: event.id, content: content, status: event.status),
                );
              }
            });
          },
          child: const Text('Edit'),
        ),
        ShadContextMenuItem.inset(
          onPressed: () {
            InputDialog.show(
              context,
              title: const Text('Post a reply'),
              description: const Text('Add a comment to this feedback'),
            ).then((value) {
              if (value != null) {
                context.read<EventBus>().add(CommentFeedbackEvent(feedback: event.id, content: value));
              }
            });
          },
          child: const Text('Comment'),
        ),
        ShadContextMenuItem.inset(
          enabled: canDelete,
          onPressed: () => DeleteDialog.show(context).then((value) {
            if (value ?? false) {
              context.read<EventBus>().add(DeleteFeedbackEvent(id: event.id));
            }
          }),
          child: Text('Delete', style: TextStyle(color: theme.colorScheme.destructive)),
        ),
      ],
      child: ColoredBox(
        color: theme.colorScheme.card,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserAvatar(username: event.owner.username, date: event.created),
              const Gap(12),
              Text(event.content, style: const TextStyle(fontSize: 14)),
              Divider(color: Colors.grey.shade300, height: 32),
              Text(
                'Status',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.grey.shade600),
              ),
              ShadSelect<FeedbackStatus>(
                enabled: canEdit,
                minWidth: 200,
                placeholder: const Text('Status'),
                initialValue: event.status,
                options: [
                  for (final status in FeedbackStatus.values) ShadOption(value: status, child: Text(status.stringify)),
                ],
                selectedOptionBuilder: (context, option) => Text(option.stringify),
                onChanged: (value) {
                  FocusManager.instance.primaryFocus?.unfocus();
                  if (value == null) {
                    return;
                  }
                  context.read<EventBus>().add(
                    UpdateFeedbackEvent(id: event.id, content: event.content, status: value),
                  );
                },
              ),
              Divider(color: Colors.grey.shade300, height: 32),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: ShadGestureDetector(
                        onTap: () => ImageDialog.show(context, image: event.screenshot),
                        child: FeedbackImage(event.screenshot),
                      ),
                    ),
                  ),
                  const Gap(8),
                  Expanded(
                    child: DefaultTextStyle(
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w300, color: Colors.grey.shade600),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Comment left on', style: TextStyle(fontWeight: FontWeight.w600)),
                          const Gap(8),
                          Text('${agent.browser.name.capitalize()} - ${agent.platform.name.capitalize()}'),
                          const Gap(4),
                          Text('${event.device.name.capitalize()} - ${event.screenSize}'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CommentsListView extends StatelessWidget {
  const CommentsListView({super.key});

  static DateFormat dateFormat = DateFormat('E, hh:mm a');

  @override
  Widget build(BuildContext context) {
    final comments = context.select<FeedbackBloc, List<Comment>>((bloc) => bloc.state.comments);

    return SliverList.separated(
      itemBuilder: (context, index) => CommentListTile(comments[index]),
      separatorBuilder: (context, index) => const Divider(),
      itemCount: comments.length,
    );
  }
}

class CommentListTile extends StatelessWidget {
  const CommentListTile(this.comment, {super.key});

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final user = context.select<AuthenticationBloc, User?>((bloc) => bloc.state);

    return ShadContextMenuRegion(
      items: [
        ShadContextMenuItem.inset(
          enabled: comment.author.id == user?.id,
          onPressed: () =>
              InputDialog.show(
                context,
                title: const Text('Edit comment'),
                description: const Text('Update the comment content'),
                initialValue: comment.content,
              ).then((content) {
                if (content != null) {
                  context.read<EventBus>().add(UpdateCommentEvent(id: comment.id, content: content));
                }
              }),
          child: const Text('Edit'),
        ),
        ShadContextMenuItem.inset(
          enabled: comment.author.id == user?.id,
          onPressed: () => DeleteDialog.show(context).then((value) {
            if (value ?? false) {
              context.read<EventBus>().add(DeleteCommentEvent(id: comment.id));
            }
          }),
          child: Text('Delete', style: TextStyle(color: theme.colorScheme.destructive)),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserAvatar(username: comment.author.username, date: comment.created),
            Text(comment.content),
          ],
        ),
      ),
    );
  }
}

class CommentButton extends StatelessWidget {
  const CommentButton({super.key});

  @override
  Widget build(BuildContext context) {
    final feedback = context.select<FeedbackBloc, FeedbackEvent>((bloc) => bloc.state.feedback);

    return Align(
      alignment: Alignment.bottomRight,
      child: ShadButton.ghost(
        child: const Text('Post reply'),
        onPressed: () =>
            InputDialog.show(
              context,
              title: const Text('Post a reply'),
              description: const Text('Add a comment to this feedback'),
            ).then((value) {
              if (value != null) {
                context.read<EventBus>().add(CommentFeedbackEvent(feedback: feedback.id, content: value));
              }
            }),
      ),
    );
  }
}

extension on FeedbackStatus {
  String get stringify {
    return switch (this) {
      FeedbackStatus.closed => 'Closed',
      FeedbackStatus.pending => 'Pending',
      FeedbackStatus.inProgress => 'In Progress',
      FeedbackStatus.resolved => 'Resolved',
    };
  }
}

extension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
