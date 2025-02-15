import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/credit_note_approval/accounting_approval/controllers/accounting_approval_controller.dart';
import 'package:shreeji_dairy/features/credit_note_approval/accounting_approval/widgets/accounting_approval_card.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/widgets/app_appbar.dart';
import 'package:shreeji_dairy/widgets/app_loading_overlay.dart';

class AccountingApprovalScreen extends StatelessWidget {
  AccountingApprovalScreen({
    super.key,
  });

  final AccountingApprovalController _controller = Get.put(
    AccountingApprovalController(),
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          child: Scaffold(
            backgroundColor: kColorWhite,
            appBar: AppAppbar(
              title: 'Accounting Approval',
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
              padding: AppPaddings.p12,
              child: Obx(
                () {
                  return ListView.builder(
                    itemCount: _controller.itemsForApproval.length,
                    itemBuilder: (context, index) {
                      final item = _controller.itemsForApproval[index];

                      return AccountingApprovalCard(
                        item: item,
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
        Obx(
          () => AppLoadingOverlay(
            isLoading: _controller.isLoading.value,
          ),
        ),
      ],
    );
  }
}
