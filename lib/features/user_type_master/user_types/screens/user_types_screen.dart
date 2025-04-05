import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/profile/controllers/profile_controller.dart';
import 'package:shreeji_dairy/features/user_type_master/user_types/controllers/user_types_controller.dart';
import 'package:shreeji_dairy/features/user_type_master/user_types/widgets/user_types_card.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_appbar.dart';
import 'package:shreeji_dairy/widgets/app_loading_overlay.dart';
import 'package:shreeji_dairy/widgets/app_text_form_field.dart';

class UserTypesScreen extends StatelessWidget {
  UserTypesScreen({
    super.key,
  });

  final UserTypesController _controller = Get.put(
    UserTypesController(),
  );

  final ProfileController profileController = Get.find<ProfileController>();

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
              title: 'User Types',
              leading: IconButton(
                onPressed: () async {
                  Get.back();
                  await profileController.checkVersion();
                },
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
                  AppTextFormField(
                    controller: _controller.searchController,
                    hintText: 'Search',
                    onChanged: (value) {
                      _controller.filterUserTypes(value);
                    },
                  ),
                  AppSpaces.v10,
                  Obx(
                    () {
                      if (_controller.isLoading.value) {
                        return const SizedBox.shrink();
                      }

                      if (_controller.filteredUserTypes.isEmpty &&
                          !_controller.isLoading.value) {
                        return Expanded(
                          child: Center(
                            child: Text(
                              'No user types found.',
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
                          itemCount: _controller.filteredUserTypes.length,
                          itemBuilder: (context, index) {
                            final userType =
                                _controller.filteredUserTypes[index];
                            return UserTypesCard(
                              controller: _controller,
                              userType: userType,
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
