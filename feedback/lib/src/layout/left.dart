part of 'layout.dart';

typedef EventCallback = void Function(FeedbackEvent? event);

class LeftPane extends StatelessWidget {
  const LeftPane({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = FeedbackTheme.of(context);
    final state = context.select((FeedbackController controller) => controller.state);

    return ScrollConfiguration(
      behavior: const MaterialScrollBehavior(),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.backgroundColor,
          border: Border(right: theme.border),
        ),
        child: switch (state) {
          FeedbackState.comment => const FeedbackForm(),
          FeedbackState.view => const EventsLayout(),
          FeedbackState.browse => const SizedBox(),
        },
      ),
    );
  }
}

class FeedbackForm extends StatefulWidget {
  const FeedbackForm({super.key});

  @override
  State<FeedbackForm> createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final _formKey = GlobalKey<FormState>();
  final _textEditingController = TextEditingController();

  Future<void> _submitFeedback() async {
    await context.read<FeedbackController>().send(_textEditingController.text);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8).copyWith(top: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextFormField(
                controller: _textEditingController,
                cursorHeight: 13,
                cursorColor: Colors.grey.shade800,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                enabled: true,
                maxLines: null,
                decoration: const InputDecoration.collapsed(hintText: 'Type your feedback here...'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
                  ),
                  onPressed: () => context.read<FeedbackController>().browse(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _submitFeedback();
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

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
    final theme = Theme.of(context);
    final events = context.select((EventsController controller) => controller.events);

    return SingleChildScrollView(
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
          for (final event in events)
            ListTile(
              dense: true,
              title: Text(
                event.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                dateFormat.format(event.createdAt),
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w300, color: Colors.grey),
              ),
              tileColor: theme.colorScheme.surface,
              trailing: const Tooltip(
                message: 'Desktop',
                preferBelow: true,
                child: Icon(Icons.laptop, color: Colors.grey, size: 18),
              ),
              onTap: () => onEventSelected(event),
            ),
        ],
      ),
    );
  }
}

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
    final theme = FeedbackTheme.of(context);

    return ColoredBox(
      color: theme.backgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileListTile(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              name: 'John Doe',
              date: DateTime.now(),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                event.description,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            Divider(color: Colors.grey.shade300),
            Padding(
              padding: const EdgeInsets.all(12).copyWith(bottom: 0),
              child: Text(
                'Status',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade600),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: theme.backgroundColor,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(4),
              ),
              margin: const EdgeInsets.all(12).copyWith(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: DropdownButton(
                isDense: true,
                isExpanded: true,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.grey.shade700),
                dropdownColor: theme.backgroundColor,
                underline: const SizedBox.shrink(),
                borderRadius: BorderRadius.circular(4),
                hint: const Text('Status'),
                items: [
                  for (final status in FeedbackStatus.values)
                    DropdownMenuItem(value: status, child: Text(status.name.toUpperCase())),
                ],
                value: event.status,
                onChanged: (value) {},
              ),
            ),
            Divider(color: Colors.grey.shade300),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Image.network(
                      Uri(scheme: 'http', host: 'localhost', path: event.snapshotUrl).toString(),
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
            ),
            const Gap(8),
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
              ProfileListTile(
                padding: EdgeInsets.zero,
                name: 'John Doe',
                date: DateTime.now(),
              ),
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
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        cursorHeight: 13,
        cursorColor: Colors.grey.shade800,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        maxLines: null,
        decoration: const InputDecoration(
          hintText: 'Add a reply...',
          hintStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w100),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF424242), width: 0.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF424242), width: 0.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF424242), width: 0.5),
          ),
          filled: true,
          fillColor: Colors.white,
          focusColor: Colors.white,
          hoverColor: Colors.white,
        ),
      ),
    );
  }
}
