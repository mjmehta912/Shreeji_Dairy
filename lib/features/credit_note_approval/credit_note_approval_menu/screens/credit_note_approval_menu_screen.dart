import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/credit_note_approval/dock_approval/screens/dock_approval_screen.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/widgets/app_appbar.dart';

class CreditNoteApprovalMenuScreen extends StatelessWidget {
  const CreditNoteApprovalMenuScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorWhite,
      appBar: AppAppbar(
        title: 'Credit Note Approval',
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back_ios,
            size: 25,
            color: kColorTextPrimary,
          ),
        ),
      ),
      body: Padding(
        padding: AppPaddings.p10,
        child: ListView(
          children: [
            ListTile(
              title: Text(
                'Dock Approval',
                style: TextStyles.kRegularFredoka(
                  color: kColorSecondary,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: kColorSecondary,
              ),
              onTap: () {
                Get.to(
                  () => DockApprovalScreen(),
                );
              },
            ),
            Divider(
              color: kColorSecondary,
            ),
            ListTile(
              title: Text(
                'QC Approval',
                style: TextStyles.kRegularFredoka(
                  color: kColorSecondary,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: kColorSecondary,
              ),
              onTap: () {},
            ),
            Divider(
              color: kColorSecondary,
            ),
            ListTile(
              title: Text(
                'Accounting Approval',
                style: TextStyles.kRegularFredoka(
                  color: kColorSecondary,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: kColorSecondary,
              ),
              onTap: () {},
            ),
            Divider(
              color: kColorSecondary,
            ),
            ListTile(
              title: Text(
                'Management Approval',
                style: TextStyles.kRegularFredoka(
                  color: kColorSecondary,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: kColorSecondary,
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
