import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:order_tracking/core/styling/app_assets.dart';
import 'package:order_tracking/core/styling/app_styles.dart';
import 'package:order_tracking/core/widgets/custom_text_field.dart';
import 'package:order_tracking/core/widgets/primary_button_widget.dart';
import 'package:order_tracking/core/widgets/spacing_widgets.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.onSubmit,
  });
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;
  final VoidCallback onSubmit;
  @override
  Widget build(BuildContext context) {
    return AutofillGroup(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeightSpace(28),

            Text(
              "Login To Your Account",
              style: AppStyles.primaryHeadLinesStyle,
            ),
            const HeightSpace(8),
            Text(
              "It's great to see you again",
              style: AppStyles.grey12MediumStyle,
            ),
            const HeightSpace(20),
            Center(
              child: RepaintBoundary(
                child: Image.asset(
                  AppAssets.order,
                  width: 190.w,
                  height: 190.w,
                ),
              ),
            ),
            const HeightSpace(32),
            Text("Email", style: AppStyles.black16w500Style),
            const HeightSpace(8),
            CustomTextField(
              controller: emailController,
              hintText: "Enter your email",
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Email is required";
                }
                if (!RegExp(
                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                ).hasMatch(value)) {
                  return "Enter a valid email";
                }
                return null;
              },
            ),
            const HeightSpace(16),
            Text("Password", style: AppStyles.black16w500Style),
            const HeightSpace(8),
            CustomTextField(
              controller: passwordController,
              hintText: "Enter your password",
              obscure: true,
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              onFieldSubmitted: (_) {
                if (formKey.currentState!.validate()) {
                  onSubmit();
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Password is required";
                }
                if (value.length < 8) {
                  return "At least 8 characters";
                }
                if (!RegExp(r'[A-Z]').hasMatch(value)) {
                  return "Add one uppercase letter";
                }
                if (!RegExp(r'[a-z]').hasMatch(value)) {
                  return "Add one lowercase letter";
                }
                if (!RegExp(r'\d').hasMatch(value)) {
                  return "Add one number";
                }
                return null;
              },
            ),

            const HeightSpace(40),

            PrimaryButtonWidget(
              buttonText: "Sign in",
              onPress: () {
                if (formKey.currentState!.validate()) {
                  onSubmit();
                }
              },
            ),

            const HeightSpace(16),
          ],
        ),
      ),
    );
  }
}
