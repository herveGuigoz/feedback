import 'package:feedback/src/feedbacks/create/bloc/feedback_form_bloc.dart';
import 'package:feedback/src/shared/bloc/bloc.dart';
import 'package:feedback/src/shared/events/events.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppState> {
  AppBloc({required super.eventBus}) : super(AppState.browse) {
    on<CommentRequestedEvent>(_comment);
    on<ViewRequestedEvent>(_view);
    on<BrowseRequestedEvent>(_browse);
    on<CancelFeedbackEvent>(_browse);
    on<AuthenticationSucceededEvent>(_browse);
    on<FeedbackCreatedEvent>(_browse);
  }

  void _comment(CommentRequestedEvent event) {
    emit(AppState.comment);
  }

  void _view(ViewRequestedEvent event) {
    emit(AppState.view);
  }

  void _browse([Event? event]) {
    emit(AppState.browse);
  }
}
