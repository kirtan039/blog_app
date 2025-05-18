part of 'init_dependecies.dart';

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
