import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/constants/image_constants.dart';
import 'package:shreeji_dairy/features/credit_note_approval/accounting_approval/screens/accounting_approval_screen.dart';
import 'package:shreeji_dairy/features/credit_note_approval/dock_approval/screens/dock_approval_screen.dart';
import 'package:shreeji_dairy/features/credit_note_approval/management_approval/screens/management_approval_screen.dart';
import 'package:shreeji_dairy/features/credit_note_approval/qc_approval/screens/qc_approval_screen.dart';
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
              leading: SvgPicture.asset(
                kIconDockApproval,
                height: 25,
                colorFilter: ColorFilter.mode(
                  kColorSecondary,
                  BlendMode.srcIn,
                ),
              ),
              title: Text(
                'Dock Approval',
                style: TextStyles.kRegularFredoka(
                  color: kColorTextPrimary,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: kColorTextPrimary,
              ),
              onTap: () {
                Get.to(
                  () => DockApprovalScreen(),
                );
              },
            ),
            Divider(
              color: kColorTextPrimary,
            ),
            ListTile(
              leading: SvgPicture.asset(
                kIconQcApproval,
                height: 25,
                colorFilter: ColorFilter.mode(
                  kColorSecondary,
                  BlendMode.srcIn,
                ),
              ),
              title: Text(
                'QC Approval',
                style: TextStyles.kRegularFredoka(
                  color: kColorTextPrimary,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: kColorTextPrimary,
              ),
              onTap: () {
                Get.to(
                  () => QcApprovalScreen(),
                );
              },
            ),
            Divider(
              color: kColorTextPrimary,
            ),
            ListTile(
              leading: SvgPicture.asset(
                kIconAccountingApproval,
                height: 25,
                colorFilter: ColorFilter.mode(
                  kColorSecondary,
                  BlendMode.srcIn,
                ),
              ),
              title: Text(
                'Accounting Approval',
                style: TextStyles.kRegularFredoka(
                  color: kColorTextPrimary,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: kColorTextPrimary,
              ),
              onTap: () {
                Get.to(
                  () => AccountingApprovalScreen(),
                );
              },
            ),
            Divider(
              color: kColorTextPrimary,
            ),
            ListTile(
              leading: SvgPicture.asset(
                kIconManagementApproval,
                height: 25,
                colorFilter: ColorFilter.mode(
                  kColorSecondary,
                  BlendMode.srcIn,
                ),
              ),
              title: Text(
                'Management Approval',
                style: TextStyles.kRegularFredoka(
                  color: kColorTextPrimary,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: kColorTextPrimary,
              ),
              onTap: () {
                Get.to(
                  () => ManagementApprovalScreen(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
