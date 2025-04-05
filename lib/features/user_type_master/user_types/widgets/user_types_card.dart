import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/user_type_master/user_type_access/screens/user_type_access_screen.dart';
import 'package:shreeji_dairy/features/user_type_master/user_types/controllers/user_types_controller.dart';
import 'package:shreeji_dairy/features/user_type_master/user_types/models/user_type_dm.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/widgets/app_title_value_row.dart';

class UserTypesCard extends StatelessWidget {
  const UserTypesCard({
    super.key,
    required UserTypesController controller,
    required this.userType,
  }) : _controller = controller;

  final UserTypesController _controller;
  final UserTypeDm userType;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            Get.to(
              () => UserTypeAccessScreen(
                userDesignation:
                    _controller.getUserDesignation(userType.userType),
                userType: userType.userType,
                appAccess: userType.appAccess == 1 ? true : false,
              ),
            );
          },
          leading: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _controller.getUserDesignation(
                  userType.userType,
                ),
                style: TextStyles.kMediumFredoka(
                  color: kColorSecondary,
                ).copyWith(
                  height: 1.25,
                ),
              ),
              AppTitleValueRow(
                title: 'Active Users',
                value: '${userType.activeUsers} out of ${userType.totalUsers}',
              ),
            ],
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: kColorTextPrimary,
          ),
        ),
        Divider(
          color: kColorLightGrey,
          indent: 20,
          endIndent: 20,
        ),
      ],
    );
  }
}
