import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_tracking/features/auth/cubit/auth_state.dart';
import 'package:order_tracking/features/auth/models/user_model.dart';
import 'package:order_tracking/features/auth/repo/auth_repo.dart';
import 'package:result_dart/result_dart.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.authRepo) : super(AuthInitial());

  final AuthRepo authRepo;

  void login({required String email, required String password}) async {
    emit(AuthLoading());
    ResultDart<UserModel, String> result = await authRepo.loginUser(
      email: email.trim(),
      password: password.trim(),
    );
    if (isClosed) return;
    result.fold(
      (userModel) => emit(
        AuthSuccess.login(message: "Login successfully", userModel: userModel),
      ),
      (errorMessage) => emit(AuthError(message: errorMessage)),
    );
  }

  void register({
    required String email,
    required String password,
    required String username,
  }) async {
    emit(AuthLoading());
    ResultDart<String, String> result = await authRepo.registerUser(
      email: email.trim(),
      password: password.trim(),
      username: username.trim(),
    );
    if (isClosed) return;
    result.fold(
      (message) => emit(AuthSuccess.register(message: message)),
      (errorMessage) => emit(AuthError(message: errorMessage)),
    );
  }

  void logout() {
    authRepo.logout();
  }
}
