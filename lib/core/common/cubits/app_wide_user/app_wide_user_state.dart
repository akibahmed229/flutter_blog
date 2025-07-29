part of 'app_wide_user_cubit.dart';

@immutable
sealed class AppUserState {
  const AppUserState();
}

final class AppUserInitial extends AppUserState {}

final class AppUserLoggedIn extends AppUserState {
  final UserEntities user;
  const AppUserLoggedIn(this.user);
}
