import 'package:blog_app/core/error/execptions.dart';
import 'package:blog_app/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/*
   Abstract contract for the **Auth Remote Data Source**.
  
   Defines how the app communicates with a remote backend (e.g., Supabase).
   Keeps the implementation details hidden from the repository layer.
*/
abstract interface class AuthRemoteDataSource {
  /// Holds the current authenticated session, if available.
  Session? get currentUserSession;

  /// Registers a user using email and password with additional user data.
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  /// Logs in a user using email and password.
  Future<UserModel> logInWithEmailPassword({
    required String email,
    required String password,
  });

  /// Retrieves data for the currently authenticated user.
  /// Returns `null` if the user is not logged in.
  Future<UserModel?> getCurrentUserData();
}

/*
   Implementation of [AuthRemoteDataSource] using **Supabase**.
   
   This class contains the actual logic for making requests to Supabase’s
   authentication and database services.
*/
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  /*
    Handles user sign-up with Supabase.
  
      - Creates a new user in Supabase Auth.
      - Stores additional data (`name`) in user metadata.
      - Throws [ServerException] if user creation fails.
  */
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

      if (response.user == null) {
        throw ServerException("User is null");
      }

      return UserModel.formJson(response.user!.toJson());
    } on AuthException catch (e) {
      throw ServerException('Sign up failed: ${e.message}');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /*
     Handles user login with Supabase.
  
       - Authenticates using email and password.
       - Returns a [UserModel] if successful.
       - Throws [ServerException] if login fails.
  */
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

      if (response.user == null) {
        throw ServerException("User is null");
      }

      return UserModel.formJson(response.user!.toJson());
    } on AuthException catch (e) {
      throw ServerException('Sign in failed: ${e.message}');
    } catch (e) {
      throw ServerException('Login failed: $e');
    }
  }

  /*
     Fetches the currently authenticated user’s profile data.
  
       - Uses the `profiles` table, matching the user’s ID.
       - Combines Supabase Auth email with profile data.
       - Returns `null` if no active session is found.
  */
  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUserSession != null) {
        final userData = await supabaseClient
            .from("profiles")
            .select("*")
            .eq("id", currentUserSession!.user.id);

        return UserModel.formJson(
          userData.first,
        ).copyWith(email: currentUserSession!.user.email);
      }
      return null;
    } catch (e) {
      throw ServerException('Failed to fetch current user data: $e');
    }
  }
}
