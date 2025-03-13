import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/features/credit_note/credit_note_details/screens/credit_note_details_screen.dart';
import 'package:shreeji_dairy/features/credit_note/credit_notes/models/credit_note_dm.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/widgets/app_card1.dart';
import 'package:shreeji_dairy/widgets/app_title_value_row.dart';

class CreditNotesCard extends StatelessWidget {
  const CreditNotesCard({
    super.key,
    required this.creditNote,
  });

  final CreditNoteDm creditNote;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => CreditNoteDetailsScreen(
            invNo: creditNote.invNo,
          ),
        );
      },
      child: AppCard1(
        child: Padding(
          padding: AppPaddings.p10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTitleValueRow(
                title: 'Credit Note No.',
                value: creditNote.invNo,
              ),
              AppTitleValueRow(
                title: 'Party',
                value: creditNote.pName,
              ),
              AppTitleValueRow(
                title: 'Remark',
                value:
                    creditNote.remark != null && creditNote.remark!.isNotEmpty
                        ? creditNote.remark!
                        : 'N/A',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
