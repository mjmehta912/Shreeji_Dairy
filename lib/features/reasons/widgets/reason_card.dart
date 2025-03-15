import 'package:flutter/material.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/reasons/models/reason_dm.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/widgets/app_card1.dart';
import 'package:shreeji_dairy/widgets/app_title_value_row.dart';

class ReasonCard extends StatelessWidget {
  const ReasonCard({
    super.key,
    required this.reason,
    required this.onPressedEdit,
  });

  final ReasonDm reason;
  final VoidCallback onPressedEdit;

  @override
  Widget build(BuildContext context) {
    return AppCard1(
      child: Padding(
        padding: AppPaddings.p10,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTitleValueRow(
                    title: 'Reason',
                    value: reason.rName,
                  ),
                  AppTitleValueRow(
                    title: 'Use In',
                    value: reason.label,
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: onPressedEdit,
              child: Icon(
                Icons.edit_outlined,
                size: 20,
                color: kColorTextPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
