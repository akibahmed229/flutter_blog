import 'package:blog_app/core/common/entities/user_entities.dart';
import 'package:blog_app/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

/*
     Defines the contract for the authentication repository.
    
     This sits in the **Domain Layer** and ensures the data layer
     provides the required authentication functionality without
     exposing implementation details.
    
     Each method returns an `Either<Failure, UserEntities>`:
     - `Failure` → returned on errors (e.g., server issues, invalid credentials).
     - `UserEntities` → returned when the operation is successful.
*/
abstract interface class AuthRepository {
  /// Registers a new user with email & password.
  Future<Either<Failure, UserEntities>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  /// Logs in an existing user with email & password.
  Future<Either<Failure, UserEntities>> logInWithEmailPassword({
    required String email,
    required String password,
  });

  /// Retrieves the currently authenticated user.
  /// Returns failure if no user is logged in.
  Future<Either<Failure, UserEntities>> currentUser();
}
