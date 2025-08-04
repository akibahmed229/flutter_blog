import 'package:blog_app/core/common/cubits/app_wide_user/app_wide_user_cubit.dart';
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/core/secrets/app_secrets.dart';
import 'package:blog_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:blog_app/features/auth/domain/usecases/current_user.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_in.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/blog/data/datasources/blog_local_data_soure.dart';
import 'package:blog_app/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:blog_app/features/blog/data/repository/blog_repository_impl.dart';
import 'package:blog_app/features/blog/domain/repository/blog_repository.dart';
import 'package:blog_app/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:blog_app/features/blog/domain/usecases/upload_blog.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive/hive.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );

  serviceLocator.registerLazySingleton(() => supabase.client);

  // Core
  serviceLocator.registerLazySingleton(() => AppUserCubit());

  // internet connection
  serviceLocator.registerFactory(() => InternetConnection());
  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(serviceLocator()),
  );

  // local data using hive
  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;
  serviceLocator.registerLazySingleton(() => Hive.box(name: 'blogs'));

  _initAuth();
  _initBlog();
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
      () => AuthRepositoryImpl(
        remoteDataSource: serviceLocator(),
        connectionChecker: serviceLocator<ConnectionChecker>(),
      ),
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
    /* 
        Register the CurrentUser use case with the AuthRepositoryImpl
    */
    ..registerFactory(() => CurrentUser(authRepository: serviceLocator()))
    /*  Bloc layer, (presentation)
        Register AuthBloc with the UserSignUp use case
    */
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator<UserSignUp>(),
        userSignIn: serviceLocator<UserSignIn>(),
        currentUser: serviceLocator<CurrentUser>(),
        appuserCubit: serviceLocator<AppUserCubit>(),
      ),
    );
}

void _initBlog() {
  // Blog related dependencies can be initialized here
  // For example, you can register BlogRepository, BlogRemoteDataSource, etc.
  // This is just a placeholder for future blog-related dependency initialization.

  serviceLocator
    // Data source layer for blog
    ..registerFactory<BlogRemoteDataSource>(
      () => BlogRemoteDataSourceImpl(
        supabaseClient: serviceLocator<SupabaseClient>(),
      ),
    )
    ..registerFactory<BlogLocalDataSoure>(
      () => BlogLocalDataSoureImpl(box: serviceLocator<Box>()),
    )
    // Repository layer for blog
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImpl(
        blogRemoteDataSource: serviceLocator<BlogRemoteDataSource>(),
        blogLocalDataSoure: serviceLocator<BlogLocalDataSoure>(),
        connectionChecker: serviceLocator<ConnectionChecker>(),
      ),
    )
    // Use case layer for blog
    ..registerFactory(() => UploadBlog(blogRepository: serviceLocator()))
    ..registerFactory(() => GetAllBlogs(blogRepository: serviceLocator()))
    // Bloc layer for blog
    ..registerFactory(
      () => BlogBloc(
        uploadBlog: serviceLocator<UploadBlog>(),
        getAllBlogs: serviceLocator<GetAllBlogs>(),
      ),
    );
}
