import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/theme/theme.dart' show AppTheme;
import 'package:blog_app/features/auth/Presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/auth/Presentation/pages/login_page.dart';
import 'package:blog_app/features/blog/data/domain/presentation/pages/blog_page.dart';
import 'package:blog_app/features/blog/presentation/bloc/bloc/blog_bloc.dart';
import 'package:blog_app/init_dependecies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<AppUserCubit>()),
        BlocProvider(
          create:
              (_) =>
                  serviceLocator<
                    AuthBloc
                  >(), // this is the new easy way of implementation using get it .by registering all the dependencies in get it .
          // below is the previous complex implementation:
          /* AuthBloc(
                userSignUp: UserSignUp(
                  AuthReporitoryImpl(
                    AuthRemoteDataSourcesImpl(supabase.client),
                  ),
                ),
              ), */
        ),
        BlocProvider(create: (_) => serviceLocator<BlogBloc>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blog App',
      theme: AppTheme.darkThemeMode,
      /* ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ), */
      home: BlocSelector<AppUserCubit, AppUserState, bool>(
        selector: (state) {
          return state is AppUserLoggedIn;
        },
        builder: (context, islooggedIn) {
          if (islooggedIn) {
            return const BlogPage();
          }
          return const LoginPage();
        },
      ),
    );
  }
}
