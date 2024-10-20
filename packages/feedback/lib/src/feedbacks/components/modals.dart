import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class InputDialog extends StatefulWidget {
  const InputDialog({
    required this.title,
    required this.description,
    this.initialValue,
    super.key,
  });

  final Widget title;
  final Widget description;
  final String? initialValue;

  static Future<String?> show(
    BuildContext context, {
    required Widget title,
    required Widget description,
    String? initialValue,
  }) {
    return showShadDialog<String>(
      context: context,
      builder: (_) => InputDialog(title: title, description: description, initialValue: initialValue),
    );
  }

  @override
  State<InputDialog> createState() => _InputDialogState();
}

class _InputDialogState extends State<InputDialog> {
  late final _controller = TextEditingController(text: widget.initialValue);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return ShadDialog(
      title: widget.title,
      description: widget.description,
      actions: [
        ListenableBuilder(
          listenable: _controller,
          builder: (context, child) => ShadButton(
            enabled: _controller.text.isNotEmpty && _controller.text != widget.initialValue,
            onPressed: () => Navigator.of(context).pop(_controller.text),
            child: const Text('Save'),
          ),
        ),
      ],
      child: Container(
        width: 375,
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ShadInput(
              controller: _controller,
              decoration: ShadDecoration(
                color: theme.colorScheme.card,
                border: ShadBorder.all(width: 0.5),
              ),
              minLines: 4,
              maxLines: 8,
            ),
          ],
        ),
      ),
    );
  }
}

class DeleteDialog extends StatelessWidget {
  const DeleteDialog({super.key});

  static Future<bool?> show(BuildContext context) async {
    return showShadDialog<bool>(context: context, builder: (_) => const DeleteDialog());
  }

  @override
  Widget build(BuildContext context) {
    return ShadDialog.alert(
      title: const Text('Are you absolutely sure?'),
      description: const Padding(
        padding: EdgeInsets.only(bottom: 8),
        child: Text('This action cannot be undone.'),
      ),
      actions: [
        ShadButton.outline(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context, false),
        ),
        ShadButton(
          child: const Text('Continue'),
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    );
  }
}
