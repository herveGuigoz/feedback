import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'feedbacks_event.dart';
part 'feedbacks_state.dart';

class FeedbacksBloc extends Bloc<FeedbacksEvent, FeedbacksState> {
  FeedbacksBloc() : super(FeedbacksInitial()) {
    on<FeedbacksEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
