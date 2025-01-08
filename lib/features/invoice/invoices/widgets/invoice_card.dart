import 'package:flutter/material.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/invoice/invoices/models/invoice_dm.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/extensions/app_size_extensions.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_button.dart';
import 'package:shreeji_dairy/widgets/app_card2.dart';

class InvoiceCard extends StatelessWidget {
  const InvoiceCard({
    super.key,
    required this.invoice,
  });

  final InvoiceDm invoice;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppCard2(
          child: Padding(
            padding: AppPaddings.p10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  invoice.pname,
                  style: TextStyles.kMediumFredoka(
                    color: kColorTextPrimary,
                    fontSize: FontSizes.k18FontSize,
                  ).copyWith(
                    height: 1.25,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          invoice.invNo,
                          style: TextStyles.kRegularFredoka(
                            color: kColorTextPrimary,
                            fontSize: FontSizes.k14FontSize,
                          ).copyWith(
                            height: 1.25,
                          ),
                        ),
                        Text(
                          invoice.date,
                          style: TextStyles.kRegularFredoka(
                            color: kColorTextPrimary,
                            fontSize: FontSizes.k14FontSize,
                          ).copyWith(
                            height: 1.25,
                          ),
                        ),
                        Text(
                          invoice.status,
                          style: TextStyles.kRegularFredoka(
                            color: kColorTextPrimary,
                            fontSize: FontSizes.k14FontSize,
                          ).copyWith(
                            height: 1.25,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '₹ ${invoice.amount.toString()}',
                      style: TextStyles.kMediumFredoka(
                        color: kColorSecondary,
                        fontSize: FontSizes.k18FontSize,
                      ).copyWith(
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppButton(
                      buttonHeight: 30,
                      buttonWidth: 0.2.screenWidth,
                      buttonColor: kColorPrimary,
                      titleSize: FontSizes.k16FontSize,
                      titleColor: kColorTextPrimary,
                      title: 'View',
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        AppSpaces.v4,
      ],
    );
  }
}
