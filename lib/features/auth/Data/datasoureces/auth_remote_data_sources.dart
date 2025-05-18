import 'package:blog_app/core/error/exception.dart';
import 'package:blog_app/features/auth/Data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Session? get currentUserSession;
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  });
  Future<UserModel?>
  getCurrentUserData(); // it doest have any parameter because we abviously have Uid of the user .
}

class AuthRemoteDataSourcesImpl implements AuthRemoteDataSource {
  final SupabaseClient
  supabaseClient; // that is supabaseClient which we have called from using the below constructor
  AuthRemoteDataSourcesImpl(
    this.supabaseClient,
  ); // look this line its constructor which called the supabaseClient

  @override // i will the Uid of the user using this session
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  @override
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        password: password,
        email: email,
      );
      if (response.user == null) {
        throw const ServerException("User is null!!");
      }
      return UserModel.fromJson(
        response.user!.toJson(),
      ).copyWith(email: currentUserSession!.user.email);
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        password: password,
        email: email,
        data: {"name": name},
      );
      if (response.user == null) {
        throw const ServerException("User is null!!");
      }
      return UserModel.fromJson(
        response.user!.toJson(),
      ).copyWith(email: currentUserSession!.user.email);
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUserSession != null) {
        // by putting .from("table name ") we can diretly talk to DB of sb.
        final userData = await supabaseClient
            .from("profiles")
            .select() // it will fetch the all details of the user from the supabase database, so return data looks like this [{...},{...},{...},{...}]
            .eq("id", currentUserSession!.user.id);
        return UserModel.fromJson(
          userData.first,
        ) // this line function will get the usermodel
        .copyWith(email: currentUserSession!.user.email);
      }
      return null;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
