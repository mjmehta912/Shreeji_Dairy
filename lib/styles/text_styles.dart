import 'package:flutter/material.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/fonts.dart';

class TextStyles {
  static TextStyle kLightFredoka({
    double fontSize = FontSizes.k20FontSize,
    Color color = kColorBlack,
    FontWeight fontWeight = FontWeight.w300,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontFamily: Fonts.fredokaLight,
    );
  }

  static TextStyle kRegularFredoka({
    double fontSize = FontSizes.k20FontSize,
    Color color = kColorBlack,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontFamily: Fonts.fredokaRegular,
    );
  }

  static TextStyle kMediumFredoka({
    double fontSize = FontSizes.k20FontSize,
    Color color = kColorBlack,
    FontWeight fontWeight = FontWeight.w500,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontFamily: Fonts.fredokaMedium,
    );
  }

  static TextStyle kSemiBoldFredoka({
    double fontSize = FontSizes.k20FontSize,
    Color color = kColorBlack,
    FontWeight fontWeight = FontWeight.w600,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontFamily: Fonts.fredokaSemiBold,
    );
  }

  static TextStyle kBoldFredoka({
    double fontSize = FontSizes.k20FontSize,
    Color color = kColorBlack,
    FontWeight fontWeight = FontWeight.w700,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontFamily: Fonts.fredokaBold,
    );
  }
}
