import 'package:blog_app/core/common/entities/user_entities.dart';
import 'package:blog_app/core/error/execptions.dart';
import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/*
   Implements the AuthRepository interface.

   Acts as a bridge between the domain layer and the data source layer.
   Converts raw results (or exceptions) from the data source into domain-level results.
*/
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  /// Signs up a new user by delegating to the remote data source.
  /// Wraps the result into an Either type for success or failure.
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

  /// Logs in an existing user using email & password credentials.
  /// Calls the remote data source and handles exceptions in a unified way.
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

  /*
     Gets the currently authenticated user.
  
       - If user is logged in, returns their [UserEntities].
       - If no user is found, returns a Failure with an appropriate message.
  */
  @override
  Future<Either<Failure, UserEntities>> currentUser() async {
    try {
      final userData = await remoteDataSource.getCurrentUserData();

      if (userData == null) {
        return left(Failure(message: "User is not logged in"));
      }

      return right(userData);
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  /*
     Common handler to convert success or failure from Supabase operations
     into an `Either<Failure, UserEntities>` result.
  
     This keeps `signUpWithEmailPassword` and `logInWithEmailPassword`
     DRY and handles error mapping in one place.
  */
  Future<Either<Failure, UserEntities>> _getCurrentUser(
    Future<UserEntities> Function() fn,
  ) async {
    try {
      final user = await fn();
      return right(user);
    } on AuthException catch (e) {
      return left(Failure(message: e.message));
    } on ServerException catch (e) {
      return left(Failure(message: e.message));
    }
  }
}
