import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppState.browse) {
    on<CommentRequestedEvent>(_onCommentRequested);
    on<ViewRequestedEvent>(_onViewRequested);
    on<BrowseRequestedEvent>(_onBrowseRequested);
  }

  void _onCommentRequested(CommentRequestedEvent event, Emitter<AppState> emit) {
    emit(AppState.comment);
  }

  void _onViewRequested(ViewRequestedEvent event, Emitter<AppState> emit) {
    emit(AppState.view);
  }

  void _onBrowseRequested(BrowseRequestedEvent event, Emitter<AppState> emit) {
    emit(AppState.browse);
  }
}
