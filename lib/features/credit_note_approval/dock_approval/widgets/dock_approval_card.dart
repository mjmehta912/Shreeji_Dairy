import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/credit_note_approval/dock_approval/models/item_for_approval_dm.dart';
import 'package:shreeji_dairy/utils/extensions/app_size_extensions.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_card1.dart';
import 'package:shreeji_dairy/widgets/app_title_value_row.dart';

class DockApprovalCard extends StatelessWidget {
  const DockApprovalCard({
    super.key,
    required this.item,
  });

  final ItemForApprovalDm item;

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
        padding: AppPaddings.p10,
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                _showImagePreview(item.imagePath!);
              },
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    item.imagePath!.startsWith('http')
                        ? item.imagePath!
                        : 'http://${item.imagePath!}',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            AppSpaces.h10,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTitleValueRow(
                    title: 'Item',
                    value: item.iName != null && item.iName!.isNotEmpty
                        ? item.iName!
                        : '',
                  ),
                  AppTitleValueRow(
                    title: 'Party',
                    value: item.pName != null && item.pName!.isNotEmpty
                        ? item.pName!
                        : '',
                  ),
                  AppTitleValueRow(
                    title: 'Entry Date',
                    value: item.date != null && item.date!.isNotEmpty
                        ? item.date!
                        : '',
                  ),
                  AppTitleValueRow(
                    title: 'Bill No.',
                    value: item.billNo != null && item.billNo!.isNotEmpty
                        ? item.billNo!
                        : '',
                  ),
                  AppTitleValueRow(
                    title: 'Qty',
                    value: item.qty != null && item.qty!.toString().isNotEmpty
                        ? item.qty!.toString()
                        : '0',
                  ),
                  AppTitleValueRow(
                    title: 'Status',
                    value: item.status != null &&
                            item.status!.toString().isNotEmpty
                        ? item.statusText
                        : '',
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
