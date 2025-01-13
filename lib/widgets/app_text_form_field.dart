import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/utils/extensions/app_size_extensions.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';

class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    super.key,
    required this.controller,
    this.enabled,
    this.maxLines,
    this.minLines,
    this.onChanged,
    this.validator,
    required this.hintText,
    this.keyboardType,
    this.fillColor,
    this.suffixIcon,
    this.isObscure = false,
    this.inputFormatters,
  });

  final TextEditingController controller;
  final bool? enabled;
  final int? maxLines;
  final int? minLines;
  final void Function(String value)? onChanged;
  final String? Function(String? value)? validator;
  final String hintText;
  final TextInputType? keyboardType;
  final Color? fillColor;
  final Widget? suffixIcon;
  final bool? isObscure;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorColor: kColorTextPrimary,
      cursorHeight: 20,
      inputFormatters: inputFormatters,
      enabled: enabled ?? true,
      maxLines: maxLines ?? 1,
      minLines: minLines ?? 1,
      validator: validator,
      onChanged: onChanged,
      keyboardType: keyboardType ?? TextInputType.text,
      style: TextStyles.kRegularFredoka(
        fontSize: FontSizes.k16FontSize,
        color: kColorTextPrimary,
      ),
      obscureText: isObscure!,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyles.kLightFredoka(
          fontSize: FontSizes.k16FontSize,
          color: kColorGrey,
        ),
        errorStyle: TextStyles.kRegularFredoka(
          fontSize: FontSizes.k16FontSize,
          color: kColorRed,
        ),
        border: outlineInputBorder(
          borderColor: kColorLightGrey,
          borderWidth: 1,
        ),
        focusedBorder: outlineInputBorder(
          borderColor: kColorTextPrimary,
          borderWidth: 1,
        ),
        enabledBorder: outlineInputBorder(
          borderColor: kColorLightGrey,
          borderWidth: 1,
        ),
        errorBorder: outlineInputBorder(
          borderColor: kColorRed,
          borderWidth: 1,
        ),
        contentPadding: AppPaddings.combined(
          horizontal: 16.appWidth,
          vertical: 8.appHeight,
        ),
        filled: true,
        fillColor: fillColor ?? kColorLightGrey,
        suffixIcon: suffixIcon,
        suffixIconColor: kColorTextPrimary,
      ),
    );
  }

  OutlineInputBorder outlineInputBorder({
    required Color borderColor,
    required double borderWidth,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: borderColor,
        width: borderWidth,
      ),
    );
  }
}
