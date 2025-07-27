import 'package:blog_app/core/error/execptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// This interface defines the methods that the AuthRemoteDataSource should implement.
abstract interface class AuthRemoteDataSource {
  Future<String> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<String> logInWithEmailPassword({
    required String email,
    required String password,
  });
}

// This class is responsible for interacting with the remote data source, such as an API or a database.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;
  AuthRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<String> signUpWithEmailPassword({
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

      return response.user!.id;
    } catch (e) {
      // Handle any exceptions that may occur during the sign-up process
      throw ServerException('Sign up failed: $e');
    }
  }

  @override
  Future<String> logInWithEmailPassword({
    required String email,
    required String password,
  }) {
    // TODO: implement logInWithEmailPassword
    throw UnimplementedError();
  }
}
