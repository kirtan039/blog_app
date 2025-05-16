import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/auth/Domain/entities/user.dart';
import 'package:blog_app/features/auth/Domain/usecases/current_user.dart';
import 'package:blog_app/features/auth/Domain/usecases/user_log_in.dart';
import 'package:blog_app/features/auth/Domain/usecases/user_sign_up.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogIn _userLogin;
  final CurrentUser _currentUser;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogIn userLogin,
    required CurrentUser currentUser,
  }) : _userSignUp = userSignUp,
       _userLogin = userLogin,
       _currentUser = currentUser,
       super(AuthInitial()) {
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);
  }
  void _isUserLoggedIn(
    AuthIsUserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _currentUser(NoParams());
    res.fold((l) => emit(AuthFailure(l.message)), (r) {
      print(r.email);
      emit(AuthSuccess(r));
    });
  }

  void _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userSignUp(
      UserSignUpParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    );
    res.fold(
      (l) => emit(
        AuthFailure(l.message),
      ), // l represent failure so you can write the failure inthe place of the failure,
      (user) => emit(AuthSuccess(user)),
    );
  }

  void _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userLogin(
      UserLoginParams(email: event.email, password: event.password),
    );
    res.fold(
      (l) => emit(
        AuthFailure(l.message),
      ), // l represent failure so you can write the failure inthe place of the failure,
      (r) => emit(AuthSuccess(r)),
    );
  }
}
