import 'package:blog_app/core/common/widgtes/loader.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/auth/Presentation/Widgets/auth-field.dart';
import 'package:blog_app/features/auth/Presentation/Widgets/auth_gradient_button.dart';
import 'package:blog_app/features/auth/Presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/auth/Presentation/pages/login_page.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatefulWidget {
  static routes() => MaterialPageRoute(builder: (context) => const LoginPage());
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              showSnackbar(context, state.message);
            } else if (state is AuthSuccess) {
              Navigator.pushAndRemoveUntil(
                context,
                BlogPage.route(),
                (route) => false,
              );
            }
          },
          builder: (context, state) {
            /* if (state is AuthLoading) {
              return const Loader();
            } */
            return SingleChildScrollView(
              child: Form(
                key: formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Sign Up.",
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    AuthField(controller: nameController, hintText: "Name"),
                    const SizedBox(height: 15),
                    AuthField(controller: emailController, hintText: "Email"),
                    const SizedBox(height: 15),
                    AuthField(
                      controller: passwordController,
                      hintText: "Password",
                      isObscureText: true,
                    ),
                    const SizedBox(height: 20),
                    AuthGradientButton(
                      buttonText: "Sign Up",
                      onPressed: () {
                        if (formkey.currentState!.validate()) {
                          context.read<AuthBloc>().add(
                            AuthSignUp(
                              name: nameController.text.trim(),
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, SignUpPage.routes());
                      },
                      child: RichText(
                        text: TextSpan(
                          text: 'Already have an account? ',
                          style: Theme.of(context).textTheme.titleMedium,
                          children: [
                            TextSpan(
                              text: 'Sign In',
                              style: Theme.of(
                                context,
                              ).textTheme.titleMedium?.copyWith(
                                color: AppPallete.gradient2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
