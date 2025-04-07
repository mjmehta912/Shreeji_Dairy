import 'package:flutter/material.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/order_status/models/order_item_dm.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
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
            Row(
              children: [
                AppTitleValueRow(
                  title: 'Ord. Qty',
                  value: order.orderQty.toString(),
                ),
                AppSpaces.h10,
                AppTitleValueRow(
                  title: 'Approved Qty',
                  value: order.approvedQty.toString(),
                ),
              ],
            ),
            AppTitleValueRow(
              title: 'Dispatched Qty',
              value: order.dispatched.toString(),
            ),
            AppSpaces.v10,
            Padding(
              padding: AppPaddings.p10,
              child: buildProgressWithFloatingDot(order.percentage.toDouble()),
            ),
            AppSpaces.v10,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  (order.dispatched == order.approvedQty) &&
                          order.approvedQty != 0
                      ? 'DELIVERED'
                      : order.status == 0
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

  Widget buildProgressWithFloatingDot(double percentage) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double progress = percentage / 100;

        return TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: progress),
          duration: Duration(milliseconds: 500),
          curve: Curves.easeOut,
          builder: (context, value, _) {
            double maxWidth = constraints.maxWidth;
            double animatedCirclePosition = maxWidth * value;

            return Stack(
              clipBehavior: Clip.none,
              children: [
                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    minHeight: 9,
                    value: value,
                    backgroundColor: kColorLightGrey,
                    valueColor: AlwaysStoppedAnimation<Color>(kColorGreen),
                  ),
                ),

                // Animated floating dot
                Positioned(
                  left: animatedCirclePosition - 9, // center the dot
                  top: -6,
                  bottom: -6,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: kColorGreen,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: kColorWhite,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
