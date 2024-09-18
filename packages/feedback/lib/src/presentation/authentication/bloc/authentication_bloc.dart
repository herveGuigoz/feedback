import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:feedback/src/adapters/api/api.dart';
import 'package:feedback/src/adapters/storage/storage.dart';
import 'package:feedback/src/domain/models/models.dart';
import 'package:feedback/src/presentation/shared/bloc/bloc.dart';
import 'package:feedback/src/presentation/shared/bloc/bus.dart';

part 'authentication_event.dart';

class AuthenticationBloc extends Bloc<User?> {
  AuthenticationBloc(
    super.initialState, {
    required super.eventBus,
    required ApiClientInterface client,
    required StorageInterface storage,
  })  : _client = client,
        _storage = storage {
    on<AuthenticationRequestedEvent>(_onAuthenticationRequested);
    on<LogoutRequestedEvent>(_onLogoutRequested);
  }

  final ApiClientInterface _client;

  final StorageInterface _storage;

  static User? resolve(StorageInterface storage) {
    try {
      final cache = storage.read('user');
      return cache != null ? User.fromJson(jsonDecode(cache) as Map<String, dynamic>) : null;
    } catch (_) {
      return null;
    }
  }

  Future<void> _onAuthenticationRequested(AuthenticationRequestedEvent event) async {
    try {
      final user = await _client.authenticate(username: event.username, password: event.password);
      await _storage.write(key: 'user', value: jsonEncode(user.toJson()), expireIn: const Duration(days: 1));
      emit(user);
      eventBus.add(AuthenticationSucceededEvent(user: user));
    } catch (_) {}
  }

  Future<void> _onLogoutRequested(LogoutRequestedEvent event) async {
    try {
      await _storage.delete('user');
      emit(null);
      eventBus.add(const LogoutSucceededEvent());
    } catch (_) {}
  }
}
