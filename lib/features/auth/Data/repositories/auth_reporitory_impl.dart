import 'package:blog_app/core/error/exception.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/features/auth/Data/datasoureces/auth_remote_data_sources.dart';
import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/features/auth/Domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

class AuthReporitoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;
  AuthReporitoryImpl(this.remoteDataSource, this.connectionChecker);

  @override
  Future<Either<Failures, User>> currentUser() async {
    try {
      if (!await (ConnectionChecker.isConnected)) {
        final session = remoteDataSource.currentUserSession;
        if (session == null) {
          return left(Failures("User not logged in!! "));
        }
        return left(Failures("No internet connection!! "));
      }
      final user = await remoteDataSource.getCurrentUserData();
      if (user == null) {
        return left(Failures("User not logged in!! "));
      }
      return right(user);
    } on ServerException catch (e) {
      return left(Failures(e.message));
    }
  }

  @override
  Future<Either<Failures, User>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await remoteDataSource.loginWithEmailPassword(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failures, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await remoteDataSource.signUpWithEmailPassword(
        name: name,
        email: email,
        password: password,
      ),
    );
  }

  /*  we create this variable function name _getUser to wrapper the same code used in both sign up and login. 
 So, instead of using same code at the both we simply wrappe the same code into the function called _getUser so that we can increase the readability of the code and made the code clean . 
 also i put the variable function in argument(parameter) which return User , where  variable name is fn, which i have already called .
 */
  Future<Either<Failures, User>> _getUser(Future<User> Function() fn) async {
    //wrapper function
    try {
      if (!await (ConnectionChecker.isConnected)) {
        return left(Failures("No internet connection!! "));
      }
      final user = await fn(); // calling... fn()

      return right(user);
    } on sb.AuthException catch (e) {
      return left(Failures(e.message));
    } on ServerException catch (e) {
      return left(Failures(e.message));
    }
  }
}
