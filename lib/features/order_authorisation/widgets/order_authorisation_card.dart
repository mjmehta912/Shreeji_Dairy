import 'package:flutter/material.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/order_authorisation/models/order_dm.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/widgets/app_card1.dart';
import 'package:shreeji_dairy/widgets/app_title_value_row.dart';

class OrderAuthorisationCard extends StatelessWidget {
  const OrderAuthorisationCard({
    super.key,
    required this.order,
  });

  final OrderDm order;

  @override
  Widget build(BuildContext context) {
    return AppCard1(
      child: Padding(
        padding: AppPaddings.p10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              order.pName,
              style: TextStyles.kMediumFredoka(
                fontSize: FontSizes.k16FontSize,
                color: kColorSecondary,
              ).copyWith(
                height: 1.25,
              ),
            ),
            AppTitleValueRow(
              title: 'Inv No.',
              value: order.invNo,
            ),
            AppTitleValueRow(
              title: 'Date',
              value: order.date,
            ),
            AppTitleValueRow(
              title: 'Status',
              value: order.statusDesc,
            ),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     Text(
            //       order.status == 0
            //           ? 'PENDING'
            //           : order.status == 1
            //               ? 'APPROVED'
            //               : order.status == 2
            //                   ? 'HOLD'
            //                   : 'REJECTED',
            //       style: TextStyles.kMediumFredoka(
            //         fontSize: FontSizes.k16FontSize,
            //         color: kColorSecondary,
            //       ).copyWith(
            //         height: 1.25,
            //       ),
            //     ),
            //   ],
            // ),
            // AppSpaces.v10,
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     AppButton(
            //       buttonWidth: 0.25.screenWidth,
            //       buttonHeight: 35,
            //       buttonColor: kColorRed,
            //       title: 'Reject',
            //       titleSize: FontSizes.k16FontSize,
            //       onPressed: onReject,
            //     ),
            //     if (order.status == 0)
            //       AppButton(
            //         buttonWidth: 0.25.screenWidth,
            //         buttonHeight: 35,
            //         buttonColor: kColorPrimary,
            //         title: 'Hold',
            //         titleColor: kColorBlack,
            //         titleSize: FontSizes.k16FontSize,
            //         onPressed: onHold,
            //       ),
            //     AppButton(
            //       buttonWidth: 0.25.screenWidth,
            //       buttonHeight: 35,
            //       buttonColor: kColorSecondary,
            //       title: 'Accept',
            //       titleSize: FontSizes.k16FontSize,
            //       onPressed: onAccept,
            //     ),
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
