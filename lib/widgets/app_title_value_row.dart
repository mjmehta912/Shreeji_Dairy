import 'package:flutter/material.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';

class AppTitleValueRow extends StatelessWidget {
  const AppTitleValueRow({
    super.key,
    required this.title,
    required this.value,
    this.titleStyle,
    this.valueStyle,
    this.color,
  });

  final String title;
  final String value;
  final TextStyle? titleStyle;
  final TextStyle? valueStyle;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return RichText(
          text: TextSpan(
            style: TextStyles.kLightFredoka(
              fontSize: FontSizes.k16FontSize,
            ).copyWith(
              height: 1.25,
            ),
            children: [
              TextSpan(text: "$title : "),
              TextSpan(
                text: value,
                style: TextStyles.kRegularFredoka(
                  fontSize: FontSizes.k16FontSize,
                  color: color ?? kColorTextPrimary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
