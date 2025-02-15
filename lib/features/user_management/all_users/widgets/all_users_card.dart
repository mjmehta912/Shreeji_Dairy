import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/user_management/all_users/controllers/all_users_controller.dart';
import 'package:shreeji_dairy/features/user_management/manage_user/screens/manage_user_screen.dart';
import 'package:shreeji_dairy/features/user_rights/users/models/user_dm.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/widgets/app_card1.dart';
import 'package:shreeji_dairy/widgets/app_title_value_row.dart';

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
      child: AppCard1(
        child: Padding(
          padding: AppPaddings.p10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${user.firstName} ${user.lastName}',
                    style: TextStyles.kMediumFredoka(
                      color: kColorSecondary,
                    ).copyWith(
                      height: 1.25,
                    ),
                  ),
                  AppTitleValueRow(
                    title: 'Designation',
                    value: _controller.getUserDesignation(user.userType),
                  ),
                  AppTitleValueRow(
                    title: 'Mobile No.',
                    value: user.mobileNo,
                  ),
                  AppTitleValueRow(
                    title: 'App Access',
                    value: user.appAccess ? 'Enabled' : 'Disabled',
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
