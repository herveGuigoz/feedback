import 'package:feedback/src/domain/models/models.dart';
import 'package:feedback/src/presentation/issues/bloc/issues_bloc.dart';
import 'package:feedback/src/presentation/issues/components/details.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    _selectedEvent.addListener(() {
      if (_selectedEvent.value != null) {
        controller.animateToPage(1, duration: kThemeAnimationDuration, curve: Curves.easeInOut);
      } else {
        controller.animateToPage(0, duration: kThemeAnimationDuration, curve: Curves.easeInOut);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: controller,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        EventsList(onEventSelected: (event) => _selectedEvent.value = event),
        ColoredBox(
          color: Colors.grey.shade100,
          child: EventDetail(event: _selectedEvent, onClose: () => _selectedEvent.value = null),
        ),
      ],
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

    return switch (state) {
      final AsyncData<List<FeedbackEvent>> events when state.hasData => SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Text(
                      Uri.base.path,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                  ],
                ),
              ),
              for (final event in events.value)
                ListTile(
                  dense: true,
                  title: Text(
                    event.body,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    dateFormat.format(event.createdAt),
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w300, color: Colors.grey),
                  ),
                  tileColor: theme.colorScheme.primaryForeground,
                  onTap: () => onEventSelected(event),
                ),
            ],
          ),
        ),
      final AsyncError<List<FeedbackEvent>> error when state.hasError => Center(
          child: Text(
            error.error.toString(),
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}
