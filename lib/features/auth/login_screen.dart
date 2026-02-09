import 'dart:developer';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:order_tracking/core/routing/app_routes.dart';
import 'package:order_tracking/core/styling/app_colors.dart';
import 'package:order_tracking/core/styling/app_styles.dart';
import 'package:order_tracking/core/utils/animated_snack_dialog.dart';
import 'package:order_tracking/core/widgets/loading_widget.dart';
import 'package:order_tracking/core/widgets/login_form.dart';
import 'package:order_tracking/core/widgets/spacing_widgets.dart';
import 'package:order_tracking/features/auth/cubit/auth_cubit.dart';
import 'package:order_tracking/features/auth/cubit/auth_state.dart';

class LoginScreen extends StatefulWidget {
  final String? email;
  const LoginScreen({super.key, this.email});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController email;
  final formKey = GlobalKey<FormState>();
  late TextEditingController password;
  @override
  void initState() {
    super.initState();
    email = TextEditingController();
    password = TextEditingController();
    log(widget.email.toString());
    if (widget.email != null) email.text = widget.email!;
  }

  @override
  void dispose() {
    super.dispose();
    email.dispose();
    password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              TextInput.finishAutofillContext();
              showAnimatedSnackDialog(context, message: state.message);
              context.pushReplacement(
                AppRoutes.homeScreen,
                extra: state.userModel,
              );
              email.clear();
              password.clear();
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
            final isLoading = state is AuthLoading;
            if (isLoading) {
              return const Center(child: LoadingWidget());
            }
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 22.w),
                child: Column(
                  children: [
                    LoginForm(
                      formKey: formKey,
                      emailController: email,
                      passwordController: password,
                      onSubmit: () {
                        if (formKey.currentState!.validate()) {
                          context.read<AuthCubit>().login(
                            email: email.text,
                            password: password.text,
                          );
                        }
                      },
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          context.pushNamed(AppRoutes.registerScreen);
                        },
                        child: RichText(
                          text: TextSpan(
                            text: "Don't have an account? ",
                            style: AppStyles.black16w500Style.copyWith(
                              color: AppColors.secondaryColor,
                            ),
                            children: [
                              TextSpan(
                                text: "Join",
                                style: AppStyles.black15BoldStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const HeightSpace(16),
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
