import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:order_tracking/core/routing/app_routes.dart';
import 'package:order_tracking/core/utils/animated_snack_dialog.dart';
import 'package:order_tracking/core/widgets/loading_widget.dart';
import 'package:order_tracking/core/widgets/registration_form.dart';
import 'package:order_tracking/features/auth/cubit/auth_cubit.dart';
import 'package:order_tracking/features/auth/cubit/auth_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController email;
  late TextEditingController username;
  late TextEditingController password;
  late TextEditingController confirmPassword;
  @override
  void initState() {
    super.initState();
    username = TextEditingController();
    password = TextEditingController();
    email = TextEditingController();
    confirmPassword = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    username.dispose();
    password.dispose();
    email.dispose();
    confirmPassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.w),
            child: BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthSuccess) {
                  TextInput.finishAutofillContext();
                  showAnimatedSnackDialog(context, message: state.message);
                  context.pushReplacement(
                    AppRoutes.loginScreen,
                    extra: email.text,
                  );
                }
                if (state is AuthError) {
                  showAnimatedSnackDialog(
                    context,
                    type: AnimatedSnackBarType.error,
                    message: state.message,
                  );
                }
              },
              builder: (context, state) {
                if (state is AuthLoading) {
                  return const Center(child: LoadingWidget());
                }
                return RegistrationForm(
                  formKey: formKey,
                  username: username,
                  email: email,
                  password: password,
                  confirmPassword: confirmPassword,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
