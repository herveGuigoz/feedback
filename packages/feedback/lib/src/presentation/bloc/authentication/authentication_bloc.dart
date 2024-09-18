import 'dart:convert';

import 'package:feedback/src/core/api/api.dart';
import 'package:feedback/src/core/models/models.dart';
import 'package:feedback/src/core/storage/storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'authentication_event.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, User?> {
  AuthenticationBloc({required ApiClient client, required Storage storage})
      : _client = client,
        _storage = storage,
        super(null) {
    on<AppLaunchedEvent>(_onAppLaunched);
    on<AuthenticationRequestedEvent>(_onAuthenticationRequested);
  }

  final ApiClient _client;

  final Storage _storage;

  Future<void> _onAppLaunched(AppLaunchedEvent event, Emitter<User?> emit) async {
    final user = _storage.read('user');
    if (user != null) {
      emit(User.fromJson(jsonDecode(user) as Map<String, dynamic>));
    }
  }

  Future<void> _onAuthenticationRequested(AuthenticationRequestedEvent event, Emitter<User?> emit) async {
    final user = await _client.authenticate(username: event.username, password: event.password);
    await _storage.write(key: 'user', value: jsonEncode(user.toJson()));
    emit(user);
  }
}
