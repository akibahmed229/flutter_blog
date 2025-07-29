import 'package:blog_app/core/error/execptions.dart';
import 'package:blog_app/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// This interface defines the methods that the AuthRemoteDataSource should implement.
abstract interface class AuthRemoteDataSource {
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<UserModel> logInWithEmailPassword({
    required String email,
    required String password,
  });
}

// This class is responsible for interacting with the remote data source, such as an API or a database.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;
  AuthRemoteDataSourceImpl({required this.supabaseClient});

  // This method is responsible for signing up a user with email and password.
  @override
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {"name": name},
      );

      // Handle the case where the user is not created successfully
      if (response.user == null) {
        throw ServerException("User is null");
      }

      return UserModel.formJson(response.user!.toJson());
    } catch (e) {
      // Handle any exceptions that may occur during the sign-up process
      throw ServerException('Sign up failed: $e');
    }
  }

  // This method is responsible for logging in a user with email and password.
  @override
  Future<UserModel> logInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      // Handle the case where the user is not logged in successfully
      if (response.user == null) {
        throw ServerException("User is null");
      }

      return UserModel.formJson(response.user!.toJson());
    } catch (e) {
      // Handle any exceptions that may occur during the login process
      throw ServerException('Login failed: $e');
    }
  }
}
