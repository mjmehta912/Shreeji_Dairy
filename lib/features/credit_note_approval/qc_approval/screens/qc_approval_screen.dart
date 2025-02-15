import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/credit_note_approval/qc_approval/controllers/qc_approval_controller.dart';
import 'package:shreeji_dairy/features/credit_note_approval/qc_approval/widgets/qc_approval_card.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/widgets/app_appbar.dart';
import 'package:shreeji_dairy/widgets/app_loading_overlay.dart';

class QcApprovalScreen extends StatelessWidget {
  QcApprovalScreen({
    super.key,
  });

  final QcApprovalController _controller = Get.put(
    QcApprovalController(),
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          child: Scaffold(
            backgroundColor: kColorWhite,
            appBar: AppAppbar(
              title: 'QC Approval',
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

                      return QcApprovalCard(
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
