import 'package:blog_app/core/common/cubits/app_wide_user/app_wide_user_cubit.dart';
import 'package:blog_app/core/common/entities/user_entities.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/auth/domain/usecases/current_user.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_in.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // Use cases that contain the authentication logic
  final UserSignUp _userSignUp;
  final UserSignIn _userSignIn;
  final CurrentUser _currentUser;

  // App-wide user state management
  final AppUserCubit _appUserCubit;

  // Constructor where we inject our use cases
  AuthBloc({
    required UserSignUp userSignUp,
    required UserSignIn userSignIn,
    required CurrentUser currentUser,
    required AppUserCubit appuserCubit,
  }) : _userSignUp = userSignUp,
       _userSignIn = userSignIn,
       _currentUser = currentUser,
       _appUserCubit = appuserCubit,
       // Initial state of the Bloc when no action has happened yet
       super(AuthInitial()) {
    // Register event handlers
    on<AuthEvent>(
      (_, emit) => emit(AuthLoading()),
    ); // Default loading state for any event
    on<AuthSignUpEvent>(_onAuthSignUpEvent);
    on<AuthSignInEvent>(_onAuthSignInEvent);
    on<AuthIsUserLoggedInEvent>(_onAuthIsUserLoggedInEvent);
  }

  /// Handles user sign-up events
  /// Emits: AuthLoading → AuthSuccess or AuthFailure
  void _onAuthSignUpEvent(
    AuthSignUpEvent event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _userSignUp(
      UserSignUpParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    );

    // res.fold handles both success (right) and failure (left)
    res.fold(
      (failure) => emit(AuthFailure(failure.message)), // error state
      (user) => _updateAppWideUserState(user, emit), // success state
    );
  }

  /// Handles user sign-in events
  /// Emits: AuthLoading → AuthSuccess or AuthFailure
  void _onAuthSignInEvent(
    AuthSignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _userSignIn(
      UserSignInParams(email: event.email, password: event.password),
    );

    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _updateAppWideUserState(user, emit),
    );
  }

  /// Checks if the user is already logged in
  /// Useful for keeping the user logged in on app restart
  void _onAuthIsUserLoggedInEvent(
    AuthIsUserLoggedInEvent event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _currentUser(NoParams());

    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _updateAppWideUserState(user, emit),
    );
  }

  /// Updates the app-wide user state when authentication succeeds
  void _updateAppWideUserState(UserEntities user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }
}
