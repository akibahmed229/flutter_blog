part of 'auth_bloc.dart';

@immutable
// Base class for all authentication states.
// Every possible state the AuthBloc can emit extends this class.
sealed class AuthState {
  const AuthState();
}

// State when authentication process has not started yet
final class AuthInitial extends AuthState {}

// State when an authentication-related process is ongoing
// Example: signing up, logging in, or checking current user
final class AuthLoading extends AuthState {}

// State when authentication is successful
// Holds the authenticated user's data
final class AuthSuccess extends AuthState {
  final UserEntities user;

  const AuthSuccess(this.user);
}

// State when authentication fails
// Contains the error message explaining what went wrong
final class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);
}
