import 'package:blog_app/core/error/execptions.dart';
import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_app/features/auth/domain/entities/user_entities.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// This class is responsible for implementing the AuthRepository interface form the domain layer.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserEntities>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    return _getCurrentUser(
      () async => await remoteDataSource.signUpWithEmailPassword(
        name: name,
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failure, UserEntities>> logInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return _getCurrentUser(
      () async => await remoteDataSource.logInWithEmailPassword(
        email: email,
        password: password,
      ),
    );
  }

  // This private method is responsible for handling the common logic of getting the current user.
  Future<Either<Failure, UserEntities>> _getCurrentUser(
    Future<UserEntities> Function() fn,
  ) async {
    try {
      final user = await fn();
      return right(user);
    } on AuthException catch (e) {
      // Handle the authentication exception and return a failure
      return left(Failure(message: e.message));
    } on ServerException catch (e) {
      // Handle the exception and return a failure
      return left(Failure(message: e.message));
    }
  }
}
