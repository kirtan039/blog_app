// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/auth/Domain/entities/user.dart';
import 'package:blog_app/features/auth/Domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserLogIn implements Usecase<User, UserLoginParams> {
  final AuthRepository authRepository;
  UserLogIn(this.authRepository);
  @override
  Future<Either<Failures, User>> call(UserLoginParams params) async {
    return await authRepository.loginWithEmailPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class UserLoginParams {
  final String email;
  final String password;
  UserLoginParams({required this.email, required this.password});
}
