import 'package:blog_app/core/secrets/app_secrets.dart';
import 'package:blog_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();

  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );

  serviceLocator.registerLazySingleton(() => supabase.client);
}

void _initAuth() {
  // Register the SupabaseClient in the service locator using AuthRemoteDataSourceImpl
  serviceLocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      supabaseClient: serviceLocator<SupabaseClient>(),
    ),
  );

  // Register the AuthRepositoryImpl with the AuthRemoteDataSourceImpl
  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: serviceLocator()),
  );

  // Register the UserSignUp use case with the AuthRepositoryImpl
  serviceLocator.registerFactory(
    () => UserSignUp(authRepository: serviceLocator()),
  );

  // Register AuthBloc with the UserSignUp use case
  serviceLocator.registerLazySingleton(
    () => AuthBloc(userSignUp: serviceLocator()),
  );
}
