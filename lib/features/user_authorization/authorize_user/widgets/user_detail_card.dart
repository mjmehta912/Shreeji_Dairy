import 'package:flutter/material.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/widgets/app_card1.dart';
import 'package:shreeji_dairy/widgets/app_title_value_row.dart';

class UserDetailCard extends StatelessWidget {
  const UserDetailCard({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.business,
    required this.mobileNo,
  });

  final String firstName;
  final String lastName;
  final String business;
  final String mobileNo;

  @override
  Widget build(BuildContext context) {
    return AppCard1(
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
            AppTitleValueRow(
              title: 'Buisness',
              value: business,
            ),
            AppTitleValueRow(
              title: 'Mobile',
              value: mobileNo,
            ),
            Row(),
          ],
        ),
      ),
    );
  }
}
