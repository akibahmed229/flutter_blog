import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/auth/domain/entities/user_entities.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserSignIn implements Usecase<UserEntities, UserSignInParams> {
  final AuthRepository authRepository;
  const UserSignIn({required this.authRepository});

  @override
  Future<Either<Failure, UserEntities>> call(UserSignInParams params) async {
    return await authRepository.logInWithEmailPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class UserSignInParams {
  final String email;
  final String password;

  const UserSignInParams({required this.email, required this.password});
}
