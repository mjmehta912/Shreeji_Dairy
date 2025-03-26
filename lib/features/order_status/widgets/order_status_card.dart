import 'package:flutter/material.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/order_status/models/order_item_dm.dart';
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

  final OrderItemDm order;

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
            Text(
              order.iName,
              style: TextStyles.kMediumFredoka(
                fontSize: FontSizes.k16FontSize,
                color: kColorTextPrimary,
              ).copyWith(
                height: 1.25,
              ),
            ),
            AppTitleValueRow(
              title: 'Order No.',
              value: order.invNo,
            ),
            AppTitleValueRow(
              title: 'Order Date',
              value: order.date,
            ),
            AppTitleValueRow(
              title: 'Del. Date',
              value: order.dDate,
            ),
            AppTitleValueRow(
              title: 'Del. Time',
              value: order.dTime,
            ),
            AppTitleValueRow(
              title: 'Order Qty',
              value: order.orderQty.toString(),
            ),
            AppTitleValueRow(
              title: 'Approved Qty',
              value: order.approvedQty.toString(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  order.status == 0
                      ? 'PENDING'
                      : order.status == 1
                          ? 'APPROVED'
                          : order.status == 2
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
          ],
        ),
      ),
    );
  }
}
