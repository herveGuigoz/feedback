import 'dart:async';

import 'package:feedback/src/shared/bloc/bloc.dart';
import 'package:feedback/src/shared/events/events.dart';
import 'package:feedback_client/feedback_client.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationState> {
  AuthenticationBloc(super.initialState, {required super.eventBus, required FeedbackClient client}) : _client = client {
    on<AuthenticationRequestedEvent>(_onAuthenticationRequested);
    on<LogoutRequestedEvent>(_onLogoutRequested);

    _subscription = _client.user.listen(emit);
  }

  final FeedbackClient _client;

  late final StreamSubscription<User?> _subscription;

  Future<void> _onAuthenticationRequested(AuthenticationRequestedEvent event) async {
    try {
      final user = await _client.authenticate(username: event.username, password: event.password);
      emit(user);
      eventBus.add(AuthenticationSucceededEvent(user: user));
    } catch (error) {
      eventBus.add(AuthenticationFailedEvent(error));
    }
  }

  Future<void> _onLogoutRequested(LogoutRequestedEvent event) async {
    try {
      await _client.logout();
    } finally {
      emit(null);
      eventBus.add(const LogoutSucceededEvent());
    }
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    await super.close();
  }
}
