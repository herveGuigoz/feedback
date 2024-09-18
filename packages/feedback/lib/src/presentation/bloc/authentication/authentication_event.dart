part of 'authentication_bloc.dart';

sealed class AuthenticationEvent {
  const AuthenticationEvent();
}

final class AppLaunchedEvent extends AuthenticationEvent {
  const AppLaunchedEvent();
}

final class AuthenticationRequestedEvent extends AuthenticationEvent {
  const AuthenticationRequestedEvent({required this.username, required this.password});

  final String username;
  final String password;
}
