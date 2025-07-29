import 'package:blog_app/core/common/entities/user_entities.dart';
import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

/*
   Use case class for signing in a user.

     - Interacts with the [AuthRepository] to authenticate a user.
     - Returns either a [Failure] on error or a [UserEntities] on success.
*/
class UserSignIn implements Usecase<UserEntities, UserSignInParams> {
  final AuthRepository authRepository;

  const UserSignIn({required this.authRepository});

  /*
     Executes the sign-in process.
  
     Takes [UserSignInParams] (email & password) and calls the
     repository’s login method.
     Returns `Either<Failure, UserEntities>` so UI can handle both outcomes.
  */
  @override
  Future<Either<Failure, UserEntities>> call(UserSignInParams params) async {
    return await authRepository.logInWithEmailPassword(
      email: params.email,
      password: params.password,
    );
  }
}

/*
   Parameters required for user sign-in.

   Holds the email and password entered by the user.
   This keeps the use case method signature clean.
*/
class UserSignInParams {
  final String email;
  final String password;

  const UserSignInParams({required this.email, required this.password});
}
