import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:order_tracking/core/styling/app_colors.dart';
import 'package:order_tracking/core/styling/app_styles.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.validator,
    this.keyboardType,
    this.autofillHints,
    this.textInputAction,
    this.onFieldSubmitted,
    this.enabled = true,
    this.maxLines = 1,
    this.obscure = false,
    this.onEditingComplete,
    this.readOnly = false,
  });

  final TextEditingController controller;
  final String? hintText;
  final bool enabled;
  final bool obscure;
  final int maxLines;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final VoidCallback? onEditingComplete;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      controller: controller,
      validator: validator,
      autofillHints: autofillHints,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      onEditingComplete: onEditingComplete,
      enabled: enabled,
      maxLines: obscure ? 1 : maxLines,
      obscureText: obscure,
      obscuringCharacter: '•',
      cursorColor: AppColors.primaryColor,
      decoration: InputDecoration(
        hintText: hintText,
        alignLabelWithHint: false,
        labelText: hintText,
        labelStyle: AppStyles.grey12MediumStyle,
        contentPadding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
        enabledBorder: _border(const Color(0xffE8ECF4)),
        focusedBorder: _border(AppColors.primaryColor),
        errorBorder: _border(Colors.red),
        focusedErrorBorder: _border(Colors.red),
        filled: true,
        fillColor: const Color(0xffF7F8F9),
      ),
    );
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide(color: color),
    );
  }
}
