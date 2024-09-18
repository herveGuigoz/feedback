part of 'authentication_bloc.dart';

/// User is trying to log in.
final class AuthenticationRequestedEvent extends Equatable implements Event {
  const AuthenticationRequestedEvent({required this.username, required this.password});

  final String username;
  final String password;

  @override
  List<Object?> get props => [username, password];
}

/// User is now logged in.
final class AuthenticationSucceededEvent extends Equatable implements Event {
  const AuthenticationSucceededEvent({required this.user});

  final User user;

  @override
  List<Object?> get props => [user];
}

/// User is trying to log out.
final class LogoutRequestedEvent implements Event {
  const LogoutRequestedEvent();
}

/// User is now logged out.
final class LogoutSucceededEvent implements Event {
  const LogoutSucceededEvent();
}
