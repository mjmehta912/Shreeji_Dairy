import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/user_management/all_users/controllers/all_users_controller.dart';
import 'package:shreeji_dairy/features/user_management/all_users/widgets/all_users_card.dart';
import 'package:shreeji_dairy/features/user_management/manage_user/screens/manage_user_screen.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_appbar.dart';
import 'package:shreeji_dairy/widgets/app_loading_overlay.dart';
import 'package:shreeji_dairy/widgets/app_text_form_field.dart';

class AllUsersScreen extends StatelessWidget {
  AllUsersScreen({
    super.key,
  });

  final AllUsersController _controller = Get.put(
    AllUsersController(),
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
              title: 'Users',
              leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 25,
                  color: kColorTextPrimary,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Get.to(
                      () => ManageUserScreen(
                        isEdit: false,
                      ),
                    );
                  },
                  child: Text(
                    '+ New User',
                    style: TextStyles.kRegularFredoka(
                      color: kColorSecondary,
                      fontSize: FontSizes.k16FontSize,
                    ),
                  ),
                ),
              ],
            ),
            body: Padding(
              padding: AppPaddings.p10,
              child: Column(
                children: [
                  AppTextFormField(
                    controller: _controller.searchController,
                    hintText: 'Search',
                    onChanged: (value) {
                      _controller.filterUsers(value);
                    },
                  ),
                  AppSpaces.v10,
                  Obx(
                    () {
                      if (_controller.isLoading.value) {
                        return const SizedBox.shrink();
                      }

                      if (_controller.filteredUsers.isEmpty &&
                          !_controller.isLoading.value) {
                        return Expanded(
                          child: Center(
                            child: Text(
                              'No users found.',
                              style: TextStyles.kMediumFredoka(
                                color: kColorTextPrimary,
                              ),
                            ),
                          ),
                        );
                      }

                      return Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _controller.filteredUsers.length,
                          itemBuilder: (context, index) {
                            final user = _controller.filteredUsers[index];
                            return Column(
                              children: [
                                AllUsersCard(
                                  user: user,
                                  controller: _controller,
                                ),
                                AppSpaces.v4,
                              ],
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
