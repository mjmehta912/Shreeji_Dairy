import 'package:flutter/material.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/order_authorisation/auth_order/models/order_detail_dm.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_card1.dart';
import 'package:shreeji_dairy/widgets/app_title_value_row.dart';

class OrderStatusDetailCard extends StatelessWidget {
  const OrderStatusDetailCard({
    super.key,
    required this.orderDetail,
  });

  final OrderDetailDm orderDetail;

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
            if (orderDetail.challanNo.isNotEmpty)
              AppTitleValueRow(
                title: 'Challan No.',
                value: orderDetail.challanNo,
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
            AppTitleValueRow(
              title: 'Dispatched Qty',
              value: orderDetail.dispatched.toString(),
            ),
            AppSpaces.v10,
            Padding(
              padding: AppPaddings.p10,
              child: buildProgressWithFloatingDot(
                orderDetail.percentage.toDouble(),
              ),
            ),
            AppSpaces.v10,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  orderDetail.orderStatus,
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
