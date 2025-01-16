import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/user_rights/user_access/screens/user_access_screen.dart.dart';
import 'package:shreeji_dairy/features/user_rights/users/controllers/users_controller.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_appbar.dart';
import 'package:shreeji_dairy/widgets/app_card2.dart';
import 'package:shreeji_dairy/widgets/app_loading_overlay.dart';
import 'package:shreeji_dairy/widgets/app_text_form_field.dart';

class UsersScreen extends StatelessWidget {
  UsersScreen({
    super.key,
  });

  final UsersController _controller = Get.put(
    UsersController(),
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
                                GestureDetector(
                                  onTap: () {
                                    Get.to(
                                      () => UserAccessScreen(
                                        firstName: user.firstName,
                                        lastName: user.lastName,
                                        userId: user.userId,
                                        appAccess: user.appAccess,
                                      ),
                                    );
                                  },
                                  child: AppCard2(
                                    child: Padding(
                                      padding: AppPaddings.p8,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${user.firstName} ${user.lastName}',
                                                style:
                                                    TextStyles.kMediumFredoka(
                                                  color: kColorTextPrimary,
                                                ),
                                              ),
                                              Text(
                                                _controller.getUserDesignation(
                                                    user.userType),
                                                style:
                                                    TextStyles.kRegularFredoka(
                                                  fontSize:
                                                      FontSizes.k16FontSize,
                                                  color: kColorTextPrimary,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: kColorTextPrimary,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
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
