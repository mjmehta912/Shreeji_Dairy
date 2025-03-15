import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/notification_master/notification_recievers/controllers/notification_recievers_controller.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_appbar.dart';
import 'package:shreeji_dairy/widgets/app_button.dart';
import 'package:shreeji_dairy/widgets/app_card1.dart';
import 'package:shreeji_dairy/widgets/app_dropdown.dart';
import 'package:shreeji_dairy/widgets/app_loading_overlay.dart';
import 'package:shreeji_dairy/widgets/app_text_form_field.dart';

class NotificationRecieversScreen extends StatefulWidget {
  const NotificationRecieversScreen({
    super.key,
    required this.nid,
    required this.nName,
  });

  final int nid;
  final String nName;

  @override
  State<NotificationRecieversScreen> createState() =>
      _NotificationRecieversScreenState();
}

class _NotificationRecieversScreenState
    extends State<NotificationRecieversScreen> {
  final NotificationRecieversController _controller = Get.put(
    NotificationRecieversController(),
  );

  @override
  void initState() {
    super.initState();
    _controller.getNotificationRecievers(
      nid: widget.nid.toString(),
    );
    _controller.getUsers();
  }

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
              title: widget.nName,
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
                    onChanged: _controller.searchNotificationRecievers,
                  ),
                  AppSpaces.v10,
                  Obx(
                    () {
                      if (_controller.filteredNotificationRecievers.isEmpty &&
                          !_controller.isLoading.value) {
                        return Expanded(
                          child: Center(
                            child: Text(
                              'No Notifications Recievers found.',
                              style: TextStyles.kRegularFredoka(),
                            ),
                          ),
                        );
                      }
                      return Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount:
                              _controller.filteredNotificationRecievers.length,
                          itemBuilder: (context, index) {
                            final notificationReciever = _controller
                                .filteredNotificationRecievers[index];

                            return AppCard1(
                              child: Padding(
                                padding: AppPaddings.p10,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${notificationReciever.firstName} ${notificationReciever.lastName}',
                                      style: TextStyles.kRegularFredoka(
                                        fontSize: FontSizes.k18FontSize,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        _controller.removeReciever(
                                          nid: widget.nid.toString(),
                                          userId: notificationReciever.userId
                                              .toString(),
                                        );
                                      },
                                      child: Icon(
                                        Icons.delete,
                                        size: 20,
                                        color: kColorRed,
                                      ),
                                    ),
                                  ],
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
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              backgroundColor: kColorPrimary,
              shape: const CircleBorder(),
              child: IconButton(
                onPressed: () {
                  _showAddRecieverDialog();
                },
                icon: Icon(
                  Icons.add,
                  size: 25,
                  color: kColorTextPrimary,
                ),
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

  void _showAddRecieverDialog() {
    _controller.selectedUser.value = '';
    _controller.selectedUserId.value = 0;
    Get.dialog(
      Dialog(
        backgroundColor: kColorWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: AppPaddings.p10,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 0.75 * Get.height,
            ),
            child: SingleChildScrollView(
              child: Form(
                key: _controller.notificationRecieverFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Add Reciever',
                        style: TextStyles.kMediumFredoka(
                          fontSize: FontSizes.k20FontSize,
                          color: kColorSecondary,
                        ),
                      ),
                    ),
                    AppSpaces.v10,
                    Obx(
                      () => AppDropdown(
                        items: _controller.userNames,
                        hintText: 'Reciever',
                        onChanged: _controller.onUserSelected,
                        selectedItem: _controller.selectedUser.value.isNotEmpty
                            ? _controller.selectedUser.value
                            : null,
                        validatorText: 'Please select a reciever',
                      ),
                    ),
                    AppSpaces.v20,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AppButton(
                          title: 'Cancel',
                          titleSize: FontSizes.k16FontSize,
                          buttonWidth: 0.2 * Get.width,
                          buttonHeight: 40,
                          onPressed: () => Get.back(),
                        ),
                        AppSpaces.h10,
                        AppButton(
                          title: 'Add',
                          titleSize: FontSizes.k16FontSize,
                          buttonWidth: 0.2 * Get.width,
                          buttonHeight: 40,
                          onPressed: () {
                            if (_controller
                                .notificationRecieverFormKey.currentState!
                                .validate()) {
                              _controller.addReciever(
                                nid: widget.nid.toString(),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
