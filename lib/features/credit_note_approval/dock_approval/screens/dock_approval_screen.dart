import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/credit_note_approval/dock_approval/controllers/dock_approval_controller.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_appbar.dart';
import 'package:shreeji_dairy/widgets/app_card2.dart';
import 'package:shreeji_dairy/widgets/app_loading_overlay.dart';

class DockApprovalScreen extends StatelessWidget {
  DockApprovalScreen({
    super.key,
  });

  final DockApprovalController _controller = Get.put(
    DockApprovalController(),
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          child: Scaffold(
            backgroundColor: kColorWhite,
            appBar: AppAppbar(
              title: 'Dock Approval',
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

                      return AppCard2(
                        child: Padding(
                          padding: AppPaddings.p10,
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  item.imagePath!.startsWith('http')
                                      ? item.imagePath!
                                      : 'http://${item.imagePath!}',
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              AppSpaces.h10,
                              Expanded(
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Item',
                                          style: TextStyles.kRegularFredoka(
                                            fontSize: FontSizes.k16FontSize,
                                          ).copyWith(
                                            height: 1.25,
                                          ),
                                        ),
                                        AppSpaces.h10,
                                        Expanded(
                                          child: Text(
                                            item.iName != null &&
                                                    item.iName!.isNotEmpty
                                                ? item.iName!
                                                : '',
                                            style: TextStyles.kMediumFredoka(
                                              fontSize: FontSizes.k16FontSize,
                                            ).copyWith(
                                              height: 1.25,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Party',
                                          style: TextStyles.kRegularFredoka(
                                            fontSize: FontSizes.k16FontSize,
                                          ).copyWith(
                                            height: 1.25,
                                          ),
                                        ),
                                        AppSpaces.h10,
                                        Expanded(
                                          child: Text(
                                            item.pName != null &&
                                                    item.pName!.isNotEmpty
                                                ? item.pName!
                                                : '',
                                            style: TextStyles.kMediumFredoka(
                                              fontSize: FontSizes.k16FontSize,
                                            ).copyWith(
                                              height: 1.25,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Entry Date',
                                          style: TextStyles.kRegularFredoka(
                                            fontSize: FontSizes.k16FontSize,
                                          ).copyWith(
                                            height: 1.25,
                                          ),
                                        ),
                                        AppSpaces.h10,
                                        Text(
                                          item.date != null &&
                                                  item.date!.isNotEmpty
                                              ? item.date!
                                              : '',
                                          style: TextStyles.kMediumFredoka(
                                            fontSize: FontSizes.k16FontSize,
                                          ).copyWith(
                                            height: 1.25,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
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
