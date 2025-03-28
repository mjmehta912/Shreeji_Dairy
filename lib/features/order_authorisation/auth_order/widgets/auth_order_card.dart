import 'package:flutter/material.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/order_authorisation/auth_order/models/order_detail_dm.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/extensions/app_size_extensions.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_button.dart';
import 'package:shreeji_dairy/widgets/app_card1.dart';
import 'package:shreeji_dairy/widgets/app_title_value_row.dart';

class AuthOrderCard extends StatelessWidget {
  const AuthOrderCard({
    super.key,
    required this.orderDetail,
    required this.onAccept,
    required this.onReject,
    required this.onHold,
  });

  final OrderDetailDm orderDetail;

  final VoidCallback onAccept;
  final VoidCallback onReject;
  final VoidCallback onHold;

  @override
  Widget build(BuildContext context) {
    return AppCard1(
      child: Padding(
        padding: AppPaddings.p10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              orderDetail.pName,
              style: TextStyles.kMediumFredoka(
                fontSize: FontSizes.k16FontSize,
                color: kColorSecondary,
              ).copyWith(
                height: 1.25,
              ),
            ),
            Text(
              orderDetail.iName,
              style: TextStyles.kMediumFredoka(
                fontSize: FontSizes.k16FontSize,
                color: kColorTextPrimary,
              ).copyWith(
                height: 1.25,
              ),
            ),
            AppTitleValueRow(
              title: 'Order No.',
              value: orderDetail.invNo,
            ),
            AppTitleValueRow(
              title: 'Order Date',
              value: orderDetail.date,
            ),
            AppTitleValueRow(
              title: 'Del. Date',
              value: orderDetail.dDate,
            ),
            AppTitleValueRow(
              title: 'Del. Time',
              value: orderDetail.dTime,
            ),
            AppTitleValueRow(
              title: 'Order Qty',
              value: orderDetail.orderQty.toString(),
            ),
            AppTitleValueRow(
              title: 'Approved Qty',
              value: orderDetail.approvedQty.toString(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  orderDetail.status == 0
                      ? 'PENDING'
                      : orderDetail.status == 1
                          ? 'APPROVED'
                          : orderDetail.status == 2
                              ? 'HOLD'
                              : 'REJECTED',
                  style: TextStyles.kMediumFredoka(
                    fontSize: FontSizes.k16FontSize,
                    color: kColorSecondary,
                  ).copyWith(
                    height: 1.25,
                  ),
                ),
              ],
            ),
            AppSpaces.v10,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (orderDetail.status == 0 || orderDetail.status == 2)
                  AppButton(
                    buttonWidth: 0.2.screenWidth,
                    buttonHeight: 35,
                    buttonColor: kColorRed,
                    titleSize: FontSizes.k16FontSize,
                    title: 'Reject',
                    onPressed: onReject,
                  ),
                if (orderDetail.status == 0)
                  AppButton(
                    buttonWidth: 0.2.screenWidth,
                    buttonHeight: 35,
                    buttonColor: kColorPrimary,
                    titleSize: FontSizes.k16FontSize,
                    title: 'Hold',
                    titleColor: kColorTextPrimary,
                    onPressed: onHold,
                  ),
                if (orderDetail.status == 0 || orderDetail.status == 2)
                  AppButton(
                    buttonWidth: 0.2.screenWidth,
                    buttonHeight: 35,
                    buttonColor: kColorSecondary,
                    titleSize: FontSizes.k16FontSize,
                    title: 'Accept',
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
