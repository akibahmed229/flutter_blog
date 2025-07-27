import 'package:blog_app/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

// This interface defines the methods that the AuthRepository should implement in the data/datasource layer.
abstract interface class AuthRepository {
  Future<Either<Failure, String>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, String>> logInWithEmailPassword({
    required String email,
    required String password,
  });
}
