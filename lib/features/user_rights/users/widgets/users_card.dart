import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/user_rights/user_access/screens/user_access_screen.dart.dart';
import 'package:shreeji_dairy/features/user_rights/users/controllers/users_controller.dart';
import 'package:shreeji_dairy/features/user_rights/users/models/user_dm.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/widgets/app_card1.dart';
import 'package:shreeji_dairy/widgets/app_title_value_row.dart';

class UsersCard extends StatelessWidget {
  const UsersCard({
    super.key,
    required this.user,
    required UsersController controller,
  }) : _controller = controller;

  final UserDm user;
  final UsersController _controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
