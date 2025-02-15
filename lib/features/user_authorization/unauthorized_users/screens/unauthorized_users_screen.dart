import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/user_authorization/unauthorized_users/controllers/unauthorized_users_controller.dart';
import 'package:shreeji_dairy/features/user_authorization/unauthorized_users/widgets/unauthorized_user_card.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_appbar.dart';
import 'package:shreeji_dairy/widgets/app_loading_overlay.dart';
import 'package:shreeji_dairy/widgets/app_text_form_field.dart';

class UnauthorizedUsersScreen extends StatelessWidget {
  UnauthorizedUsersScreen({
    super.key,
  });

  final UnauthorizedUsersController _controller = Get.put(
    UnauthorizedUsersController(),
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
              title: 'Unauthorised Users',
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
                    () => _controller.unAuthorizedUsers.isNotEmpty
                        ? AppTextFormField(
                            controller: _controller.searchController,
                            hintText: 'Search',
                            onChanged: (value) {
                              _controller.filterUsers(value);
                            },
                          )
                        : const SizedBox.shrink(),
                  ),
                  AppSpaces.v10,
                  Obx(
                    () {
                      if (_controller.isLoading.value) {
                        return const SizedBox.shrink();
                      }

                      if (_controller.filteredUnAuthorizedUsers.isEmpty &&
                          !_controller.isLoading.value) {
                        return Expanded(
                          child: Center(
                            child: Text(
                              'No unauthorised users.',
                              style: TextStyles.kRegularFredoka(),
                            ),
                          ),
                        );
                      }

                      return Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount:
                              _controller.filteredUnAuthorizedUsers.length,
                          itemBuilder: (context, index) {
                            final user =
                                _controller.filteredUnAuthorizedUsers[index];
                            return UnauthorizedUserCard(
                              user: user,
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
