import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/auth/domain/entities/user_entities.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

// This class implements the Usecase interface for signing up a user.
class UserSignUp implements Usecase<UserEntities, UserSignUpParams> {
  final AuthRepository authRepository;
  const UserSignUp({required this.authRepository});

  @override
  // This method is responsible for signing up a user with email and password.
  Future<Either<Failure, UserEntities>> call(UserSignUpParams params) async {
    return await authRepository.signUpWithEmailPassword(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

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
