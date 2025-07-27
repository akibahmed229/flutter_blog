import 'package:blog_app/core/error/execptions.dart';
import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

// This class is responsible for implementing the AuthRepository interface form the domain layer.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, String>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final userID = await remoteDataSource.signUpWithEmailPassword(
        name: name,
        email: email,
        password: password,
      );

      return right(userID);
    } on ServerException catch (e) {
      // Handle the exception and return a failure
      return left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, String>> logInWithEmailPassword({
    required String email,
    required String password,
  }) {
    // TODO: implement logInWithEmailPassword
    throw UnimplementedError();
  }
}
