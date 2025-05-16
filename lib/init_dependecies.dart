import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/core/secrets/app_secrets.dart';
import 'package:blog_app/features/auth/Data/datasoureces/auth_remote_data_sources.dart';
import 'package:blog_app/features/auth/Data/repositories/auth_reporitory_impl.dart';
import 'package:blog_app/features/auth/Domain/repository/auth_repository.dart';
import 'package:blog_app/features/auth/Domain/usecases/current_user.dart';
import 'package:blog_app/features/auth/Domain/usecases/user_log_in.dart';
import 'package:blog_app/features/auth/Domain/usecases/user_sign_up.dart';
import 'package:blog_app/features/auth/Presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/blog/data/datasouces/blog_local_data_source.dart';
import 'package:blog_app/features/blog/data/datasouces/blog_remote_data_sources.dart';
import 'package:blog_app/features/blog/data/repository/blog_repository_impl.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:blog_app/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:blog_app/features/blog/domain/usecases/upload_blog.dart';
import 'package:blog_app/features/blog/presentation/bloc/bloc/blog_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBlog();

  final supabase = await Supabase.initialize(
    url: AppSecrets.SupabaseUrl,
    anonKey: AppSecrets.SupabaseAnonKey,
  );
  // to initialise hive have to do 2 things 1. we need to change the defaultdirectory of the hive and what should our defaultdirectory be ? , well to get that  we use path_provider plugin that we Add

  /* Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path; // this represent the defaultDirectory  if we use hive 4.0.0.v-2 version which is not present now , so we do it same thing  with  normal Hive package which is always present */

  // Initialize Hive with the desired directory first
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path); // This sets the base directory for all boxes

  // Open your boxes (do this before registering them)
  await Hive.openBox("blogs"); // Important to await the box opening
  serviceLocator.registerLazySingleton(() => supabase.client);
  serviceLocator.registerLazySingleton(() => Hive.box("blogs"));
  serviceLocator.registerFactory(() => InternetConnection());

  //Core
  serviceLocator.registerLazySingleton(() => AppUserCubit());
  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(serviceLocator()),
  );
}

void _initAuth() {
  //DataSource
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourcesImpl(serviceLocator()),
    )
    //Repository
    ..registerFactory<AuthRepository>(
      () => AuthReporitoryImpl(serviceLocator(), serviceLocator()),
    )
    //Usecases
    ..registerFactory(() => UserSignUp(serviceLocator()))
    ..registerFactory(() => UserLogIn(serviceLocator()))
    ..registerFactory(() => CurrentUser(serviceLocator()))
    //Bloc
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userLogin: serviceLocator(),
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}

void _initBlog() {
  //DataSource
  serviceLocator
    ..registerFactory<BlogRemoteDataSources>(
      () => BlogRemoteDataSourcesImpl(serviceLocator()),
    )
    ..registerFactory<BlogLocalDataSource>(
      () => BlogLocalDataSourceImpl(serviceLocator()),
    )
    //Repository
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    )
    //Usecases
    ..registerFactory(() => UploadBlog(serviceLocator()))
    ..registerFactory(() => GetAllBlogs(serviceLocator()))
    //Bloc
    ..registerLazySingleton(
      () =>
          BlogBloc(uploadBlog: serviceLocator(), getAllBlog: serviceLocator()),
    );
}
