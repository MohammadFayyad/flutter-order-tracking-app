import 'package:order_tracking/features/auth/models/user_model.dart';

sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthError extends AuthState {
  final String message;
  AuthError({required this.message});
}

final class AuthSuccess extends AuthState {
  final UserModel? userModel;
  final String message;
  AuthSuccess.login({
    required this.message,
    this.userModel,
  });
  AuthSuccess.register({required this.message})
    : userModel = null;
}
