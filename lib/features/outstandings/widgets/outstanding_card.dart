import 'package:flutter/material.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/outstandings/models/outstanding_dm.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_card1.dart';
import 'package:shreeji_dairy/widgets/app_title_value_row.dart';

class OutstandingCard extends StatelessWidget {
  const OutstandingCard({
    super.key,
    required this.outstanding,
  });

  final OutstandingDataDm outstanding;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppCard1(
          child: Padding(
            padding: AppPaddings.p8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  outstanding.invNo,
                  style: TextStyles.kMediumFredoka(
                    fontSize: FontSizes.k16FontSize,
                    color: kColorTextPrimary,
                  ).copyWith(
                    height: 1.25,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppTitleValueRow(
                      title: 'Date',
                      value: outstanding.date,
                    ),
                    AppTitleValueRow(
                      title: 'Due Date',
                      value: outstanding.dueDate,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppTitleValueRow(
                      title: 'Amount',
                      value: outstanding.amount.toString(),
                      color: kColorSecondary,
                    ),
                    AppTitleValueRow(
                      title: 'Outstanding',
                      value: outstanding.outstanding.toString(),
                      color: kColorSecondary,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppTitleValueRow(
                      title: 'Paid',
                      value: outstanding.paidAmount,
                      color: outstanding.runningTotal.contains('-')
                          ? kColorRed
                          : kColorGreen,
                    ),
                    Text(
                      outstanding.runningTotal,
                      style: TextStyles.kMediumFredoka(
                        fontSize: FontSizes.k16FontSize,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        AppSpaces.v2,
      ],
    );
  }
}
