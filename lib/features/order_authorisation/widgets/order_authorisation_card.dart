import 'package:flutter/material.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/order_authorisation/models/order_dm.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/extensions/app_size_extensions.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_button.dart';
import 'package:shreeji_dairy/widgets/app_card1.dart';
import 'package:shreeji_dairy/widgets/app_title_value_row.dart';

class OrderAuthorisationCard extends StatelessWidget {
  const OrderAuthorisationCard({
    super.key,
    required this.order,
    required this.onAccept,
    required this.onHold,
    required this.onReject,
  });

  final OrderDm order;
  final VoidCallback onAccept;
  final VoidCallback onHold;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    return AppCard1(
      child: Padding(
        padding: AppPaddings.p10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              order.iName,
              style: TextStyles.kMediumFredoka(
                fontSize: FontSizes.k18FontSize,
                color: kColorSecondary,
              ),
            ),
            AppTitleValueRow(
              title: 'Order No.',
              value: order.invNo,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppTitleValueRow(
                  title: 'Order Date',
                  value: order.date,
                ),
                AppTitleValueRow(
                  title: 'Order Qty',
                  value: order.orderQty.toString(),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppTitleValueRow(
                  title: 'Del. Date',
                  value: order.dDate,
                ),
                AppTitleValueRow(
                  title: 'Del. Time',
                  value: order.dTime,
                ),
              ],
            ),
            AppTitleValueRow(
              title: 'status',
              value: order.status == 0
                  ? 'Pending'
                  : order.status == 1
                      ? 'Approved'
                      : order.status == 2
                          ? 'Hold'
                          : 'Rejected',
            ),
            AppSpaces.v10,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppButton(
                  buttonWidth: 0.25.screenWidth,
                  buttonHeight: 35,
                  buttonColor: kColorRed,
                  title: 'Reject',
                  titleSize: FontSizes.k16FontSize,
                  onPressed: onReject,
                ),
                if (order.status == 0)
                  AppButton(
                    buttonWidth: 0.25.screenWidth,
                    buttonHeight: 35,
                    buttonColor: kColorPrimary,
                    title: 'Hold',
                    titleColor: kColorBlack,
                    titleSize: FontSizes.k16FontSize,
                    onPressed: onHold,
                  ),
                AppButton(
                  buttonWidth: 0.25.screenWidth,
                  buttonHeight: 35,
                  buttonColor: kColorSecondary,
                  title: 'Accept',
                  titleSize: FontSizes.k16FontSize,
                  onPressed: onAccept,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
