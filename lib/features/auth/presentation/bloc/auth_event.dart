part of 'auth_bloc.dart';

@immutable
// Base class for all authentication-related events.
// Every event will extend this class.
sealed class AuthEvent {
  const AuthEvent();
}

// Event triggered when a new user signs up
final class AuthSignUpEvent extends AuthEvent {
  // User details required for registration
  final String name;
  final String email;
  final String password;

  const AuthSignUpEvent({
    required this.name,
    required this.email,
    required this.password,
  });
}

// Event triggered when an existing user tries to sign in
final class AuthSignInEvent extends AuthEvent {
  // Login credentials
  final String email;
  final String password;

  const AuthSignInEvent({required this.email, required this.password});
}

// Event triggered to check if a user is already logged in
// (e.g., when app starts or resumes)
final class AuthIsUserLoggedInEvent extends AuthEvent {
  const AuthIsUserLoggedInEvent();
}
