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
  final List<dynamic> subMenus;

  CreditNoteApprovalMenuScreen({
    super.key,
    required this.subMenus,
  });

  final List<Map<String, dynamic>> creditNoteMenus = [
    {
      'subMenuId': 1,
      'subMenuName': 'Dock Approval',
      'icon': kIconDockApproval,
      'screen': DockApprovalScreen(),
    },
    {
      'subMenuId': 2,
      'subMenuName': 'QC Approval',
      'icon': kIconQcApproval,
      'screen': QcApprovalScreen(),
    },
    {
      'subMenuId': 3,
      'subMenuName': 'Accounting Approval',
      'icon': kIconAccountingApproval,
      'screen': AccountingApprovalScreen(),
    },
    {
      'subMenuId': 4,
      'subMenuName': 'Management Approval',
      'icon': kIconManagementApproval,
      'screen': ManagementApprovalScreen(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Filter accessible submenus
    List<Map<String, dynamic>> accessibleMenus = creditNoteMenus.where(
      (menu) {
        return subMenus.any((subMenu) =>
            subMenu.subMenuId == menu['subMenuId'] && subMenu.subMenuAccess);
      },
    ).toList();

    return Scaffold(
      backgroundColor: kColorWhite,
      appBar: AppAppbar(
        title: 'Credit Note Approval',
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios, size: 25, color: kColorTextPrimary),
        ),
      ),
      body: Padding(
        padding: AppPaddings.p10,
        child: accessibleMenus.isNotEmpty
            ? ListView.separated(
                itemCount: accessibleMenus.length,
                separatorBuilder: (context, index) =>
                    Divider(color: kColorTextPrimary),
                itemBuilder: (context, index) {
                  final menu = accessibleMenus[index];

                  return ListTile(
                    leading: SvgPicture.asset(
                      menu['icon'],
                      height: 25,
                      colorFilter:
                          ColorFilter.mode(kColorSecondary, BlendMode.srcIn),
                    ),
                    title: Text(
                      menu['subMenuName'],
                      style:
                          TextStyles.kRegularFredoka(color: kColorTextPrimary),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios,
                        size: 20, color: kColorTextPrimary),
                    onTap: () {
                      Widget screen = menu['screen']; // Cast as Widget
                      Get.to(() => screen);
                    },
                  );
                },
              )
            : Center(
                child: Text(
                  'No access to Credit Note Approval menus',
                  style: TextStyles.kRegularFredoka(color: kColorTextPrimary),
                ),
              ),
      ),
    );
  }
}
