import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/common/entities/user.dart';

import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  // later on we will change this String with our userModel
  Future<Either<Failures, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });
  Future<Either<Failures, User>> loginWithEmailPassword({
    required String email,
    required String password,
  });
  Future<Either<Failures, User>> currentUser();
}
