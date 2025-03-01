import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/constants/image_constants.dart';
import 'package:shreeji_dairy/features/credit_note/credit_note_details/models/credit_note_detail_dm.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/extensions/app_size_extensions.dart';
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

  void _showImagePreview(String imageUrl) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 0.75.screenWidth,
                height: 0.75.screenWidth,
                child: Image.network(
                  imageUrl.startsWith('http') ? imageUrl : 'http://$imageUrl',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      kImageLogo,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
            Positioned(
              top: -12.5,
              right: -12.5,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: kColorBlackWithOpacity,
                  ),
                  padding: AppPaddings.p6,
                  child: Icon(
                    Icons.close,
                    color: kColorWhite,
                    size: 25,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
                    _showImagePreview(detail.imagePath);
                  },
                  child: Image.network(
                    detail.imagePath.startsWith('http')
                        ? detail.imagePath
                        : 'http://${detail.imagePath}',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        kImageLogo,
                        width: 80,
                        height: 80,
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
                      fontSize: FontSizes.k18FontSize,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
