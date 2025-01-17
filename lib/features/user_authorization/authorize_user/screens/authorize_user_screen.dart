import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/user_authorization/authorize_user/controllers/authorize_user_controller.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_appbar.dart';
import 'package:shreeji_dairy/widgets/app_card2.dart';
import 'package:shreeji_dairy/widgets/app_dropdown.dart';
import 'package:shreeji_dairy/widgets/app_loading_overlay.dart';

class AuthorizeUserScreen extends StatelessWidget {
  AuthorizeUserScreen({
    super.key,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.business,
    required this.mobileNo,
  });

  final int userId;
  final String firstName;
  final String lastName;
  final String business;
  final String mobileNo;

  final AuthorizeUserController _controller = Get.put(
    AuthorizeUserController(),
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
              title: 'Authorise User',
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
                  AppCard2(
                    child: Padding(
                      padding: AppPaddings.p10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$firstName $lastName',
                            style: TextStyles.kMediumFredoka(
                              color: kColorSecondary,
                            ).copyWith(
                              height: 1.25,
                            ),
                          ),
                          Text(
                            'Buisness : $business',
                            style: TextStyles.kRegularFredoka(
                              color: kColorTextPrimary,
                              fontSize: FontSizes.k16FontSize,
                            ).copyWith(
                              height: 1.25,
                            ),
                          ),
                          Text(
                            'Mobile : $mobileNo',
                            style: TextStyles.kRegularFredoka(
                              color: kColorTextPrimary,
                              fontSize: FontSizes.k16FontSize,
                            ).copyWith(
                              height: 1.25,
                            ),
                          ),
                          Row(),
                        ],
                      ),
                    ),
                  ),
                  AppSpaces.v10,
                  AppDropdown(
                    items: _controller.userTypes.values.toList(),
                    hintText: 'User Type',
                    showSearchBox: false,
                    onChanged: (selectedValue) {
                      _controller.onUserTypeChanged(selectedValue!);
                    },
                  ),
                  AppSpaces.v10,
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
