import 'package:blog_app/core/common/entities/user_entities.dart';
import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

/*
   Use case class for signing up a new user.

     - Responsible for coordinating sign-up business logic.
     - Uses the [AuthRepository] interface to handle data operations.
     - Returns a [UserEntities] on success or a [Failure] on error.
*/
class UserSignUp implements Usecase<UserEntities, UserSignUpParams> {
  final AuthRepository authRepository;

  const UserSignUp({required this.authRepository});

  /*
     Executes the sign-up process.
  
     Calls the repository's sign-up method passing the user's name, email, and password.
     Returns an Either type with [Failure] or authenticated [UserEntities].
  */
  @override
  Future<Either<Failure, UserEntities>> call(UserSignUpParams params) async {
    return await authRepository.signUpWithEmailPassword(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

/// Parameters needed to sign up a user.
/// Holds the user’s name, email, and password to keep method signatures clean and clear.
class UserSignUpParams {
  final String name;
  final String email;
  final String password;

  const UserSignUpParams({
    required this.name,
    required this.email,
    required this.password,
  });
}
