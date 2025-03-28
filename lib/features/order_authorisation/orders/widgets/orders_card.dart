import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/order_authorisation/auth_order/screens/auth_order_screen.dart';
import 'package:shreeji_dairy/features/order_authorisation/orders/models/order_dm.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/extensions/app_size_extensions.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_button.dart';
import 'package:shreeji_dairy/widgets/app_card1.dart';
import 'package:shreeji_dairy/widgets/app_title_value_row.dart';

class OrdersCard extends StatelessWidget {
  const OrdersCard({
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
            AppSpaces.v10,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppButton(
                  buttonWidth: 0.35.screenWidth,
                  buttonHeight: 35,
                  title: 'View Detail',
                  titleSize: FontSizes.k16FontSize,
                  onPressed: () {
                    Get.to(
                      AuthOrderScreen(
                        invNo: order.invNo,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
