import 'package:blog_app/core/secrets/app_secrets.dart';
import 'package:blog_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_in.dart';
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
  serviceLocator
    /* 
       Data source layer
       Register the SupabaseClient in the service locator using AuthRemoteDataSourceImpl 
    */
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        supabaseClient: serviceLocator<SupabaseClient>(),
      ),
    )
    /* 
        Repository layer form the data layer
        Register the AuthRepositoryImpl with the AuthRemoteDataSourceImpl 
    */
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(remoteDataSource: serviceLocator()),
    )
    /* 
        Use case layer
        Register the UserSignUp use case with the AuthRepositoryImpl
    */
    ..registerFactory(() => UserSignUp(authRepository: serviceLocator()))
    /* 
    Register the UserSignIn use case with the AuthRepositoryImpl
    */
    ..registerFactory(() => UserSignIn(authRepository: serviceLocator()))
    /*  Bloc layer, (presentation)
        Register AuthBloc with the UserSignUp use case
    */
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator<UserSignUp>(),
        userSignIn: serviceLocator<UserSignIn>(),
      ),
    );
}
