import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'canvas_event.dart';
part 'canvas_state.dart';

class CanvasBloc extends Bloc<CanvasEvent, CanvasState> {
  CanvasBloc() : super(CanvasInitial()) {
    on<CanvasEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
