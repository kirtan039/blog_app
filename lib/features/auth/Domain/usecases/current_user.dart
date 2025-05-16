import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/auth/Domain/entities/user.dart';
import 'package:blog_app/features/auth/Domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class CurrentUser implements Usecase<User, NoParams> {
  final AuthRepository authRepository;
  CurrentUser(this.authRepository);

  @override
  Future<Either<Failures, User>> call(NoParams params) async {
    return await authRepository.currentUser();
  }
}
