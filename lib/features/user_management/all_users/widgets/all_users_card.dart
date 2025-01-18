import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/user_management/all_users/controllers/all_users_controller.dart';
import 'package:shreeji_dairy/features/user_management/manage_user/screens/manage_user_screen.dart';
import 'package:shreeji_dairy/features/user_rights/users/models/user_dm.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/widgets/app_card2.dart';

class AllUsersCard extends StatelessWidget {
  const AllUsersCard({
    super.key,
    required this.user,
    required AllUsersController controller,
  }) : _controller = controller;

  final UserDm user;
  final AllUsersController _controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => ManageUserScreen(
            isEdit: true,
            firstName: user.firstName,
            lastName: user.lastName,
            mobileNo: user.mobileNo,
            userId: user.userId,
            isAppAccess: user.appAccess,
            userType: user.userType,
            seCode: user.seCodes,
            storePCode: user.storePCode,
            pCodes: user.pCodes,
          ),
        );
      },
      child: AppCard2(
        child: Padding(
          padding: AppPaddings.p8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${user.firstName} ${user.lastName}',
                    style: TextStyles.kMediumFredoka(
                      color: kColorTextPrimary,
                    ),
                  ),
                  Text(
                    _controller.getUserDesignation(user.userType),
                    style: TextStyles.kRegularFredoka(
                      fontSize: FontSizes.k16FontSize,
                      color: kColorTextPrimary,
                    ),
                  ),
                  Text(
                    user.mobileNo,
                    style: TextStyles.kRegularFredoka(
                      fontSize: FontSizes.k16FontSize,
                      color: kColorTextPrimary,
                    ),
                  ),
                  Text(
                    user.appAccess
                        ? 'App Access : Enabled'
                        : 'App Access : Disabled',
                    style: TextStyles.kRegularFredoka(
                      fontSize: FontSizes.k16FontSize,
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
    );
  }
}
