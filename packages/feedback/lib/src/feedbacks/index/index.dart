import 'package:feedback/src/feedbacks/index/bloc/feedbacks_bloc.dart';
import 'package:feedback/src/feedbacks/item/item.dart';
import 'package:feedback/src/shared/bloc/bloc.dart';
import 'package:feedback_client/feedback_client.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

typedef EventCallback = void Function(FeedbackEvent? event);

class EventsLayout extends StatefulWidget {
  const EventsLayout({super.key});

  @override
  State<EventsLayout> createState() => _EventsLayoutState();
}

class _EventsLayoutState extends State<EventsLayout> {
  final controller = PageController();

  final _selectedEvent = ValueNotifier<FeedbackEvent?>(null);

  @override
  void initState() {
    super.initState();
    _selectedEvent.addListener(() {
      if (_selectedEvent.value != null) {
        controller.animateToPage(1, duration: kThemeAnimationDuration, curve: Curves.easeInOut);
      } else {
        controller.animateToPage(0, duration: kThemeAnimationDuration, curve: Curves.easeInOut);
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FeedbacksBloc, FeedbacksState>(
      listener: (context, state) {
        /// handle feedback deleted event
        final isAlive = state.feedbacks.any((event) => event.id == _selectedEvent.value?.id);
        if (_selectedEvent.value != null && !isAlive) {
          _selectedEvent.value = null;
        }
      },
      child: PageView(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          EventsList(
            onEventSelected: (event) => _selectedEvent.value = event,
          ),
          ColoredBox(
            color: Colors.grey.shade100,
            child: EventDetail(event: _selectedEvent, onClose: () => _selectedEvent.value = null),
          ),
        ],
      ),
    );
  }
}

class EventsList extends StatelessWidget {
  const EventsList({
    required this.onEventSelected,
    super.key,
  });

  static DateFormat dateFormat = DateFormat('E, hh:mm a');

  final EventCallback onEventSelected;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final state = context.select((FeedbacksBloc bloc) => bloc.state);

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Text(
                  state.path,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 8),
                Expanded(child: Divider(color: Colors.grey.shade300)),
              ],
            ),
          ),
          for (final event in state.feedbacks)
            ListTile(
              dense: true,
              title: Text(
                event.content,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              subtitle: Row(
                children: [
                  Text(
                    dateFormat.format(event.created),
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w300, color: Colors.grey),
                  ),
                ],
              ),
              trailing: ShadBadge.raw(
                variant: switch (event.status) {
                  FeedbackStatus.pending => ShadBadgeVariant.outline,
                  FeedbackStatus.inProgress => ShadBadgeVariant.primary,
                  _ => ShadBadgeVariant.secondary,
                },
                child: Text(event.status.name),
              ),
              tileColor: theme.colorScheme.primaryForeground,
              onTap: () => onEventSelected(event),
            ),
        ],
      ),
    );
  }
}
