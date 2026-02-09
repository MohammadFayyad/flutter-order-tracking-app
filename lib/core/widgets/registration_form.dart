import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:order_tracking/core/routing/app_routes.dart';
import 'package:order_tracking/core/styling/app_assets.dart';
import 'package:order_tracking/core/styling/app_colors.dart';
import 'package:order_tracking/core/styling/app_styles.dart';
import 'package:order_tracking/core/widgets/custom_text_field.dart';
import 'package:order_tracking/core/widgets/primay_button_widget.dart';
import 'package:order_tracking/core/widgets/spacing_widgets.dart';
import 'package:order_tracking/features/auth/cubit/auth_cubit.dart';

class RegistrationForm extends StatelessWidget {
  const RegistrationForm({
    super.key,
    required this.formKey,
    required this.username,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController username;
  final TextEditingController email;
  final TextEditingController password;
  final TextEditingController confirmPassword;

  @override
  Widget build(BuildContext context) {
    return AutofillGroup(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeightSpace(28),
            SizedBox(
              width: 335.w,
              child: Text(
                "Create an account",
                style: AppStyles.primaryHeadLinesStyle,
              ),
            ),

            const HeightSpace(8),

            SizedBox(
              width: 335.w,
              child: Text(
                "Let’s create your account.",
                style: AppStyles.grey12MediumStyle,
              ),
            ),

            const HeightSpace(20),

            Center(
              child: Image.asset(AppAssets.logo, width: 190.w, height: 190.w),
            ),

            const HeightSpace(32),

            Text("User Name", style: AppStyles.black16w500Style),
            const HeightSpace(8),

            CustomTextField(
              controller: username,
              hintText: "Enter your user name",
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              // autofillHints: const [AutofillHints.username],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "User name is required";
                }
                return null;
              },
            ),

            const HeightSpace(16),

            Text("Email", style: AppStyles.black16w500Style),
            const HeightSpace(8),

            CustomTextField(
              controller: email,
              hintText: "Enter your email",
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.newUsername],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Email is required";
                }
                return null;
              },
            ),

            const HeightSpace(16),

            Text("Password", style: AppStyles.black16w500Style),
            const HeightSpace(8),

            CustomTextField(
              obscure: true,
              controller: password,

              hintText: "Enter your password",
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.newPassword],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Password is required";
                }
                if (value.length < 8) {
                  return "Password must be at least 8 characters";
                }
                return null;
              },
            ),

            const HeightSpace(16),

            Text("Confirm Password", style: AppStyles.black16w500Style),
            const HeightSpace(8),

            CustomTextField(
              obscure: true,
              controller: confirmPassword,
              hintText: "Confirm your password",
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.newPassword],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Confirm password is required";
                }
                if (value != password.text) {
                  return "Passwords do not match";
                }
                return null;
              },
              onFieldSubmitted: (_) {
                if (formKey.currentState!.validate()) {
                  context.read<AuthCubit>().register(
                    email: email.text,
                    password: password.text,
                    username: username.text,
                  );
                }
              },
            ),

            const HeightSpace(40),

            PrimaryButtonWidget(
              buttonText: "Create Account",
              onPress: () {
                log(email.text);
                if (formKey.currentState!.validate()) {
                  context.read<AuthCubit>().register(
                    email: email.text,
                    password: password.text,
                    username: username.text,
                  );
                }
              },
            ),

            const HeightSpace(8),

            Center(
              child: InkWell(
                onTap: () => context.pushReplacement(
                  AppRoutes.loginScreen,
                  extra: email.text,
                ),
                child: RichText(
                  text: TextSpan(
                    text: "Do you have an account? ",
                    style: AppStyles.black16w500Style.copyWith(
                      color: AppColors.secondaryColor,
                    ),
                    children: [
                      TextSpan(
                        text: "Login",
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
  }
}
