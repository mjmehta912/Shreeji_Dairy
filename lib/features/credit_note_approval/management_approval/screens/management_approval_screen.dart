import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/credit_note_approval/management_approval/controllers/management_approval_controller.dart';
import 'package:shreeji_dairy/features/credit_note_approval/management_approval/widgets/management_approval_card.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/widgets/app_appbar.dart';
import 'package:shreeji_dairy/widgets/app_loading_overlay.dart';

class ManagementApprovalScreen extends StatelessWidget {
  ManagementApprovalScreen({
    super.key,
  });

  final ManagementApprovalController _controller = Get.put(
    ManagementApprovalController(),
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          child: Scaffold(
            backgroundColor: kColorWhite,
            appBar: AppAppbar(
              title: 'Management Approval',
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
              child: Column(
                children: [
                  Obx(
                    () {
                      if (_controller.itemsForApproval.isEmpty &&
                          !_controller.isLoading.value) {
                        return Expanded(
                          child: Center(
                            child: Text(
                              'No credit notes found.',
                              style: TextStyles.kRegularFredoka(),
                            ),
                          ),
                        );
                      }
                      return Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _controller.itemsForApproval.length,
                          itemBuilder: (context, index) {
                            final item = _controller.itemsForApproval[index];

                            return ManagementApprovalCard(
                              item: item,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
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
