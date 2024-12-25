import 'package:flutter/material.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    this.buttonHeight,
    this.buttonWidth,
    this.buttonColor,
    required this.title,
    this.titleSize,
    this.titleColor,
    required this.onPressed,
  });

  final double? buttonHeight;
  final double? buttonWidth;
  final Color? buttonColor;

  final String title;
  final double? titleSize;
  final Color? titleColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: buttonHeight ?? 55,
      width: buttonWidth ?? double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor ?? kColorSecondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyles.kRegularFredoka(
            fontSize: titleSize ?? FontSizes.k20FontSize,
            color: titleColor ?? kColorWhite,
          ),
        ),
      ),
    );
  }
}
