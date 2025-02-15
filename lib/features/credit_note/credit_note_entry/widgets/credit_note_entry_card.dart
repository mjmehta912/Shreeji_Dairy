import 'package:flutter/material.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/credit_note/credit_note_entry/controllers/credit_note_entry_controller.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_card1.dart';
import 'package:shreeji_dairy/widgets/app_title_value_row.dart';

class CreditNoteEntryCard extends StatelessWidget {
  const CreditNoteEntryCard({
    super.key,
    required this.item,
    required CreditNoteEntryController controller,
  }) : _controller = controller;

  final Map<String, dynamic> item;
  final CreditNoteEntryController _controller;

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
                child: Image.file(
                  item['image'],
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            AppSpaces.h10,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${item['itemName']} - ${item['skuPack']}',
                    style: TextStyles.kMediumFredoka(
                      fontSize: FontSizes.k18FontSize,
                    ).copyWith(
                      height: 1.25,
                    ),
                  ),
                  AppTitleValueRow(
                    title: 'Qty',
                    value: item['qty'],
                  ),
                  AppTitleValueRow(
                    title: 'Inv No.',
                    value: item['invNo'],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          _controller.deleteItem(
                            item['serialNo'],
                          );
                        },
                        child: Icon(
                          Icons.delete,
                          color: kColorRed,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
