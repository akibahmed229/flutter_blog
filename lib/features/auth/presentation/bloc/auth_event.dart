part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {
  const AuthEvent();
}

final class AuthSignUpEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;

  const AuthSignUpEvent({
    required this.name,
    required this.email,
    required this.password,
  });
}

final class AuthSignInEvent extends AuthEvent {
  final String email;
  final String password;

  const AuthSignInEvent({required this.email, required this.password});
}
