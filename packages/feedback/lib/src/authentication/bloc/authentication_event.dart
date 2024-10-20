part of 'authentication_bloc.dart';

/// User is trying to log in.
final class AuthenticationRequestedEvent extends Event {
  const AuthenticationRequestedEvent({required this.username, required this.password});

  final String username;
  final String password;

  @override
  List<Object> get props => [username, password];
}

/// User is trying to log out.
final class LogoutRequestedEvent extends Event {
  const LogoutRequestedEvent();
}
