import 'package:flutter/material.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/order_authorisation/models/order_dm.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/widgets/app_card1.dart';
import 'package:shreeji_dairy/widgets/app_title_value_row.dart';

class OrderStatusCard extends StatelessWidget {
  const OrderStatusCard({
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
              order.iName,
              style: TextStyles.kMediumFredoka(
                fontSize: FontSizes.k18FontSize,
                color: kColorSecondary,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppTitleValueRow(
                  title: 'Order No.',
                  value: order.invNo,
                ),
                AppTitleValueRow(
                  title: 'Order Date',
                  value: order.date,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppTitleValueRow(
                  title: 'Order Qty',
                  value: order.orderQty.toString(),
                ),
                AppTitleValueRow(
                  title: 'Approved Qty',
                  value: order.approvedQty.toString(),
                ),
              ],
            ),
            AppTitleValueRow(
              title: 'Status',
              value: order.status == 0
                  ? 'Pending'
                  : order.status == 1
                      ? 'Approved'
                      : order.status == 2
                          ? 'Hold'
                          : 'Rejected',
            ),
          ],
        ),
      ),
    );
  }
}
