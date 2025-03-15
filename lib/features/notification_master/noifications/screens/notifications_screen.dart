import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/notification_master/noifications/controllers/notifications_controller.dart';
import 'package:shreeji_dairy/features/notification_master/notification_recievers/screens/notification_recievers_screen.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_appbar.dart';
import 'package:shreeji_dairy/widgets/app_card1.dart';
import 'package:shreeji_dairy/widgets/app_loading_overlay.dart';
import 'package:shreeji_dairy/widgets/app_text_form_field.dart';

class NotificationsScreen extends StatelessWidget {
  NotificationsScreen({
    super.key,
  });

  final NotificationsController _controller = Get.put(
    NotificationsController(),
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            backgroundColor: kColorWhite,
            appBar: AppAppbar(
              title: 'Notifications',
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
              child: Column(
                children: [
                  AppTextFormField(
                    controller: _controller.searchController,
                    hintText: 'Search',
                    onChanged: _controller.searchNotifications,
                  ),
                  AppSpaces.v10,
                  Obx(
                    () {
                      if (_controller.filteredNotifications.isEmpty &&
                          !_controller.isLoading.value) {
                        return Expanded(
                          child: Center(
                            child: Text(
                              'No notifications found.',
                              style: TextStyles.kRegularFredoka(),
                            ),
                          ),
                        );
                      }
                      return Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _controller.filteredNotifications.length,
                          itemBuilder: (context, index) {
                            final notification =
                                _controller.filteredNotifications[index];

                            return GestureDetector(
                              onTap: () {
                                Get.to(
                                  () => NotificationRecieversScreen(
                                    nid: notification.nid,
                                    nName: notification.nName,
                                  ),
                                );
                              },
                              child: AppCard1(
                                child: Padding(
                                  padding: AppPaddings.p10,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        notification.nName,
                                        style: TextStyles.kRegularFredoka(
                                          fontSize: FontSizes.k18FontSize,
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 20,
                                        color: kColorTextPrimary,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
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
