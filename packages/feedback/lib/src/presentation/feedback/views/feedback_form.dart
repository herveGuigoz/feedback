import 'package:feedback/src/presentation/feedback/bloc/feedback_bloc.dart';
import 'package:feedback/src/presentation/shared/bloc/bloc.dart';
import 'package:feedback/src/presentation/shared/bloc/bus.dart';
import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class FeedbackForm extends StatefulWidget {
  const FeedbackForm({super.key});

  @override
  State<FeedbackForm> createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final _formKey = GlobalKey<ShadFormState>();
  late final _textController = TextEditingController();

  Future<void> _submitFeedback() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    EventBus.of(context).add(SubmitFeedbackEvent(body: _textController.text.trim()));
  }

  void onSuccess() {
    ShadToaster.of(context).show(
      const ShadToast(
        title: Text('Thank you!'),
        description: Text('Your feedback has been submitted successfully.'),
      ),
    );
  }

  void onError() {
    ShadToaster.of(context).show(
      const ShadToast(
        title: Text('Oops!'),
        description: Text('Failed to submit feedback. Please try again.'),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FeedbackFormBloc, FeedbackFormState>(
      listenWhen: (previous, current) => previous.status == FormStatus.submissionInProgress,
      listener: (context, state) => switch (state.status) {
        FormStatus.submissionSucceed => onSuccess(),
        FormStatus.submissionFailled => onError(),
        _ => null
      },
      child: ShadForm(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8).copyWith(top: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ShadInputFormField(
                  controller: _textController,
                  minLines: 1,
                  maxLines: 28,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  placeholder: const Text('Type your feedback here...'),
                  decoration: ShadDecoration.none,
                  validator: (value) => value.isEmpty ? 'Feedback cannot be empty' : null,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ShadButton.ghost(
                    onPressed: () => EventBus.of(context).add(const CancelFeedbackEvent()),
                    child: const Text('Cancel'),
                  ),
                  ShadButton.ghost(
                    onPressed: _submitFeedback,
                    child: const Text('Submit'),
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
