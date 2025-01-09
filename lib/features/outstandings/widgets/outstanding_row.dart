import 'package:flutter/material.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';

class OutstandingRow extends StatelessWidget {
  const OutstandingRow({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyles.kRegularFredoka(
            fontSize: FontSizes.k14FontSize,
            color: kColorTextPrimary,
          ).copyWith(
            height: 1.25,
          ),
        ),
        AppSpaces.h10,
        Flexible(
          child: Text(
            value,
            style: TextStyles.kMediumFredoka(
              fontSize: FontSizes.k14FontSize,
              color: kColorSecondary,
            ).copyWith(
              height: 1.25,
            ),
          ),
        ),
      ],
    );
  }
}
