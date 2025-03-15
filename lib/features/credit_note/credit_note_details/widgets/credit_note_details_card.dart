import 'package:flutter/material.dart';
import 'package:shreeji_dairy/constants/image_constants.dart';
import 'package:shreeji_dairy/features/credit_note/credit_note_details/models/credit_note_detail_dm.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_card1.dart';
import 'package:shreeji_dairy/widgets/app_title_value_row.dart';

class CreditNoteDetailsCard extends StatelessWidget {
  const CreditNoteDetailsCard({
    super.key,
    required this.detail,
  });

  final CreditNoteDetailDm detail;

  @override
  Widget build(BuildContext context) {
    return AppCard1(
      child: Padding(
        padding: AppPaddings.p12,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: GestureDetector(
                  onTap: () {
                    showImagePreview(detail.imagePath);
                  },
                  child: Image.network(
                    detail.imagePath.startsWith('http')
                        ? detail.imagePath
                        : 'http://${detail.imagePath}',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        kImageLogo,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
              ),
            ),
            AppSpaces.h10,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    detail.iName,
                    style: TextStyles.kMediumFredoka(
                      fontSize: FontSizes.k16FontSize,
                    ).copyWith(
                      height: 1.25,
                    ),
                  ),
                  AppTitleValueRow(
                    title: 'Qty',
                    value: detail.qty.toString(),
                  ),
                  AppTitleValueRow(
                    title: 'Inv No',
                    value: detail.invNo,
                  ),
                  AppTitleValueRow(
                    title: 'Status',
                    value: detail.statusText,
                  ),
                  if (detail.reason.isNotEmpty)
                    AppTitleValueRow(
                      title: 'Reason',
                      value: detail.reason,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
