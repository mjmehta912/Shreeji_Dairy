import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/user_authorization/authorize_user/screens/authorize_user_screen.dart';
import 'package:shreeji_dairy/features/user_authorization/unauthorized_users/models/unauthorized_user_dm.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/widgets/app_card1.dart';
import 'package:shreeji_dairy/widgets/app_title_value_row.dart';

class UnauthorizedUserCard extends StatelessWidget {
  const UnauthorizedUserCard({
    super.key,
    required this.user,
  });

  final UnauthorizedUserDm user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => AuthorizeUserScreen(
            userId: user.userId,
            firstName: user.firstName,
            lastName: user.lastName,
            business: user.businessName,
            mobileNo: user.mobileNo,
          ),
        );
      },
      child: AppCard1(
        child: Padding(
          padding: AppPaddings.p10,
          child: Column(
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
                title: 'Buisness',
                value: user.businessName,
              ),
              AppTitleValueRow(
                title: 'Mobile',
                value: user.mobileNo,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
