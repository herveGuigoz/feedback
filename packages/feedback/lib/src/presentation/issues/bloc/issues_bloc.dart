import 'package:equatable/equatable.dart';
import 'package:feedback/src/adapters/api/api.dart';
import 'package:feedback/src/adapters/navigation/navigation_observer.dart';
import 'package:feedback/src/domain/models/models.dart';
import 'package:feedback/src/presentation/feedback/bloc/feedback_bloc.dart';
import 'package:feedback/src/presentation/shared/bloc/bloc.dart';

part 'issues_event.dart';
part 'issues_state.dart';

class FeedbacksBloc extends Bloc<FeedbacksState> {
  FeedbacksBloc({
    required super.eventBus,
    required ApiClientInterface apiClient,
    required FeedbackNavigationObserver navigationObserver,
  })  : _apiClient = apiClient,
        _navigationObserver = navigationObserver,
        super(const AsyncValue.loading()) {
    _navigationObserver.addListener(_fetchIssues);
    on<FeedbackCreatedEvent>(_onFeedbackCreatedEvent);
  }

  final ApiClientInterface _apiClient;

  final FeedbackNavigationObserver _navigationObserver;

  String get currentURL => Uri.base.toString();

  /// Cache of the issues from the API
  final _issues = <String, List<FeedbackEvent>>{};

  /// Fetches the issues from the API
  Future<void> _fetchIssues() async {
    // Wait for the next event loop to get correct uri
    await Future<void>.delayed(Duration.zero);

    if (!_issues.containsKey(currentURL)) {
      try {
        _issues[currentURL] = await _apiClient.findIssues(currentURL);
      } catch (error, stackTrace) {
        emit(AsyncValue.error(error, stackTrace));
      }
    }

    emit(AsyncValue.data(List<FeedbackEvent>.from(_issues[currentURL]!, growable: false)));
  }

  void _onFeedbackCreatedEvent(FeedbackCreatedEvent event) {
    if (_issues.containsKey(currentURL)) {
      _issues[currentURL]!.insert(0, event.data);
      emit(AsyncValue.data(List<FeedbackEvent>.from(_issues[currentURL]!, growable: false)));
    }
  }

  @override
  Future<void> close() {
    _navigationObserver.removeListener(_fetchIssues);
    return super.close();
  }
}
